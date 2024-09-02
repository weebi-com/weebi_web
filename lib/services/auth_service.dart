import 'package:flutter/material.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

import 'grpc_client.dart';

class AuthService with ChangeNotifier {
  final GrpcClient _grpcClient = GrpcClient();

  Future<void> signIn(String email, String password) async {
    final stub = FenceServiceClient(_grpcClient.channel);

    try {
      final response = await stub.authenticateWithCredentials(
        Credentials(mail: email, password: password),
      );
      // Gérez l'authentification réussie
      print('Access Token: ${response.accessToken}');
    } catch (e) {
      // Gérez l'erreur d'authentification
      print('Erreur d\'authentification : $e');
    }
  }

  Future<void> signUp({ required String firstName, required String lastName,
    required String mail, required String password }) async {
    final stub = FenceServiceClient(_grpcClient.channel);

    try {
      final response = await stub.signUp(
        SignUpRequest(firstname: firstName, lastname: lastName, mail: mail, password: password),
      );
      // Gérez l'inscription réussie
      print('User ID: ${response.userId}');
    } catch (e) {
      // Gérez l'erreur d'inscription
      print('Erreur d\'inscription : $e');
    }
  }
}
