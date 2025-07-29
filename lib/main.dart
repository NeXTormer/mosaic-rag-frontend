import 'package:dio/dio.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/api/mosaic_rs.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var theme;
final config = Map<String, dynamic>();

final bool kUseLocalMosaicRS = Uri.base.queryParameters['local'] == 'true';

// Fall back to mosaicrag.felixholz.com if running locally, otherwise use the current host
String serverURL = kUseLocalMosaicRS
    ? 'http://127.0.0.1:5000'
    : (Uri.base.origin.contains('localhost')
        ? 'https://mosaicrag.felixholz.com'
        : Uri.base.origin);

void main() async {
  config['colorTheme'] = config['colorTheme'] ?? 'blue-dark';
  config['title'] = config['title'] ?? 'mosaicRAG';
  config['subTitle'] = config['subTitle'] ?? '';
  config['pipelineConfigAllowed'] = config['pipelineConfigAllowed'] ?? true;
  config['logsAllowed'] = config['logsAllowed'] ?? true;

  config['aboutLinkText'] = config['aboutLinkText'] ?? 'About MOSAIC';
  config['aboutLinkURL'] = config['aboutLinkURL'] ?? 'https://mosaic.ows.eu';

  config['defaultTextColumn'] = '';
  config['defaultRankColumn'] = '';
  config['defaultChips'] = [];

  await loadAppConfiguration(config);

  await loadAppConfigurationFromID(config);

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

Future<Map<String, dynamic>> loadAppConfiguration(
    Map<String, dynamic> config) async {
  try {
    final dio = Dio();
    final response = (await dio.get('${serverURL}/app_config')).data;

    config['colorTheme'] = response['colorTheme'];
    config['title'] = response['title'];
    config['subTitle'] = response['subTitle'];
    config['pipelineConfigAllowed'] =
        response['pipelineConfigAllowed'].toString().toLowerCase() == 'true';
    config['logsAllowed'] =
        response['logsAllowed'].toString().toLowerCase() == 'true';
    config['pipeline'] = response['pipeline'];
    config['aboutLinkText'] = response['aboutLinkText'];
    config['aboutLinkURL'] = response['aboutLinkURL'];

    return config;
  } catch (e) {
    print('failed to load app config2');
    print(e);
    return config;
  }
}

Future<Map<String, dynamic>> loadAppConfigurationFromID(
    Map<String, dynamic> config) async {
  if (Uri.base.queryParameters['id'] != null) {
    final pipelineID = Uri.base.queryParameters['id']!;

    final dio = Dio();
    final response =
        (await dio.get(serverURL + '/pipeline/restore/$pipelineID')).data;

    config['colorTheme'] = response['colorTheme'];
    config['title'] = response['title'];
    config['subTitle'] = response['subTitle'];
    config['pipelineConfigAllowed'] =
        response['pipelineConfigAllowed'].toString().toLowerCase() == 'true';
    config['logsAllowed'] =
        response['logsAllowed'].toString().toLowerCase() == 'true';

    config['aboutLinkText'] = response['aboutLinkText'];
    config['aboutLinkURL'] = response['aboutLinkURL'];
  }
  return config;
}
