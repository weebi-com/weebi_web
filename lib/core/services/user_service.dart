import 'dart:async';
import 'package:protos_weebi/data_dummy.dart';
import 'package:protos_weebi/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class UserService {
  final GrpcClientService _grpcClientService = GrpcClientService();

  Future<PendingUserResponse> createPendingUser({
    required String mail,
    required String firstname,
    required String lastname,
    required String countryCode,
    required String phone,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      int country = int.parse(countryCode);

      final response = await stub.createPendingUser(
        PendingUserRequest(
          mail: mail,
          firstname: firstname,
          lastname: lastname,
          phone: Phone(countryCode: country, number: phone),
          permissions: Dummy
              .salesPersonPermissionNoId, // TODO pass user permissions dynamically here
        ),
        options: options,
      );

      return PendingUserResponse(
          statusResponse: response.statusResponse,
          userPublic: response.userPublic);
    } catch (e) {
      print('Erreur lors de la création de l\'utilisateur: $e');
      rethrow;
    }
  }

  Future<UsersPublic> readAllUsers() async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.readAllUsers(options: options, Empty());

      return UsersPublic(
        users: response.users,
      );
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs: $e');
      rethrow;
    }
  }

  Future<StatusResponse> deleteOneUser({required String userId}) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response =
          await stub.deleteOneUser(UserId(userId: userId), options: options);

      return response;
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur: $e');
      rethrow;
    }
  }
}
