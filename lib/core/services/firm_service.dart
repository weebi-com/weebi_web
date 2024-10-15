import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class FirmService {
  final GrpcClientService _grpcClientService = GrpcClientService();

  Future<CreateFirmResponse> createFirm({
    required String name,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.createFirm(
        CreateFirmRequest(name: name),
        options: options,
      );

      return CreateFirmResponse(firm: response.firm, statusResponse: response.statusResponse);
    } catch (e) {
      print('Erreur lors de la création de la chaine: $e');
      rethrow;
    }
  }

  Future<StatusResponse> createOneChain({
    required String firmId,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.createOneChain(
          Chain(firmId: firmId),
          options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la création de la chaine: $e');
      rethrow;
    }
  }

  Future<Firm> readOneFirm() async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.readOneFirm(Empty(), options: options);

      return response;
    } catch (e) {
      print('Erreur lors de la récuperation de la chaine: $e');
      rethrow;
    }
  }

  Future<StatusResponse> updateOneChain({
    required String firmId,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.updateOneChain(
        Chain(firmId: firmId),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la modification de la chaine: $e');
      rethrow;
    }
  }

  Future<ReadAllChainsResponse> readAllChains({
    required String firmId,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.readAllChains(
        Empty(),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la récuperation de la chaine: $e');
      rethrow;
    }
  }
}