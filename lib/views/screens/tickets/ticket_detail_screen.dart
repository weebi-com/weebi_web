import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:protos_weebi/protos_weebi_io.dart'
    show TicketPb, FindTicketRequest;
import 'package:web_admin/app_router.dart';
import 'package:web_admin/providers/server.dart';
import 'package:web_admin/providers/tickets_boutique_cache.dart';
import 'package:web_admin/views/screens/tickets/ticket_detail_body.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../core/constants/dimens.dart';

/// Full detail view of a ticket using dynamic protobuf display.
class TicketDetailScreen extends StatefulWidget {
  final TicketPb? ticket;

  const TicketDetailScreen({super.key, this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  TicketPb? _ticket;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ticket == null) {
        _loadFromRoute();
      }
      context.read<TicketsBoutiqueCache>().loadIfNeeded();
    });
  }

  Future<void> _loadFromRoute() async {
    // If no ticket passed, we can't load - show error
    setState(() {
      _errorMessage = 'Ticket non fourni';
    });
  }

  Future<void> _refreshTicket() async {
    if (_ticket == null) return;

    final counterfoil = _ticket!.counterfoil;
    if (counterfoil.chainId.isEmpty ||
        counterfoil.boutiqueId.isEmpty ||
        _ticket!.creationDate.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stub =
          context.read<TicketServiceClientProvider>().ticketServiceClient;
      final request = FindTicketRequest()
        ..ticketChainId = counterfoil.chainId
        ..ticketBoutiqueId = counterfoil.boutiqueId
        ..creationDate = _ticket!.creationDate
        ..ticketUserId = counterfoil.userId
        ..nonUniqueId = _ticket!.nonUniqueId;

      final ticket = await stub.readOne(request);

      setState(() {
        _ticket = ticket;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(RouteUri.ticketsOverview),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Détail du ticket #${_ticket?.nonUniqueId ?? '?'}',
                  style: themeData.textTheme.headlineMedium,
                ),
              ),
              if (_ticket != null)
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _refreshTicket,
                  tooltip: 'Actualiser',
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: themeData.colorScheme.error),
                      ),
                    )
                  else if (_ticket == null)
                    const Padding(
                      padding: EdgeInsets.all(kDefaultPadding * 2),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: TicketDetailBody(
                        ticket: _ticket!,
                        boutiqueCache: context.read<TicketsBoutiqueCache>(),
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
