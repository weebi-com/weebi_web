import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String _apiUrl = '';
  static String _locale = '';

  static String get apiUrl => _apiUrl;
  static String get locale => _locale;

  /// Initialize from runtime config (config.json) or dotenv.
  static void init({required String apiUrl, required String locale}) {
    _apiUrl = apiUrl;
    _locale = locale.isNotEmpty ? locale : 'fr';
  }

  /// Legacy: init from dotenv when used before loadConfig (e.g. tests).
  static void initFromDotenv() {
    _apiUrl = dotenv.env['API_URL'] ?? '';
    _locale = dotenv.env['LOCALE'] ?? 'fr';
  }
}