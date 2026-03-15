import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// Fetches /config.json from the same origin (used in production Docker).
/// Cache-busting so browser doesn't use a stale config (e.g. with empty API_URL).
Future<String?> fetchConfigJson() async {
  final uri = Uri.base
      .resolve('/config.json')
      .replace(queryParameters: {'_': '${DateTime.now().millisecondsSinceEpoch}'});
  final response = await html.window.fetch(uri.toString());
  if (response.status == 200) {
    return response.text();
  }
  // Non-200 → fallback to dotenv (empty in Docker) → same-origin POST → 405
  debugPrint('[weebi] config.json fetch failed: status=${response.status} url=$uri');
  return null;
}
