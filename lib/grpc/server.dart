// Package imports:

import 'package:grpc/grpc_web.dart';
import 'package:web_admin/environment.dart';

final callOptions = CallOptions(timeout: const Duration(seconds: 30));

class GrpcWebClientChannelWeebi {
  final Environment env;
  final GrpcWebClientChannel clientChannel;
  GrpcWebClientChannelWeebi(this.env)
      : clientChannel = env.isDev ? _channelDev : _channelPrd;
}

/// DEV
///
final _channelDev = GrpcWebClientChannel.xhr(
  Uri.parse(
      'https://weebi-envoyproxy-dev-29758828833.europe-west1.run.app'), // weebi-server-dev-29758828833.europe-west1.run.app
);

final _channelPrd = GrpcWebClientChannel.xhr(
  Uri.parse(
      'https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app'), // weebi-server-dev-29758828833.europe-west1.run.app
);
