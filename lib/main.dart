import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late final theme;

late final bool kUseLocalMosaicRS = Uri.base.queryParameters['local'] == 'true';

void main() async {
  final config = await loadAppConfiguration();
  theme = switch ((config['colorTheme'], config['colorThemeMode'])) {
    ('blue', 'dark') => FredericColorTheme.owsblueDark(),
    ('blue', 'light') => FredericColorTheme.owsblue(),
    ('orange', 'dark') => FredericColorTheme.orangeDark(),
    ('orange', 'light') => FredericColorTheme.orange(),
    ('red', 'dark') => FredericColorTheme.redDark(),
    ('red', 'light') => FredericColorTheme.red(),
    ('pink', 'dark') => FredericColorTheme.pinkDark(),
    ('pink', 'light') => FredericColorTheme.pink(),
    _ => FredericColorTheme.owsblue()
  };

  runApp(MosaicApplication());
}

Future<Map<String, dynamic>> loadAppConfiguration() async {
  try {
    final response = await http.get(Uri.parse('app_config.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load app_config.json: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching app_config.json: $e');
  }
}
