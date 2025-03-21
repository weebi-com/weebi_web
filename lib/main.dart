import 'package:flutter/material.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
  if (environment == 'development') {
    await dotenv.load(fileName: "assets/dotenv_dev.txt");
  } else {
    await dotenv.load(fileName: "assets/dotenv_prd.txt");
  }

  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}
