import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/state/chat_bloc.dart';
import 'package:mosaic_rs_application/state/chat_state.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_state.dart';
import 'package:mosaic_rs_application/state/pipeline_cubit.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/sections/pipeline_section.dart';
import 'package:mosaic_rs_application/sections/result_section.dart';
import 'package:mosaic_rs_application/state/task_bloc.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_bar.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_divider.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      title: 'mosaicRAG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: theme.mainColor),
        fontFamily: 'Montserrat',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<TaskBloc>(
                create: (context) => TaskBloc(TaskDoesNotExist())),
            BlocProvider<ChatBloc>(
                create: (context) => ChatBloc(NoChat('', ''))),
            BlocProvider<PipelineCubit>(
                create: (context) =>
                    PipelineCubit(PipelineState.empty())..loadPipelineInfo()),
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
                            'mosaicRAG',
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
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Text(
                            'Preconfigured pipelines',
                            style: GoogleFonts.montserrat(
                                color: theme.textColor, fontSize: 16),
                          ),
                          items: [
                            ...MenuItems.firstItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                            const DropdownMenuItem<Divider>(
                                enabled: false, child: Divider()),
                            ...MenuItems.secondItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            print(value);
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 450,
                            openInterval:
                                Interval(0, 0, curve: Curves.easeInOut),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            offset: const Offset(0, 0),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            customHeights: [
                              ...List<double>.filled(
                                  MenuItems.firstItems.length, 48),
                              8,
                              ...List<double>.filled(
                                  MenuItems.secondItems.length, 48),
                            ],
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                        ),
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

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(
      text: 'Safe search with reranking and text extraction',
      icon: Icons.search);
  static const share =
      MenuItem(text: 'Reranking using summaries', icon: Icons.search);
  static const settings =
      MenuItem(text: 'Generate summary of all results', icon: Icons.search);
  static const logout =
      MenuItem(text: 'Reset to default', icon: Icons.clear_all);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: theme.mainColor, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
