import 'package:grpc/grpc_web.dart';

import '../environment.dart';

class GrpcClient {
  final GrpcWebClientChannel channel;

  GrpcClient()
      : channel = GrpcWebClientChannel.xhr(Uri.parse(env.apiBaseUrl));
}
