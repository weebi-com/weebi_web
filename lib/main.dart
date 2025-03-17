import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(isDev: false, apiBaseUrl: 'https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app', defaultAppLanguageCode: 'fr');


  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}
