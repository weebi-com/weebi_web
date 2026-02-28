import 'dart:math';

import 'package:auth_weebi/auth_weebi.dart' show AccessTokenProvider;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:boutiques_weebi/boutiques_weebi.dart' show BoutiqueProvider;
import 'package:design_weebi/design_weebi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:models_weebi/models.dart' show TicketType;
import 'package:provider/provider.dart';
import 'package:protos_weebi/protos_weebi_io.dart'
    show ReadAllTicketsRequest, TicketPb;
import 'package:web_admin/app_router.dart';
import 'package:web_admin/providers/server.dart';
import 'package:web_admin/providers/tickets_boutique_cache.dart';
import 'package:web_admin/views/screens/tickets/ticket_glimpse_widget.dart';
import 'package:web_admin/views/screens/tickets/ticket_pb_to_weebi.dart';
import 'package:web_admin/views/screens/tickets/tickets_filter_bar.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/theme_extensions/app_data_table_theme.dart';

/// Wrapper to track soft-deleted tickets (TicketPb has no isDeleted field).
class _TicketWithMeta {
  final TicketPb ticket;
  final bool isSoftDeleted;

  _TicketWithMeta(this.ticket, this.isSoftDeleted);
}

/// Displays tickets with filters: date range, status (active/inactive), soft-deleted.
/// Fetches all tickets for the user's chain, then filters client-side.
class TicketsOverviewScreen extends StatefulWidget {
  const TicketsOverviewScreen({super.key});

  @override
  State<TicketsOverviewScreen> createState() => _TicketsOverviewScreenState();
}

