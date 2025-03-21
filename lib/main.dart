import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kReleaseMode) {
    await dotenv.load(fileName: "dotenv_prd.txt");
  } else {
    await dotenv.load(fileName: "dotenv_dev.txt");
  }

  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}
