import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config_loader_web.dart' if (dart.library.io) 'config_loader_stub.dart'
    as config_fetcher;
import 'environment.dart';

/// Loads configuration at runtime.
///
/// **Web (deployed or local):** Only /config.json. Written by entrypoint from Cloud Run env; no dotenv.
/// **Non-web (e.g. tests):** Dotenv from assets/dotenv_*.txt (for local dev with flutter run).
Future<void> loadConfig() async {
  try {
    final configJson = await config_fetcher.fetchConfigJson();
    if (configJson != null && configJson.isNotEmpty) {
      final map = jsonDecode(configJson) as Map<String, dynamic>;
      final apiUrl = (map['API_URL'] as String?) ?? '';
      final locale = (map['LOCALE'] as String?) ?? 'fr';
      Config.init(apiUrl: apiUrl, locale: locale);
      if (kIsWeb) debugPrint('[weebi] config from /config.json → API_URL=$apiUrl');
      return;
    }
  } catch (e) {
    if (kIsWeb) debugPrint('[weebi] config.json failed: $e');
  }

  // Web: config.json is the only source; no dotenv (assets are gitignored / .example in Docker).
  if (kIsWeb) {
    Config.init(apiUrl: '', locale: 'fr');
    debugPrint('[weebi] API_URL empty (config.json failed). Set API_URL on webapp Cloud Run and ensure /config.json returns 200.');
    return;
  }

  // Non-web only: dotenv for local dev (dotenv_dev/dotenv_prd not in bundle for web; optional here).
  try {
    const environment =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    if (environment == 'development') {
      await dotenv.load(fileName: 'assets/dotenv_dev.txt');
    } else {
      await dotenv.load(fileName: 'assets/dotenv_prd.txt');
    }
    Config.init(
      apiUrl: dotenv.env['API_URL'] ?? '',
      locale: dotenv.env['LOCALE'] ?? 'fr',
    );
  } catch (_) {
    Config.init(apiUrl: '', locale: 'fr');
  }
}
