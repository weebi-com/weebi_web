import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';
import 'package:web_admin/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(isDev: true);

  runApp(const SharedPrefsFetchWidget(child: RootApp()));
}