class _TicketsOverviewScreenState extends State<TicketsOverviewScreen> {
  List<_TicketWithMeta> _allTickets = [];
  bool _isLoading = true;
  String? _errorMessage;
  TicketsFilterState _filter = const TicketsFilterState();
  final _tableScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTickets();
      _ensureBoutiqueCache();
    });
  }

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
  }

  Future<void> _ensureBoutiqueCache() async {
    final cache = context.read<TicketsBoutiqueCache>();
    await cache.loadIfNeeded();
    if (!mounted) return;
    final bp = context.read<BoutiqueProvider>();
    if (bp.chains.isNotEmpty) {
      cache.mergeLogosFromBoutiqueMongo(bp.allBoutiques);
    }
  }

  String? _getChainId() {
    try {
      return context.read<AccessTokenProvider>().permissions.firmId;
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadTickets() async {
    final chainId = _getChainId();
    if (chainId == null || chainId.isEmpty) {
      setState(() {
        _errorMessage = 'Chaîne non disponible';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stub =
          context.read<TicketServiceClientProvider>().ticketServiceClient;

      final List<_TicketWithMeta> all = [];

      switch (_filter.deletedFilter) {
        case DeletedFilter.exclude:
          final res = await stub.readAll(
            ReadAllTicketsRequest()..chainId = chainId..isDeleted = false,
          );
          all.addAll(res.tickets.map((t) => _TicketWithMeta(t, false)));
          break;
        case DeletedFilter.include:
          final nonDeletedRes = await stub.readAll(
            ReadAllTicketsRequest()..chainId = chainId..isDeleted = false,
          );
          final deletedRes = await stub.readAll(
            ReadAllTicketsRequest()..chainId = chainId..isDeleted = true,
          );
          all.addAll(nonDeletedRes.tickets.map((t) => _TicketWithMeta(t, false)));
          all.addAll(deletedRes.tickets.map((t) => _TicketWithMeta(t, true)));
          break;
        case DeletedFilter.only:
          final res = await stub.readAll(
            ReadAllTicketsRequest()..chainId = chainId..isDeleted = true,
          );
          all.addAll(res.tickets.map((t) => _TicketWithMeta(t, true)));
          break;
      }

      all.sort((a, b) => b.ticket.creationDate.compareTo(a.ticket.creationDate));

      setState(() {
        _allTickets = all;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<BoutiqueOption> _extractBoutiques(
    List<_TicketWithMeta> tickets,
    TicketsBoutiqueCache cache,
  ) {
    final seen = <String>{};
    final list = <BoutiqueOption>[];
    for (final m in tickets) {
      final id = m.ticket.counterfoil.boutiqueId.trim();
      if (id.isEmpty) continue;
      if (seen.contains(id)) continue;
      seen.add(id);
      final fromTicket = m.ticket.counterfoil.boutiqueName.trim();
      final name = fromTicket.isNotEmpty
          ? fromTicket
          : cache.getName(id);
      final logo = cache.getLogo(id);
      final logoExt = cache.getLogoExtension(id);
      list.add(BoutiqueOption(
        id: id,
        name: name,
        logo: logo?.toList(),
        logoExtension: logoExt,
      ));
    }
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  List<_TicketWithMeta> _applyFilters(List<_TicketWithMeta> tickets) {
    var result = tickets;

    // Date range filter
    if (_filter.dateFrom != null || _filter.dateTo != null) {
      result = result.where((m) {
        final date = _parseCreationDate(m.ticket.creationDate);
        if (date == null) return false;
        if (_filter.dateFrom != null) {
          final fromStart = DateTime(
              _filter.dateFrom!.year, _filter.dateFrom!.month, _filter.dateFrom!.day);
          if (date.isBefore(fromStart)) return false;
        }
        if (_filter.dateTo != null) {
          final toEnd = DateTime(
              _filter.dateTo!.year, _filter.dateTo!.month, _filter.dateTo!.day, 23, 59, 59);
          if (date.isAfter(toEnd)) return false;
        }
        return true;
      }).toList();
    }

    // Status filter (active/inactive)
    if (_filter.statusActive != null) {
      result = result
          .where((m) => m.ticket.status == _filter.statusActive)
          .toList();
    }

    // Boutique filter
    if (_filter.boutiqueId != null && _filter.boutiqueId!.isNotEmpty) {
      result = result
          .where((m) => m.ticket.counterfoil.boutiqueId == _filter.boutiqueId)
          .toList();
    }

    // Sort: if group by boutique, sort by boutique then date; else by date only
    if (_filter.groupByBoutique) {
      result = List.from(result)
        ..sort((a, b) {
          final aName = a.ticket.counterfoil.boutiqueName.trim();
          final bName = b.ticket.counterfoil.boutiqueName.trim();
          final cmp = (aName.isEmpty ? a.ticket.counterfoil.boutiqueId : aName)
              .compareTo(bName.isEmpty ? b.ticket.counterfoil.boutiqueId : bName);
          if (cmp != 0) return cmp;
          return b.ticket.creationDate.compareTo(a.ticket.creationDate);
        });
    } else {
      result = List.from(result)
        ..sort((a, b) => b.ticket.creationDate.compareTo(a.ticket.creationDate));
    }

    return result;
  }

  DateTime? _parseCreationDate(String s) {
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  Widget _buildGroupedList(
    List<_TicketWithMeta> filtered,
    TicketsBoutiqueCache cache,
  ) {
    if (filtered.isEmpty) return const SizedBox.shrink();
    final themeData = Theme.of(context);
    String? lastBoutique;
    final children = <Widget>[];
    for (final meta in filtered) {
      final name = meta.ticket.counterfoil.boutiqueName.trim();
      final id = meta.ticket.counterfoil.boutiqueId.trim();
      final boutiqueKey = name.isNotEmpty ? name : (id.isNotEmpty ? id : '—');
      if (boutiqueKey != lastBoutique) {
        lastBoutique = boutiqueKey;
        children.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: 8,
            ),
            color: themeData.colorScheme.surfaceContainerHighest,
            child: Text(
              boutiqueKey,
              style: themeData.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: themeData.colorScheme.primary,
              ),
            ),
          ),
        );
      }
      children.add(
        TicketGlimpseWidget(
          ticket: meta.ticket,
          onTap: () => _openTicketDetail(meta.ticket),
          isSoftDeleted: meta.isSoftDeleted,
          boutiqueCache: cache,
        ),
      );
      children.add(const Divider(height: 1));
    }
    if (children.isNotEmpty && children.last is Divider) {
      children.removeLast();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void _openTicketDetail(TicketPb ticket) {
    context.push(
      RouteUri.ticketDetail,
      extra: ticket,
    );
  }

  void _onFilterChanged(TicketsFilterState filter) {
    final prevDeleted = _filter.deletedFilter;
    setState(() => _filter = filter);
    if (filter.deletedFilter != prevDeleted) {
      _loadTickets();
    }
  }

  bool _useDataTable(BuildContext context) {
    return MediaQuery.of(context).size.width >= kScreenWidthLg &&
        !_filter.groupByBoutique;
  }

  Widget _buildTicketsTable(
    List<_TicketWithMeta> filtered,
    TicketsBoutiqueCache cache,
  ) {
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    final source = _TicketsTableSource(
      tickets: filtered,
      cache: cache,
      onTap: _openTicketDetail,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final dataTableWidth = max(kScreenWidthMd, constraints.maxWidth);
        return Scrollbar(
          controller: _tableScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _tableScrollController,
            child: SizedBox(
              width: dataTableWidth,
              child: Theme(
                data: themeData.copyWith(
                  cardTheme: appDataTableTheme.cardTheme,
                  dataTableTheme: appDataTableTheme.dataTableThemeData,
                ),
                child: PaginatedDataTable(
                  source: source,
                  rowsPerPage: 20,
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  columns: const [
                    DataColumn(label: Text('Boutique')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Montant'), numeric: true),
                    DataColumn(label: Text('Contact')),
                    DataColumn(label: Text('Date · n°')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final filtered = _applyFilters(_allTickets);
    final cache = context.watch<TicketsBoutiqueCache>();
    final useTable = _useDataTable(context);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            'Tickets',
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: TicketsFilterBar(
              filter: _filter,
              onFilterChanged: _onFilterChanged,
              availableBoutiques: _extractBoutiques(_allTickets, cache),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${filtered.length} ticket(s)',
                          style: themeData.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _isLoading ? null : _loadTickets,
                        tooltip: 'Actualiser',
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(kDefaultPadding * 2),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: themeData.colorScheme.error),
                    ),
                  )
                else if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(kDefaultPadding * 2),
                    child: Center(
                      child: Text('Aucun ticket'),
                    ),
                  )
                else if (_filter.groupByBoutique)
                  _buildGroupedList(filtered, cache)
                else if (useTable)
                  _buildTicketsTable(filtered, cache)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final meta = filtered[index];
                      return TicketGlimpseWidget(
                        ticket: meta.ticket,
                        onTap: () => _openTicketDetail(meta.ticket),
                        isSoftDeleted: meta.isSoftDeleted,
                        boutiqueCache: cache,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// DataTableSource for tickets on large screens.
class _TicketsTableSource extends DataTableSource {
  static final _numFormat = NumberFormat.decimalPattern();

  final List<_TicketWithMeta> tickets;
  final TicketsBoutiqueCache cache;
  final void Function(TicketPb) onTap;

  _TicketsTableSource({
    required this.tickets,
    required this.cache,
    required this.onTap,
  });

  TicketType _toTicketType(dynamic pbType) =>
      TicketType.tryParse(pbType?.name ?? '');

  String _typeLabel(TicketType type) {
    final name = type.toString();
    if (name.isEmpty) return 'Ticket';
    return name[0].toUpperCase() + name.substring(1).replaceAll('_', ' ');
  }

  String _getAmount(_TicketWithMeta meta) {
    if (meta.isSoftDeleted || !meta.ticket.status) return '—';
    final type = _toTicketType(meta.ticket.ticketType);
    if (meta.ticket.received > 0) {
      return _numFormat.format(meta.ticket.received);
    }
    // For deferred (sellDeferred, spendDeferred) received is 0; use total from items
    if (type.isFinancial && meta.ticket.items.isNotEmpty) {
      try {
        final ticketW = ticketPbToWeebi(meta.ticket);
        return _numFormat.format(ticketW.total);
      } catch (_) {
        return '${meta.ticket.items.length} art.';
      }
    }
    return meta.ticket.items.isEmpty
        ? '—'
        : '${meta.ticket.items.length} art.';
  }

  String _paymentLabel(dynamic pb) {
    final s = pb?.name ?? '';
    if (s.isEmpty) return '—';
    const map = {
      'cash': 'Espèces',
      'mobileMoney': 'Mobile Money',
      'nope': 'Crédit',
      'cheque': 'Chèque',
      'creditCard': 'Carte',
      'goods': 'Marchandises',
      'unknown': '—',
    };
    return map[s] ?? s;
  }

  String _getBoutiqueName(_TicketWithMeta meta) {
    final fromTicket = meta.ticket.counterfoil.boutiqueName.trim();
    if (fromTicket.isNotEmpty) return fromTicket;
    final id = meta.ticket.counterfoil.boutiqueId.trim();
    if (id.isEmpty) return '';
    final cached = cache.getName(id);
    return cached.isNotEmpty ? cached : id;
  }

  Widget? _getBoutiqueIcon(_TicketWithMeta meta) {
    final id = meta.ticket.counterfoil.boutiqueId.trim();
    if (id.isEmpty || !cache.hasLogo(id)) return null;
    final logo = cache.getLogo(id);
    if (logo == null) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.memory(
        logo,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.storefront, size: 24),
      ),
    );
  }

  String _getContactName(_TicketWithMeta meta) {
    final first = meta.ticket.contactFirstName.trim();
    final last = meta.ticket.contactLastName.trim();
    if (first.isEmpty && last.isEmpty) return '';
    return '$first $last'.trim();
  }

  String _getDateAndId(_TicketWithMeta meta) {
    final date = meta.ticket.date;
    final id = meta.ticket.nonUniqueId;
    if (id == 0) return date;
    return '$date · n°$id';
  }

  @override
  DataRow? getRow(int index) {
    if (index >= tickets.length) return null;
    final meta = tickets[index];
    final isActive = meta.ticket.status && !meta.isSoftDeleted;
    final type = _toTicketType(meta.ticket.ticketType);
    final iconColor = isActive ? type.iconColor : ColorsWeebi.greyTicket;
    final textColor = isActive ? null : Colors.grey.shade600;

    TextStyle textStyle(Color? color) => TextStyle(
          color: color ?? textColor,
          fontStyle: !isActive ? FontStyle.italic : FontStyle.normal,
        );

    final boutiqueName = _getBoutiqueName(meta);
    final boutiqueIcon = _getBoutiqueIcon(meta);

    return DataRow(
      onSelectChanged: (_) => onTap(meta.ticket),
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (boutiqueIcon != null) ...[boutiqueIcon, const SizedBox(width: 6)],
              Text(
                boutiqueName.isEmpty ? '—' : boutiqueName,
                style: textStyle(null),
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.iconData, color: iconColor, size: 20),
                  const SizedBox(width: 6),
                  Text(_typeLabel(type), style: textStyle(null)),
                ],
              ),
              if (type.isFinancial) ...[
                const SizedBox(height: 2),
                Text(
                  _paymentLabel(meta.ticket.paymentType),
                  style: textStyle(null).copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        DataCell(Text(_getAmount(meta), style: textStyle(null))),
        DataCell(
          Text(
            _getContactName(meta).isEmpty ? '—' : _getContactName(meta),
            style: textStyle(null),
          ),
        ),
        DataCell(Text(_getDateAndId(meta), style: textStyle(null))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tickets.length;

  @override
  int get selectedRowCount => 0;
}
