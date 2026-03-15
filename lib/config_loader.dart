import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config_loader_web.dart' if (dart.library.io) 'config_loader_stub.dart'
    as config_fetcher;
import 'environment.dart';

/// Loads configuration at runtime.
///
/// Production (Cloud Run): fetches /config.json from env vars – no dotenv.
/// Local dev: uses dotenv files only – no config.json.
Future<void> loadConfig() async {
  try {
    final configJson = await config_fetcher.fetchConfigJson();
    if (configJson != null && configJson.isNotEmpty) {
      final map = jsonDecode(configJson) as Map<String, dynamic>;
      Config.init(
        apiUrl: (map['API_URL'] as String?) ?? '',
        locale: (map['LOCALE'] as String?) ?? 'fr',
      );
      return;
    }
  } catch (_) {
    // config.json not found or invalid - fall back to dotenv
  }

  // Fallback: load from dotenv (local dev, or when config.json unavailable)
  const environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  if (environment == 'development') {
    await dotenv.load(fileName: 'assets/dotenv_dev.txt');
  } else {
    await dotenv.load(fileName: 'assets/dotenv_prd.txt');
  }
  var apiUrl = dotenv.env['API_URL'] ?? '';
  final locale = dotenv.env['LOCALE'] ?? 'fr';
  // Do NOT set apiUrl to '' on web: empty base URL makes gRPC send POST to same origin (webapp),
  // and the webapp nginx returns 405 for POST to static content.
  if (kIsWeb && apiUrl.isEmpty) {
    debugPrint('[weebi] WARNING: API_URL is empty (config.json failed?). gRPC will hit same origin and get 405. Fix config.json in production.');
  }
  Config.init(apiUrl: apiUrl, locale: locale);
}
