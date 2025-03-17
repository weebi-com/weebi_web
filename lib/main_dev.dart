import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(
      apiBaseUrl:
          'https://weebi-envoyproxy-dev-29758828833.europe-west1.run.app',
      defaultAppLanguageCode: 'fr');

  runApp(const RootApp());
}
