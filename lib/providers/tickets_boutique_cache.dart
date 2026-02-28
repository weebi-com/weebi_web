import 'package:flutter/foundation.dart';
import 'package:protos_weebi/grpc.dart';
import 'package:protos_weebi/protos_weebi_io.dart'
    show Empty, FenceServiceClient, ReadAllBoutiquesResponse;

/// Lightweight cache for boutique id → name resolution.
/// Calls FenceService.readAllBoutiques once on first access, then caches.
/// Used by tickets to display boutique names when counterfoil.boutiqueName is empty.
class TicketsBoutiqueCache extends ChangeNotifier {
  TicketsBoutiqueCache(this._fenceClient);

  final FenceServiceClient _fenceClient;

  Map<String, _BoutiqueInfo>? _cache;
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoaded => _cache != null;

  /// Resolves boutiqueId to display name. Returns id if not found.
  String getName(String boutiqueId) {
    if (boutiqueId.isEmpty) return '';
    final info = _cache?[boutiqueId];
    if (info != null && info.name.isNotEmpty) return info.name;
    return boutiqueId;
  }

  /// Returns logo bytes if available, null otherwise.
  Uint8List? getLogo(String boutiqueId) {
    final info = _cache?[boutiqueId];
    if (info?.logo == null || info!.logo!.isEmpty) return null;
    return Uint8List.fromList(info.logo!);
  }

  String? getLogoExtension(String boutiqueId) {
    return _cache?[boutiqueId]?.logoExtension;
  }

  /// True if this boutique has a logo to display.
  bool hasLogo(String boutiqueId) {
    final info = _cache?[boutiqueId];
    return info != null &&
        info.logo != null &&
        info.logo!.isNotEmpty &&
        (info.logoExtension?.isNotEmpty ?? false);
  }

  /// All boutique ids in the cache.
  Iterable<String> get allIds => _cache?.keys ?? const [];

  /// Loads boutiques from FenceService.readAllBoutiques.
  /// Idempotent: no-op if already loaded.
  Future<void> loadIfNeeded() async {
    if (_cache != null || _loading) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _fenceClient.readAllBoutiques(Empty());
      _cache = _buildCache(res);
    } on GrpcError catch (e) {
      _error = '${e.code} ${e.message}';
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Map<String, _BoutiqueInfo> _buildCache(ReadAllBoutiquesResponse res) {
    final map = <String, _BoutiqueInfo>{};
    for (final b in res.boutiques) {
      if (b.boutiqueId.isEmpty) continue;
      map[b.boutiqueId] = _BoutiqueInfo(
        name: b.name.trim().isNotEmpty ? b.name.trim() : b.boutiqueId,
        logo: null,
        logoExtension: null,
      );
    }
    return map;
  }

  /// Merge in logo and name data from BoutiqueMongo (e.g. from BoutiqueProvider).
  /// Call when BoutiqueProvider has loaded chains with full boutique data.
  /// Adds names for boutiques missing from fence cache or with empty names.
  void mergeLogosFromBoutiqueMongo(Iterable<dynamic> boutiques) {
    var changed = false;
    _cache ??= {};
    for (final b in boutiques) {
      final id = _getBoutiqueId(b);
      if (id.isEmpty) continue;
      final name = _getName(b);
      final logo = _getLogo(b);
      final ext = _getLogoExtension(b);
      final hasLogo = logo != null && logo.isNotEmpty && (ext?.isNotEmpty ?? false);
      final info = _cache![id];
      final newName = (info?.name.isEmpty ?? true) && name.isNotEmpty
          ? name
          : (info?.name ?? id);
      final newLogo = (info?.logo == null && hasLogo) ? logo : info?.logo;
      final newExt = newLogo != null && hasLogo ? ext : info?.logoExtension;
      if (info == null ||
          info.name != newName ||
          info.logo != newLogo ||
          info.logoExtension != newExt) {
        _cache![id] = _BoutiqueInfo(
          name: newName.isNotEmpty ? newName : id,
          logo: newLogo != null && newLogo.isNotEmpty ? newLogo : null,
          logoExtension: newExt,
        );
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  String _getName(dynamic b) {
    try {
      final n = (b as dynamic).name as String?;
      return n?.trim() ?? '';
    } catch (_) {
      try {
        final boutique = (b as dynamic).boutique;
        if (boutique != null) return _getName(boutique);
      } catch (_) {}
      return '';
    }
  }

  String _getBoutiqueId(dynamic b) {
    try {
      return (b as dynamic).boutiqueId as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  List<int>? _getLogo(dynamic b) {
    try {
      final logo = (b as dynamic).logo;
      if (logo is List<int>) return logo;
      if (logo is List) return List<int>.from(logo);
      return null;
    } catch (_) {
      return null;
    }
  }

  String? _getLogoExtension(dynamic b) {
    try {
      return (b as dynamic).logoExtension as String?;
    } catch (_) {
      return null;
    }
  }
}

class _BoutiqueInfo {
  final String name;
  final List<int>? logo;
  final String? logoExtension;

  _BoutiqueInfo({
    required this.name,
    this.logo,
    this.logoExtension,
  });
}
