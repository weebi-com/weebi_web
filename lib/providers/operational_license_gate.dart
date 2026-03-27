import 'package:flutter/foundation.dart';

import '../core/grpc/firm_product_access.dart';

/// Static hook so gRPC interceptors can signal the UI without a [BuildContext].
///
/// Server: [fence_service] emits `FAILED_PRECONDITION` whose message contains
/// [kOperationalLicenseRequired] when the signed-in user is neither the firm
/// creator (JWT `isFirmCreator`) nor on an active license seat (see
/// `assertUserHasOperationalLicense` on the server).
class OperationalLicenseGateBinding {
  OperationalLicenseGateBinding._();
  static final instance = OperationalLicenseGateBinding._();

  OperationalLicenseGateNotifier? _notifier;

  void attach(OperationalLicenseGateNotifier notifier) {
    _notifier = notifier;
  }

  void noteIfOperationalLicenseDenied(Object error) {
    _notifier?.noteIfOperationalLicenseDenied(error);
  }

  void clear() {
    _notifier?.clear();
  }
}

/// Drives [OperationalLicenseOverlay]: when set, the portal shows the license
/// remediation UI until logout or [clear].
class OperationalLicenseGateNotifier extends ChangeNotifier {
  bool _blocked = false;

  /// True after any gRPC call failed with [isOperationalLicenseDenied].
  bool get isBlocked => _blocked;

  void noteIfOperationalLicenseDenied(Object error) {
    if (!isOperationalLicenseDenied(error)) return;
    if (_blocked) return;
    _blocked = true;
    notifyListeners();
  }

  void clear() {
    if (!_blocked) return;
    _blocked = false;
    notifyListeners();
  }
}
