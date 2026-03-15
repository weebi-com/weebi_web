import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config_loader_web.dart' if (dart.library.io) 'config_loader_stub.dart'
    as config_fetcher;
import 'environment.dart';

/// Loads configuration: config.json first (deployed), then dotenv fallback (local dev when no config.json).
Future<void> loadConfig() async {
  try {
    final configJson = await config_fetcher.fetchConfigJson();
    if (configJson != null && configJson.isNotEmpty) {
      final map = jsonDecode(configJson) as Map<String, dynamic>;
      final apiUrl = (map['API_URL'] as String?) ?? '';
      final locale = (map['LOCALE'] as String?) ?? 'fr';
      Config.init(apiUrl: apiUrl, locale: locale);
      debugPrint('[weebi] config.json loaded → API_URL=${apiUrl.isEmpty ? "(empty)" : apiUrl}');
      return;
    }
  } catch (_) {}

  // Fallback: dotenv (local dev; or when config.json missing/failed/empty)
  const environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  if (environment == 'development') {
    await dotenv.load(fileName: 'assets/dotenv_dev.txt');
  } else {
    await dotenv.load(fileName: 'assets/dotenv_prd.txt');
  }
  final apiUrl = dotenv.env['API_URL'] ?? '';
  Config.init(apiUrl: apiUrl, locale: dotenv.env['LOCALE'] ?? 'fr');
  debugPrint('[weebi] dotenv fallback ($environment) → API_URL=${apiUrl.isEmpty ? "(empty)" : apiUrl}');
}
