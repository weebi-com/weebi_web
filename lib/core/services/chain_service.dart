import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class ChainService {
  final GrpcClientService _grpcClientService = GrpcClientService();

  Future<StatusResponse> createOneChain({
    required String name,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.createOneChain(
        Chain(
          name: name,
        ),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la création de la chaine: $e');
      rethrow;
    }
  }

  Future<StatusResponse> updateOneChain({
    required String chainId,
    required String lastUpdatedByuserId,
    String? firmId,
    String? name,
    List<Boutique>? boutiques,
    Timestamp? lastUpdateTimestampUTC
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.updateOneChain(
        Chain(
          chainId: chainId,
          firmId: firmId,
          name: name,
          boutiques: boutiques,
          lastUpdatedByuserId: lastUpdatedByuserId,
          lastUpdateTimestampUTC: lastUpdateTimestampUTC,
        ),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la modification de la chaine: $e');
      rethrow;
    }
  }

  Future<ReadAllChainsResponse> readAllChains() async {
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
