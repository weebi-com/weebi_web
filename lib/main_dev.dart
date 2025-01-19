import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';

// TODO main in dev
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(isDev: true);

  runApp(const RootApp());
}
