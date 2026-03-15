class Config {
  static String _apiUrl = '';
  static String _locale = '';

  static String get apiUrl => _apiUrl;
  static String get locale => _locale;

  static void init({required String apiUrl, required String locale}) {
    _apiUrl = apiUrl;
    _locale = locale.isNotEmpty ? locale : 'fr';
  }
}