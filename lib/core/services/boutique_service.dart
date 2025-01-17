import 'dart:async';
import 'package:protos_weebi/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class BoutiqueService {
  final GrpcClientService _grpcClientService = GrpcClientService();

  Future<StatusResponse> createOneBoutique({
    String? name,
    String? boutiqueId,
    String? chainId,
    String? firmId,
    String? code,
    String? city,
    String? code2Letters,
    String? namel10n,
    double? latitude,
    double? longitude,
    String? street,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final myBoutique = BoutiquePb(
        name: name,
        boutiqueId: boutiqueId,
        addressFull: Address(
          code: code,
          city: city,
          country: Country(
            code2Letters: code2Letters,
            namel10n: namel10n,
          ),
          latitude: latitude,
          longitude: longitude,
          street: street,
        ),
      );

      final response = await stub.createOneBoutique(
        BoutiqueRequest(chainId: chainId, boutique: myBoutique),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la création de la boutique: $e');
      rethrow;
    }
  }

  Future<StatusResponse> updateOneBoutique({
    String? name,
    String? boutiqueId,
    String? chainId,
    String? firmId,
    String? code,
    String? city,
    String? code2Letters,
    String? namel10n,
    double? latitude,
    double? longitude,
    String? street,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});
      final request = BoutiqueRequest(
        chainId: chainId,
        boutique: BoutiquePb(
          name: name,
          boutiqueId: boutiqueId,
          addressFull: Address(
            code: code,
            city: city,
            country: Country(
              code2Letters: code2Letters,
              namel10n: namel10n,
            ),
            latitude: latitude,
            longitude: longitude,
            street: street,
          ),
        ),
      );

      final response = await stub.updateOneBoutique(
        request,
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la mise à jour de la boutique: $e');
      rethrow;
    }
  }
}
