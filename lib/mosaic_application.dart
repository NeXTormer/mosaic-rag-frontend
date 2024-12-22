import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/mosaic_app_bar.dart';
import 'package:mosaic_rs_application/sections/pipeline_section.dart';
import 'package:mosaic_rs_application/sections/result_section.dart';
import 'package:mosaic_rs_application/theme/ExtraIcons.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_divider.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';

class MosaicApplication extends StatefulWidget {
  const MosaicApplication({super.key});

  @override
  State<MosaicApplication> createState() => _MosaicApplicationState();
}

class _MosaicApplicationState extends State<MosaicApplication> {
  bool pipelineEditorExpanded = false;

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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'mosaicRS',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        color: theme.mainColor,
                        fontSize: 32),
                  ),
                  SizedBox(width: 48),
                  Expanded(
                      child: FredericTextField(
                    'Enter search query...',
                    icon: Icons.search,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: theme.mainColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 48),
                  Text(
                    'Preconfigured pipelines',
                    style: GoogleFonts.montserrat(
                        color: theme.textColor, fontSize: 16),
                  ),
                  SizedBox(width: 48),
                  Text(
                    'How it works',
                    style: GoogleFonts.montserrat(
                        color: theme.textColor, fontSize: 16),
                  ),
                  SizedBox(width: 48),
                  SizedBox(
                      width: 148,
                      child: FredericButton(
                          !pipelineEditorExpanded
                              ? 'Edit pipeline'
                              : 'Close pipeline', onPressed: () {
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
                    width: pipelineEditorExpanded ? 500 : 0,
                    duration: Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: PipelineSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
