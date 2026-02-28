import 'dart:typed_data';

import 'package:flutter/material.dart';

/// How to filter soft-deleted tickets.
enum DeletedFilter {
  exclude, // only non-deleted (default)
  include, // both non-deleted and deleted (kept for backward compat, no longer in UI)
  only, // only deleted (auditing)
}

/// A boutique option for filtering and display.
class BoutiqueOption {
  final String id;
  final String name;
  final List<int>? logo;
  final String? logoExtension;

  const BoutiqueOption({
    required this.id,
    required this.name,
    this.logo,
    this.logoExtension,
  });

  bool get hasLogo =>
      logo != null &&
      logo!.isNotEmpty &&
      (logoExtension?.isNotEmpty ?? false);
}

/// Filter state for tickets overview.
class TicketsFilterState {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool? statusActive; // null = all, true = active, false = inactive
  final DeletedFilter deletedFilter;
  final String? boutiqueId; // null = all boutiques
  final bool groupByBoutique;

  const TicketsFilterState({
    this.dateFrom,
    this.dateTo,
    this.statusActive,
    this.deletedFilter = DeletedFilter.exclude,
    this.boutiqueId,
    this.groupByBoutique = false,
  });

  TicketsFilterState copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? statusActive,
    DeletedFilter? deletedFilter,
    String? boutiqueId,
    bool? groupByBoutique,
  }) {
    return TicketsFilterState(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      statusActive: statusActive ?? this.statusActive,
      deletedFilter: deletedFilter ?? this.deletedFilter,
      boutiqueId: boutiqueId ?? this.boutiqueId,
      groupByBoutique: groupByBoutique ?? this.groupByBoutique,
    );
  }
}

/// Filter bar for tickets: date range, status, soft-deleted, boutique, group.
class TicketsFilterBar extends StatelessWidget {
  final TicketsFilterState filter;
  final ValueChanged<TicketsFilterState> onFilterChanged;
  final List<BoutiqueOption> availableBoutiques;

  const TicketsFilterBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    this.availableBoutiques = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtres',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DateRangeChip(
                  dateFrom: filter.dateFrom,
                  dateTo: filter.dateTo,
                  onChanged: (from, to) =>
                      onFilterChanged(filter.copyWith(dateFrom: from, dateTo: to)),
                ),
                _StatusFilterChip(
                  statusActive: filter.statusActive,
                  onChanged: (v) =>
                      onFilterChanged(filter.copyWith(statusActive: v)),
                ),
                _DeletedFilterChip(
                  deletedFilter: filter.deletedFilter,
                  onChanged: (v) =>
                      onFilterChanged(filter.copyWith(deletedFilter: v)),
                ),
                _BoutiqueFilterChip(
                  boutiqueId: filter.boutiqueId,
                  availableBoutiques: availableBoutiques,
                  onChanged: (v) => onFilterChanged(
                    v == null
                        ? TicketsFilterState(
                            dateFrom: filter.dateFrom,
                            dateTo: filter.dateTo,
                            statusActive: filter.statusActive,
                            deletedFilter: filter.deletedFilter,
                            boutiqueId: null,
                            groupByBoutique: filter.groupByBoutique,
                          )
                        : filter.copyWith(boutiqueId: v),
                  ),
                ),
                _GroupByBoutiqueChip(
                  groupByBoutique: filter.groupByBoutique,
                  onChanged: (v) =>
                      onFilterChanged(filter.copyWith(groupByBoutique: v)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRangeChip extends StatelessWidget {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final void Function(DateTime? from, DateTime? to) onChanged;

  const _DateRangeChip({
    required this.dateFrom,
    required this.dateTo,
    required this.onChanged,
  });

  String get _label {
    if (dateFrom == null && dateTo == null) return 'Toutes les dates';
    final from = dateFrom != null
        ? '${dateFrom!.day}/${dateFrom!.month}/${dateFrom!.year}'
        : '…';
    final to = dateTo != null
        ? '${dateTo!.day}/${dateTo!.month}/${dateTo!.year}'
        : '…';
    return '$from → $to';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputChip(
          avatar: const Icon(Icons.calendar_today, size: 18),
          label: Text(_label),
          onPressed: () => _showDatePicker(context),
        ),
        if (dateFrom != null || dateTo != null)
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () => onChanged(null, null),
            tooltip: 'Toutes les dates',
          ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final from = dateFrom ?? now.subtract(const Duration(days: 30));
    final to = dateTo ?? now;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: from, end: to),
    );
    if (picked != null && context.mounted) {
      onChanged(picked.start, picked.end);
    }
  }
}

