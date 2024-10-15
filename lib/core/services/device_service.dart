import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/grpc_client_service.dart';
import '../constants/values.dart';
import 'package:protos_weebi/protos_weebi_io.dart';

class DeviceService {
  final GrpcClientService _grpcClientService = GrpcClientService();

  Future<CodeForPairingDevice> generateCodeForPairingDevice({
    required String boutiqueId,
    required String chainId,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.generateCodeForPairingDevice(
          ChainIdAndboutiqueId(
            boutiqueId: boutiqueId,
            chainId: chainId,
          ),
          options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors du lien avec le device: $e');
      rethrow;
    }
  }

  Future<CreatePendingDeviceResponse> createPendingDevice({
    required int code,
    required String hardwareName,
    required String hardwareSerialNumber,
    required String hardwareBaseOS,
    required String hardwareBrand,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.createPendingDevice(
        PendingDeviceRequest(
          code: code,
          hardwareInfo: HardwareInfo(
            name: hardwareName,
            serialNumber: hardwareSerialNumber,
            baseOS: hardwareBaseOS,
            brand: hardwareBrand,
          )
        ),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la création en attente du device: $e');
      rethrow;
    }
  }

  Future<Devices> readDevices({
    required String chainId,
    required HardwareInfo hardwareInfo,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.readDevices(
        ReadDevicesRequest(
            chainId: chainId
        ),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la lecture du device: $e');
      rethrow;
    }
  }

  Future<Tokens> authenticateWithDevice({
    required String firmId,
    required String chainId,
    required String boutiqueId,
    required String deviceId,
    required String password,
  }) async {
    final stub = FenceServiceClient(_grpcClientService.channel);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(StorageKeys.accessToken);
      final options = CallOptions(metadata: {'authorization': '$token'});

      final response = await stub.authenticateWithDevice(
        DeviceCredentials(
          firmId: firmId,
          chainId: chainId,
          boutiqueId: boutiqueId,
          deviceId: deviceId,
          password: password,
        ),
        options: options,
      );

      return response;
    } catch (e) {
      print('Erreur lors de la connexion avec le device: $e');
      rethrow;
    }
  }


}
