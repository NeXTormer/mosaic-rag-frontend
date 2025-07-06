import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/api/mosaic_rs.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late final theme;
late final config;

final bool kUseLocalMosaicRS = Uri.base.queryParameters['local'] == 'true';
final String kDefaultBackendURL = 'https://mosaicrag.felixholz.com';

final String serverURL = kUseLocalMosaicRS
    ? 'http://127.0.0.1:5000'
    : (true ? kDefaultBackendURL : 'https://mosaicrag.ows.eu');

void main() async {
  var c = await loadAppConfiguration();

  c['colorTheme'] = c['colorTheme'] ?? 'blue-dark';
  c['title'] = c['title'] ?? 'mosaicRAG';
  c['subTitle'] = c['subTitle'] ?? '';
  c['pipelineConfigAllowed'] = c['pipelineConfigAllowed'] ?? true;
  c['logsAllowed'] = c['logsAllowed'] ?? true;

  config = await loadAppConfigurationFromID(c);

  String colorTheme = Uri.base.queryParameters['colorTheme'] ??
      config['colorTheme'] ??
      'blue-dark';

  var [colorThemeName, colorThemeMode] = colorTheme.split('-');

  theme = switch ((colorThemeName, colorThemeMode)) {
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

Future<Map<String, dynamic>> loadAppConfigurationFromID(
    Map<String, dynamic> config) async {
  if (Uri.base.queryParameters['id'] != null) {
    final pipelineID = Uri.base.queryParameters['id']!;

    final dio = Dio();
    final response =
        (await dio.get(serverURL + '/pipeline/restore/$pipelineID')).data;

    print("WERNER");
    print(response);
    config['colorTheme'] = response['colorTheme'];
    config['title'] = response['title'];
    config['subTitle'] = response['subTitle'];
    config['pipelineConfigAllowed'] = response['pipelineConfigAllowed'];
    config['logsAllowed'] = response['logsAllowed'];
  }
  return config;
}
