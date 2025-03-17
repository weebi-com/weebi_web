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
    String apiBaseUrl =
        'https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app',
    String defaultAppLanguageCode = 'fr',
  }) {
    _env = Environment._init(
      apiBaseUrl: apiBaseUrl,
      defaultAppLanguageCode: defaultAppLanguageCode,
    );
  }
}
