import 'package:protos_weebi/grpc.dart';
import '../../environment.dart';

class GrpcClientService {
  final GrpcWebClientChannel channel;

  GrpcClientService()
      : channel = GrpcWebClientChannel.xhr(Uri.parse(env.apiBaseUrl));
}
