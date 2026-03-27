import 'dart:async';

import 'package:grpc/grpc.dart' as grpc;

import '../core/grpc/firm_product_access.dart';
import '../providers/operational_license_gate.dart';

/// Watches unary gRPC calls and notifies [OperationalLicenseGateBinding] when the
/// server rejects the call for missing **operational license**.
///
/// Today, [fence_service] returns `FAILED_PRECONDITION` with a message containing
/// [kOperationalLicenseRequired] when the user is neither the firm creator (JWT
/// `isFirmCreator`) nor assigned an active license seat (see server-side
/// `assertUserHasOperationalLicense`). Other services (ticket, article, contact)
/// surface the same error to the client.
///
/// The binding drives [OperationalLicenseOverlay] so the user sees billing / retry
/// without coupling interceptors to [BuildContext].
class OperationalLicenseGrpcInterceptor extends grpc.ClientInterceptor {
  @override
  grpc.ResponseFuture<R> interceptUnary<Q, R>(
    grpc.ClientMethod<Q, R> method,
    Q request,
    grpc.CallOptions options,
    grpc.ClientUnaryInvoker<Q, R> invoker,
  ) {
    final incoming = invoker(method, request, options);
    unawaited(
      incoming.catchError((Object e, StackTrace st) {
        OperationalLicenseGateBinding.instance.noteIfOperationalLicenseDenied(e);
        return Future<R>.error(e, st);
      }),
    );
    return incoming;
  }
}
