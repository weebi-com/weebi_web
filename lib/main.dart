import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(apiBaseUrl: 'https://serverweebi-29758828833.europe-west9.run.app');

  runApp(const RootApp());
}
