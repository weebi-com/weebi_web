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
  // Safety: on web, never use dev Envoy URL from fallback (prevents prod build with baked-in dev URL).
  if (kIsWeb && apiUrl.contains('envoyproxy-dev')) {
    debugPrint('[weebi] Refusing dotenv fallback with dev Envoy URL on web; use config.json.');
    apiUrl = '';
  }
  Config.init(apiUrl: apiUrl, locale: locale);
}
