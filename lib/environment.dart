late Environment _env;

Environment get env => _env;

class Environment {
  final String apiBaseUrl;
  final String defaultAppLanguageCode;
  final bool isDev;

  Environment._init({
    required this.isDev,
    required this.apiBaseUrl,
    required this.defaultAppLanguageCode,
  });

  static void init({
    //String localBaseUrl = 'https://127.0.0.1:443',
    bool isDev = true,
    String apiBaseUrl =
        'https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app',
    String defaultAppLanguageCode = 'fr',
  }) {
    _env = Environment._init(
      isDev: isDev,
      apiBaseUrl: apiBaseUrl,
      defaultAppLanguageCode: defaultAppLanguageCode,
    );
  }
}