class _StatusFilterChip extends StatelessWidget {
  final bool? statusActive;
  final void Function(bool?) onChanged;

  const _StatusFilterChip({
    required this.statusActive,
    required this.onChanged,
  });

  String get _label {
    if (statusActive == null) return 'Tous';
    return statusActive! ? 'Actifs' : 'Inactifs';
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<bool?>(
      tooltip: 'Filtrer par statut',
      itemBuilder: (_) => [
        const PopupMenuItem(value: null, child: Text('Tous')),
        const PopupMenuItem(value: true, child: Text('Actifs')),
        const PopupMenuItem(value: false, child: Text('Inactifs')),
      ],
      onSelected: onChanged,
      child: InputChip(
        avatar: Icon(
          statusActive == null ? Icons.filter_list : Icons.check_circle_outline,
          size: 18,
          color: statusActive == true
              ? Colors.green
              : statusActive == false
                  ? Colors.grey
                  : null,
        ),
        label: Text(_label),
      ),
    );
  }
}

class _DeletedFilterChip extends StatelessWidget {
  final DeletedFilter deletedFilter;
  final void Function(DeletedFilter) onChanged;

  const _DeletedFilterChip({
    required this.deletedFilter,
    required this.onChanged,
  });

  String get _label {
    switch (deletedFilter) {
      case DeletedFilter.exclude:
        return 'Sans supprimés';
      case DeletedFilter.include:
        return 'Avec supprimés';
      case DeletedFilter.only:
        return 'Supprimés uniquement';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DeletedFilter>(
      tooltip: 'Filtrer par tickets supprimés',
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: DeletedFilter.exclude,
          child: Text('Sans supprimés'),
        ),
        const PopupMenuItem(
          value: DeletedFilter.only,
          child: Text('Supprimés uniquement (audit)'),
        ),
      ],
      onSelected: onChanged,
      child: InputChip(
        avatar: Icon(
          Icons.delete_outline,
          size: 18,
          color: deletedFilter == DeletedFilter.only
              ? Colors.red
              : deletedFilter == DeletedFilter.include
                  ? Colors.orange
                  : null,
        ),
        label: Text(_label),
      ),
    );
  }
}

class _BoutiqueFilterChip extends StatelessWidget {
  final String? boutiqueId;
  final List<BoutiqueOption> availableBoutiques;
  final void Function(String?) onChanged;

  const _BoutiqueFilterChip({
    required this.boutiqueId,
    required this.availableBoutiques,
    required this.onChanged,
  });

  String get _label {
    if (boutiqueId == null) return 'Toutes les boutiques';
    final b = availableBoutiques.where((x) => x.id == boutiqueId).firstOrNull;
    return b?.name ?? boutiqueId ?? 'Boutique';
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      tooltip: 'Filtrer par boutique',
      itemBuilder: (_) => [
        const PopupMenuItem(value: null, child: Text('Toutes les boutiques')),
        ...availableBoutiques.map(
          (b) => PopupMenuItem(value: b.id, child: Text(b.name)),
        ),
      ],
      onSelected: onChanged,
      child: InputChip(
        avatar: _BoutiqueAvatar(
          boutiqueId: boutiqueId,
          availableBoutiques: availableBoutiques,
          selected: boutiqueId != null,
        ),
        label: Text(_label),
      ),
    );
  }
}

class _BoutiqueAvatar extends StatelessWidget {
  final String? boutiqueId;
  final List<BoutiqueOption> availableBoutiques;
  final bool selected;

  const _BoutiqueAvatar({
    required this.boutiqueId,
    required this.availableBoutiques,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (boutiqueId == null) {
      return Icon(Icons.store, size: 18, color: selected ? Colors.blue : null);
    }
    final b = availableBoutiques.where((x) => x.id == boutiqueId).firstOrNull;
    if (b != null && b.hasLogo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.memory(
          Uint8List.fromList(b.logo!),
          width: 18,
          height: 18,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.store,
            size: 18,
            color: selected ? Colors.blue : null,
          ),
        ),
      );
    }
    return Icon(Icons.store, size: 18, color: selected ? Colors.blue : null);
  }
}

class _GroupByBoutiqueChip extends StatelessWidget {
  final bool groupByBoutique;
  final void Function(bool) onChanged;

  const _GroupByBoutiqueChip({
    required this.groupByBoutique,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(
        Icons.view_list,
        size: 18,
        color: groupByBoutique ? Colors.blue : null,
      ),
      label: Text(groupByBoutique ? 'Grouper par boutique' : 'Ordre chronologique'),
      selected: groupByBoutique,
      onSelected: onChanged,
    );
  }
}
