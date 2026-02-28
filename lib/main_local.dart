import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/dotenv_lcl.txt");
  Config.init(
    apiUrl: dotenv.env['API_URL'] ?? '',
    locale: dotenv.env['LOCALE'] ?? 'fr',
  );

  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}
