import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';

final theme = FredericColorTheme.owsblue();

final bool kUseLocalMosaicRS = Uri.base.queryParameters['local'] == 'true';

void main() {
  runApp(MosaicApplication());
}
