import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/api/mosaic_rs.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late final theme;

late final bool kUseLocalMosaicRS = Uri.base.queryParameters['local'] == 'true';

late final String kColorThemeString;

void main() async {
  final config = await loadAppConfiguration();

  print(Uri.base.path);

  String colorTheme =
      Uri.base.queryParameters['colorTheme'] ?? config['colorTheme'] ?? 'blue';
  String colorThemeMode = Uri.base.queryParameters['colorMode'] ??
      config['colorThemeMode'] ??
      'light';

  kColorThemeString = '$colorTheme $colorThemeMode';

  theme = switch ((colorTheme, colorThemeMode)) {
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
