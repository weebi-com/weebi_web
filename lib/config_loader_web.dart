import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// Fetches /config.json from the same origin (used in production Docker).
/// Cache-busting so browser doesn't use a stale config (e.g. with empty API_URL).
Future<String?> fetchConfigJson() async {
  final uri = Uri.base
      .resolve('/config.json')
      .replace(queryParameters: {'_': '${DateTime.now().millisecondsSinceEpoch}'});
  final response = await html.window.fetch(uri.toString());
  if (response.status != 200) {
    debugPrint('[weebi] config.json status=${response.status} → fallback to dotenv');
    return null;
  }
  final text = await response.text();
  if (text.isEmpty) {
    debugPrint('[weebi] config.json 200 but empty body → fallback to dotenv');
    return null;
  }
  return text;
}
