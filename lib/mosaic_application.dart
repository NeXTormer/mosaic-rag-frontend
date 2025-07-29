import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rag_frontend/state/chat_bloc.dart';
import 'package:mosaic_rag_frontend/state/chat_state.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_state.dart';
import 'package:mosaic_rag_frontend/state/pipeline_cubit.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/sections/pipeline_section.dart';
import 'package:mosaic_rag_frontend/sections/result_section.dart';
import 'package:mosaic_rag_frontend/state/task_bloc.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/theme/frederic_theme.dart';
import 'package:mosaic_rag_frontend/widgets/mosaic_search_bar.dart';
import 'package:mosaic_rag_frontend/widgets/settings_dialog.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_divider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'dart:js' as js;

class MosaicApplication extends StatefulWidget {
  const MosaicApplication({super.key});

  static void loadFromJSON(BuildContext context, String jsonString) {
    context
        .findAncestorStateOfType<_MosaicApplicationState>()!
        .loadFromJSON(jsonString);
  }

  static void rebuildApplication(BuildContext context) {
    context
        .findAncestorStateOfType<_MosaicApplicationState>()!
        .rebuildApplication();
  }

  @override
  State<MosaicApplication> createState() => _MosaicApplicationState();
}

class _MosaicApplicationState extends State<MosaicApplication> {
  UniqueKey? key;

  bool pipelineEditorExpanded = config['pipelineConfigAllowed'];

  String versionString = '';

  void rebuildApplication() {
    String colorTheme = config['colorTheme'];

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

    setState(() {});
  }

  void loadFromJSON(String jsonString) {
    final data = jsonDecode(jsonString);

    String colorTheme = data['colorTheme'];

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

    config['pipelineConfigAllowed'] = data['pipelineConfigAllowed'];
    config['logsAllowed'] = data['logsAllowed'];
    config['title'] = data['title'];
    config['subTitle'] = data['subTitle'];

    config['aboutLinkURL'] = data['aboutLinkURL'];
    config['aboutLinkText'] = data['aboutLinkText'];

    config['defaultTextColumn'] = data['defaultTextColumn'];
    config['defaultRankColumn'] = data['defaultRankColumn'];
    config['defaultChips'] = data['defaultChips'];
    //TODO: why does this not handle pipeline state?
    setState(() {
      // key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    key = UniqueKey();
    getVersionString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      title: config['title'],
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
                create: (context) => PipelineCubit(PipelineState.empty())
                  ..loadInitialConfiguration()),
          ],
          child: Builder(builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (constraints.maxWidth > 450) ...[
                          Stack(
                            children: [
                              Text(
                                config['title'],
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w800,
                                    color: theme.mainColor,
                                    fontSize: 32),
                              ),
                              Positioned(
                                bottom: 0,
                                right: config['subTitle'].isEmpty ? 0 : null,
                                left: config['subTitle'].isEmpty ? null : 0,
                                child: Text(
                                  config['subTitle'].isEmpty
                                      ? versionString
                                      : config['subTitle'],
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      color: theme.mainColor,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 48),
                        ],
                        Expanded(flex: 3, child: MosaicSearchBar()),
                        if (constraints.maxWidth > 766)
                          Expanded(child: Container()),
                        if (constraints.maxWidth > 766 &&
                            config['aboutLinkURL'].isNotEmpty) ...[
                          GestureDetector(
                            onTap: () => js.context
                                .callMethod('open', [config['aboutLinkURL']]),
                            child: Text(
                              config['aboutLinkText'],
                              style: GoogleFonts.montserrat(
                                  color: theme.textColor, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: InkWell(
                              child: Icon(
                                Icons.settings,
                                color: theme.textColor,
                              ),
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext innerContext) {
                                    return BlocProvider.value(
                                      value: context.watch<TaskBloc>(),
                                      child: BlocProvider.value(
                                          value: context.watch<PipelineCubit>(),
                                          child: SettingsDialog()),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                        if (constraints.maxWidth > 766)
                          SizedBox(
                              width: 148,
                              child: config['pipelineConfigAllowed']
                                  ? FredericButton(
                                      !pipelineEditorExpanded
                                          ? 'Show pipeline'
                                          : 'Hide pipeline', onPressed: () {
                                      setState(() {
                                        pipelineEditorExpanded =
                                            !pipelineEditorExpanded;
                                      });
                                    })
                                  : BlocBuilder<TaskBloc, TaskState>(
                                      builder: (context, taskState) {
                                      return FredericButton(
                                          switch (taskState) {
                                            TaskDoesNotExist() =>
                                              'Reset search',
                                            TaskInProgress() => 'Cancel',
                                            TaskFinished() => 'Reset search',
                                          },
                                          mainColor: switch (taskState) {
                                            TaskDoesNotExist() =>
                                              theme.disabledGreyColor,
                                            TaskInProgress() =>
                                              theme.negativeColor,
                                            TaskFinished() => theme.mainColor
                                          },
                                          onPressed: () => switch (taskState) {
                                                TaskDoesNotExist() => null,
                                                TaskInProgress() =>
                                                  BlocProvider.of<TaskBloc>(
                                                          context)
                                                      .add(CancelTaskEvent()),
                                                TaskFinished() => {
                                                    BlocProvider.of<TaskBloc>(
                                                            context)
                                                        .add(ResetTaskEvent()),
                                                    BlocProvider.of<ChatBloc>(
                                                            context)
                                                        .add(ResetChatEvent()),
                                                  }
                                              });
                                    }))
                      ],
                    );
                  }),
                ),
                FredericDivider(),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Row(
                      children: [
                        Expanded(child: ResultSection()),
                        if (config['pipelineConfigAllowed'] &&
                            constraints.maxWidth > 800)
                          AnimatedContainer(
                            width: pipelineEditorExpanded ? 450 : 0,
                            duration: Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            child: PipelineSection(),
                          ),
                      ],
                    );
                  }),
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
