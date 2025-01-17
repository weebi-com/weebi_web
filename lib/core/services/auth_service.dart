import 'dart:async';
import 'package:protos_weebi/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sign_in_result.dart';
import '../models/sign_up_result.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class AuthService {
  final GrpcClientService _grpcClientService = GrpcClientService();

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

  Future<SignInResult> signIn({
    required String mail,
    required String password,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final response = await stub.authenticateWithCredentials(
        Credentials(
          mail: mail,
          password: password,
        ),
      );

      await _saveTokens(response.accessToken, response.refreshToken);

      final options =
          CallOptions(metadata: {'authorization': response.accessToken});
      await stub.readUserPermissionsByToken(
        Empty(),
        options: options,
      );

      return SignInResult(success: true, message: "");
    } catch (e) {
      return _handleSignInError(e);
    }
  }

  Future<SignUpResult> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final response = await stub.signUp(
        SignUpRequest(
          firstname: firstName,
          lastname: lastName,
          mail: mail,
          password: password,
        ),
      );
      return SignUpResult(success: true, userId: response.userId);
    } catch (e) {
      return _handleSignUpError(e);
    }
  }

  Future<Tokens> authenticateWithRefreshToken() async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(StorageKeys.accessToken);
      final refreshToken = prefs.getString(StorageKeys.refreshToken);

      final options = CallOptions(metadata: {'authorization': '$accessToken'});

      final response = await stub.authenticateWithRefreshToken(
        options: options,
        RefreshToken(refreshToken: refreshToken),
      );

      return response;
    } catch (e) {
      print('Erreur lors de authenticateWithRefreshToken: $e');
      rethrow;
    }
  }
}
