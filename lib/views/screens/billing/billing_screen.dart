// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:provider/provider.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/providers/server.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/theme_extensions/app_color_scheme.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<License> _licenses = [];
  List<BillingProduct> _products = [];
  bool _loading = true;
  String? _errorMessage;
  String? _checkoutProductId;

  @override
  void initState() {
    super.initState();
    _loadData();
    // If returning from Stripe success with session_id, sync license (webhook may have failed)
    final uri = Uri.base;
    final sessionId = uri.queryParameters['session_id'];
    if (uri.queryParameters['success'] == 'true' && sessionId != null && sessionId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final provider = context.read<BillingServiceClientProvider>();
        try {
          await provider.billingServiceClient.fulfillFromStripeCheckoutSession(
            FulfillFromStripeCheckoutSessionRequest(checkoutSessionId: sessionId),
          );
        } catch (_) {
          // Idempotent: already fulfilled or not paid yet; loadData will show current state
        }
        if (mounted) _loadData();
      });
    } else if (uri.queryParameters['canceled'] == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadData();
      });
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final provider = context.read<BillingServiceClientProvider>();
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final licensesFuture =
          provider.billingServiceClient.readLicenses(Empty());
      final productsFuture =
          provider.billingServiceClient.readBillingProducts(Empty());

      final results = await Future.wait([licensesFuture, productsFuture]);
      final licensesResponse = results[0] as ReadLicensesResponse;
      final productsResponse = results[1] as ReadBillingProductsResponse;

      if (mounted) {
        setState(() {
          _licenses = licensesResponse.licenses;
          _products = productsResponse.products;
          _loading = false;
          _errorMessage = null;
        });
      }
    } on GrpcError catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = e.message ?? 'An error occurred';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _purchaseProduct(BillingProduct product) async {
    if (!mounted) return;
    final provider = context.read<BillingServiceClientProvider>();
    final stripePriceId = product.stripePriceId;
    if (stripePriceId.isEmpty) return;

    setState(() => _checkoutProductId = product.productId);

    try {
      final baseUrl = '${html.window.location.origin}${RouteUri.billing}';
      final request = CreateCheckoutSessionRequest(
        priceId: stripePriceId,
        successUrl: '$baseUrl?success=true&session_id={CHECKOUT_SESSION_ID}',
        cancelUrl: '$baseUrl?canceled=true',
      );

      final response = await provider.billingServiceClient
          .createCheckoutSession(request);

      if (response.checkoutUrl.isNotEmpty && mounted) {
        html.window.location.href = response.checkoutUrl;
      }
    } on GrpcError catch (e) {
      if (mounted) {
        setState(() {
          _checkoutProductId = null;
          _errorMessage = e.message ?? 'Checkout failed';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _checkoutProductId = null;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;
    final lang = Lang.of(context);
    final totalSeats = _licenses.fold<int>(0, (sum, l) => sum + l.maxUsers);
    final returnedFromSuccess =
        Uri.base.queryParameters['success'] == 'true' && !_loading;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.menuBilling,
            style: themeData.textTheme.headlineMedium,
          ),
          if (returnedFromSuccess) ...[
            Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding),
              child: Material(
                color: _licenses.isNotEmpty
                    ? themeData.colorScheme.primaryContainer
                    : themeData.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding * 0.75,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _licenses.isNotEmpty
                            ? Icons.check_circle_outline_rounded
                            : Icons.schedule_rounded,
                        color: _licenses.isNotEmpty
                            ? themeData.colorScheme.onPrimaryContainer
                            : themeData.colorScheme.onSecondaryContainer,
                        size: 24,
                      ),
                      const SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Text(
                          _licenses.isNotEmpty
                              ? lang.billingPaymentSuccess
                              : lang.billingPaymentProcessing,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: _licenses.isNotEmpty
                                ? themeData.colorScheme.onPrimaryContainer
                                : themeData.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_loading)
                    const CardBody(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(kDefaultPadding * 2),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    CardBody(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 6.0,
                            ),
                            backgroundColor: appColorScheme.error,
                            label: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: themeData.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: kDefaultPadding),
                            child: TextButton.icon(
                              onPressed: _loadData,
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(lang.billingRetry),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_licenses.isEmpty) ...[
                    CardHeader(title: lang.billingPurchaseLicense),
                    CardBody(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.billingPurchaseLicenseDescription,
                            style: themeData.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: kDefaultPadding * 2),
                          Wrap(
                            spacing: kDefaultPadding,
                            runSpacing: kDefaultPadding,
                            children: _products
                                .map((p) => _ProductOfferCard(
                                      product: p,
                                      onPurchase: () => _purchaseProduct(p),
                                      isLoading: _checkoutProductId == p.productId,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    CardHeader(title: lang.billingMyLicenses),
                    CardBody(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (totalSeats > 0) ...[
                            Row(
                              children: [
                                Text(
                                  '${lang.billingUsers}: $totalSeats',
                                  style: themeData.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: kDefaultPadding),
                          ],
                          ..._licenses.map(
                            (license) => _LicenseCard(license: license),
                          ),
                          if (_products.isNotEmpty) ...[
                            const SizedBox(height: kDefaultPadding * 2),
                            const Divider(),
                            const SizedBox(height: kDefaultPadding * 2),
                            Text(
                              lang.billingPurchaseLicense,
                              style: themeData.textTheme.titleMedium,
                            ),
                            const SizedBox(height: kDefaultPadding),
                            Wrap(
                              spacing: kDefaultPadding,
                              runSpacing: kDefaultPadding,
                              children: _products
                                  .map((p) => _ProductOfferCard(
                                        product: p,
                                        onPurchase: () => _purchaseProduct(p),
                                        isLoading: _checkoutProductId == p.productId,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductOfferCard extends StatelessWidget {
  final BillingProduct product;
  final VoidCallback onPurchase;
  final bool isLoading;

  const _ProductOfferCard({
    required this.product,
    required this.onPurchase,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final priceStr = (product.amountCents / 100).toStringAsFixed(2);
    final currency =
        product.currency.isNotEmpty ? product.currency.toUpperCase() : 'EUR';
    final planName = _planDisplayName(product.productId);

    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                planName,
                style: themeData.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${product.maxUsers} ${Lang.of(context).billingUsers}',
                style: themeData.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$priceStr $currency',
                style: themeData.textTheme.headlineSmall!.copyWith(
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading ? null : onPurchase,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(Lang.of(context).billingPurchase),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _planDisplayName(String productId) {
    switch (productId.toLowerCase()) {
      case 'solo':
        return 'Solo';
      case 'trio':
        return 'Trio';
      case 'pro':
        return 'Pro';
      default:
        return productId;
    }
  }
}

class _LicenseCard extends StatelessWidget {
  final License license;

  const _LicenseCard({required this.license});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final planName = _planDisplayName(license.licensePlan);
    final validUntil = license.hasValidUntil()
        ? _formatTimestamp(license.validUntil)
        : Lang.of(context).billingLifetime;
    final purchasedOn =
        license.hasValidFrom() ? _formatTimestamp(license.validFrom) : null;

    return Card(
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  planName,
                  style: themeData.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '${license.maxUsers} ${Lang.of(context).billingUsers}',
                    style: themeData.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            if (license.licenseId.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'ID: ${license.licenseId}',
                  style: themeData.textTheme.bodySmall,
                ),
              ),
            if (purchasedOn != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Purchased on: $purchasedOn',
                  style: themeData.textTheme.bodySmall,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${Lang.of(context).billingValidUntil}: $validUntil',
                style: themeData.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _planDisplayName(LicensePlan plan) {
    switch (plan) {
      case LicensePlan.SOLO:
        return 'Solo';
      case LicensePlan.TRIO:
        return 'Trio';
      case LicensePlan.PRO:
        return 'Pro';
      default:
        return plan.name;
    }
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      ts.seconds.toInt() * 1000,
      isUtc: true,
    );
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
