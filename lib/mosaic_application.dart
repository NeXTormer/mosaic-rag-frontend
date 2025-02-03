import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/mosaic_app_bar.dart';
import 'package:mosaic_rs_application/sections/pipeline_section.dart';
import 'package:mosaic_rs_application/sections/result_section.dart';
import 'package:mosaic_rs_application/sections/search_result_list_section.dart';
import 'package:mosaic_rs_application/theme/ExtraIcons.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_bar.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_divider.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/search_selector_segment.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'backend/search_manager.dart';

import 'dart:js' as js;

class MosaicApplication extends StatefulWidget {
  const MosaicApplication({super.key});

  @override
  State<MosaicApplication> createState() => _MosaicApplicationState();
}

class _MosaicApplicationState extends State<MosaicApplication> {
  bool pipelineEditorExpanded = true;

  String versionString = '';

  @override
  void initState() {
    super.initState();

    getVersionString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mosaicRS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: theme.mainColor),
        fontFamily: 'Montserrat',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<SearchManager>(
                create: (context) => SearchManager()),
            ChangeNotifierProvider<PipelineManager>(
                create: (context) => PipelineManager())
          ],
          child: Builder(builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Text(
                            'mosaicRS',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                color: theme.mainColor,
                                fontSize: 32),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              versionString,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  color: theme.mainColor,
                                  fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 48),
                      Expanded(child: MosaicSearchBar()),
                      SizedBox(width: 48),
                      Text(
                        'Preconfigured pipelines',
                        style: GoogleFonts.montserrat(
                            color: theme.textColor, fontSize: 16),
                      ),
                      SizedBox(width: 48),
                      GestureDetector(
                        onTap: () => js.context
                            .callMethod('open', ['https://mosaic.ows.eu']),
                        child: Text(
                          'About MOSAIC',
                          style: GoogleFonts.montserrat(
                              color: theme.textColor, fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 48),
                      SizedBox(
                          width: 148,
                          child: FredericButton(
                              !pipelineEditorExpanded
                                  ? 'Show pipeline'
                                  : 'Hide pipeline', onPressed: () {
                            setState(() {
                              pipelineEditorExpanded = !pipelineEditorExpanded;
                            });
                          }))
                    ],
                  ),
                ),
                FredericDivider(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: ResultSection()),
                      AnimatedContainer(
                        width: pipelineEditorExpanded ? 450 : 0,
                        duration: Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: PipelineSection(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void getVersionString() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      versionString = 'v$version+$buildNumber';
    });
  }
}
