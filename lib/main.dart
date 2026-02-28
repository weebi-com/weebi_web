import 'package:flutter/material.dart';
import 'package:web_admin/config_loader.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config: /config.json in production (from env vars), dotenv in dev
  await loadConfig();

  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}