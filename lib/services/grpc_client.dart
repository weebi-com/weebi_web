import 'package:grpc/grpc_web.dart';

class GrpcClient {
  final GrpcWebClientChannel channel;

  GrpcClient()
      : channel = GrpcWebClientChannel.xhr(Uri.parse('http://localhost:8082'));
}
