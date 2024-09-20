import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grpc/grpc_web.dart';
import 'package:protos_weebi/protos_weebi_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/values.dart';
import 'grpc_client.dart';

class SignInResult {
  final bool success;
  final String? message;
  final String? errorMessage;

  SignInResult({required this.success, this.message, this.errorMessage});
}

class SignUpResult {
  final bool success;
  final String? userId;
  final String? errorMessage;

  SignUpResult({required this.success, this.userId, this.errorMessage});
}

class ApiService with ChangeNotifier {
  final GrpcClient _grpcClient = GrpcClient();

  SignInResult _handleSignInError(e) {
    if (e is GrpcError) {
      return SignInResult(success: false, errorMessage: e.message);
    } else {
      return SignInResult(success: false, errorMessage: e.toString());
    }
  }

  SignUpResult _handleSignUpError(e) {
    if (e is GrpcError) {
      return SignUpResult(success: false, errorMessage: e.message);
    } else {
      return SignUpResult(success: false, errorMessage: e.toString());
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accessToken, accessToken);
    await prefs.setString(StorageKeys.refreshToken, refreshToken);
  }

  // Méthode pour gérer l'authentification
  Future<SignInResult> signIn({
    required String mail, required String password
  }) async {
    final stub = FenceServiceClient(_grpcClient.channel);

    try {
      final response = await stub.authenticateWithCredentials(
        Credentials(mail: mail, password: password),
      );
      
      await _saveTokens(response.accessToken, response.refreshToken);
      return SignInResult(success: true, message: "");
    } catch (e) {
      return _handleSignInError(e);
    }
  }

  Future<SignUpResult> signUp({ 
    required String firstName, required String lastName,
    required String mail, required String password 
  }) async {
    final stub = FenceServiceClient(_grpcClient.channel);

    try {
      final response = await stub.signUp(
        SignUpRequest(firstname: firstName, lastname: lastName, mail: mail, password: password),
      );
      return SignUpResult(success: true, userId: response.userId);
    } catch (e) {
      return _handleSignUpError(e);
    }
  }
}
