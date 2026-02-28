import 'dart:html' as html;

/// Fetches /config.json from the same origin (used in production Docker).
Future<String?> fetchConfigJson() async {
  final uri = Uri.base.resolve('/config.json');
  final response = await html.window.fetch(uri.toString());
  if (response.status == 200) {
    return response.text();
  }
  return null;
}
