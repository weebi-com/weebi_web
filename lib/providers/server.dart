// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:grpc/grpc_web.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:web_admin/grpc/server.dart';
import 'package:web_admin/grpc/auth_interceptor.dart';
import 'package:web_admin/grpc/log_interceptor.dart';

class ArticleServiceClientProvider extends ChangeNotifier {
  final String accessToken;
  final GrpcWebClientChannel clientChannel;
  ArticleServiceClientProvider(this.clientChannel, this.accessToken)
      : _articleServiceClient = ArticleServiceClient(
          clientChannel,
          options: callOptions,
          interceptors: [
            AuthInterceptor(accessToken),
            RequestLogInterceptor(),
          ],
        );
  ArticleServiceClient _articleServiceClient;
  ArticleServiceClient get articleServiceClient => _articleServiceClient;

  set serviceClient(String value) {
    _articleServiceClient = ArticleServiceClient(
      clientChannel,
      options: callOptions,
      interceptors: [
        AuthInterceptor(value),
        RequestLogInterceptor(),
      ],
    );
    notifyListeners();
    return;
  }
}

class FenceServiceClientProvider extends ChangeNotifier {
  final String _accessToken;
  final GrpcWebClientChannel clientChannel;
  FenceServiceClientProvider(this.clientChannel, this._accessToken)
      : _fenceServiceClient = FenceServiceClient(
          clientChannel,
          options: callOptions,
          interceptors: [
            AuthInterceptor(_accessToken),
            RequestLogInterceptor(),
          ],
        );
  FenceServiceClient _fenceServiceClient;
  FenceServiceClient get fenceServiceClient => _fenceServiceClient;

  set serviceClient(String value) {
    _fenceServiceClient = FenceServiceClient(
      clientChannel,
      options: callOptions,
      interceptors: [
        AuthInterceptor(value),
        RequestLogInterceptor(),
      ],
    );
    notifyListeners();
    return;
  }
}

class ContactServiceClientProvider extends ChangeNotifier {
  final String _accessToken;
  final GrpcWebClientChannel clientChannel;
  ContactServiceClient _contactServiceClient;
  ContactServiceClient get contactServiceClient => _contactServiceClient;
  ContactServiceClientProvider(this.clientChannel, this._accessToken)
      : _contactServiceClient = ContactServiceClient(
          clientChannel,
          options: callOptions,
          interceptors: [
            AuthInterceptor(_accessToken),
            RequestLogInterceptor(),
          ],
        );

  set serviceClient(String value) {
    _contactServiceClient = ContactServiceClient(
      clientChannel,
      options: callOptions,
      interceptors: [
        AuthInterceptor(value),
        RequestLogInterceptor(),
      ],
    );
    notifyListeners();
    return;
  }
}

class TicketServiceClientProvider extends ChangeNotifier {
  final String _accessToken;
  final GrpcWebClientChannel clientChannel;
  TicketServiceClient _ticketServiceClient;
  TicketServiceClient get ticketServiceClient => _ticketServiceClient;
  TicketServiceClientProvider(this.clientChannel, this._accessToken)
      : _ticketServiceClient = TicketServiceClient(
          clientChannel,
          options: callOptions,
          interceptors: [
            AuthInterceptor(_accessToken),
            RequestLogInterceptor(),
          ],
        );

  set serviceClient(String _accessToken) {
    _ticketServiceClient = TicketServiceClient(
      clientChannel,
      options: callOptions,
      interceptors: [
        AuthInterceptor(_accessToken),
        RequestLogInterceptor(),
      ],
    );
    notifyListeners();
    return;
  }
}
