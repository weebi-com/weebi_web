late Environment _env;

Environment get env => _env;

class Environment {
  final String apiBaseUrl;
  final String defaultAppLanguageCode;

  Environment._init({
    required this.apiBaseUrl,
    required this.defaultAppLanguageCode,
  });

  static void init({
    String apiBaseUrl = 'http://localhost:8082',
    String defaultAppLanguageCode = 'fr',
  }) {
    _env = Environment._init(
      apiBaseUrl: apiBaseUrl,
      defaultAppLanguageCode: defaultAppLanguageCode,
    );
  }
}
