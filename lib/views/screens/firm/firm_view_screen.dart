import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protos_weebi/grpc.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/core/services/firm_service.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/theme_extensions/app_button_theme.dart';
import '../../../core/theme/theme_extensions/app_color_scheme.dart';

class FirmListScreen extends StatefulWidget {
  const FirmListScreen({super.key});

  @override
  State<FirmListScreen> createState() => _FirmListScreenState();
}

class _FirmListScreenState extends State<FirmListScreen> {
  final FirmService _firmService = FirmService();
  Firm? currentFirm;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserFirm();
  }

  Future<void> _loadUserFirm() async {
    try {
      final firm = await _firmService.readOneFirm();
      setState(() {
        currentFirm = firm;
        errorMessage = null;
      });
    } catch (error) {
      if (error is GrpcError && error.code == 7) {
        setState(() {
          errorMessage =
              "Veuillez créer une nouvelle firme en cliquant sur le bouton 'Ajouter une firme'.";
        });
      } else {
        setState(() {
          errorMessage = "Une erreur inattendue est survenue.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            'Ma firme',
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title:
                        "La firme représente votre entreprise, elle regroupe vos utilisateurs et vos chaînes/boutiques",
                  ),
                  CardBody(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: kDefaultPadding * 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPadding),
                                  child: Chip(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical: 6.0,
                                    ),
                                    backgroundColor: appColorScheme.error,
                                    label: Text(
                                      errorMessage!,
                                      style: TextStyle(
                                        color: themeData.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              else if (currentFirm != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Nom de la firme:',
                                        style: TextStyle(
                                          fontSize: themeData
                                              .textTheme.bodyLarge!.fontSize,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        currentFirm!.name,
                                        style: TextStyle(
                                          fontSize: themeData
                                              .textTheme.bodyLarge!.fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Visibility(
                                visible: currentFirm == null,
                                child: SizedBox(
                                  height: 40.0,
                                  child: ElevatedButton(
                                    style: themeData
                                        .extension<AppButtonTheme>()!
                                        .successElevated,
                                    onPressed: () => GoRouter.of(context)
                                        .go(RouteUri.createFirm),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding * 0.5),
                                          child: Icon(
                                            Icons.add,
                                            size: (themeData.textTheme
                                                    .labelLarge!.fontSize! +
                                                4.0),
                                          ),
                                        ),
                                        const Text("Ajouter une firme"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: kDefaultPadding),
                          child: Row(
                            children: [
                              Text(
                                'Date de création (UTC):',
                                style: TextStyle(
                                  fontSize:
                                      themeData.textTheme.bodyLarge!.fontSize,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                currentFirm!.creationDateUTC
                                    .toDateTime()
                                    .toIso8601String(),
                                style: TextStyle(
                                  fontSize:
                                      themeData.textTheme.bodyLarge!.fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
