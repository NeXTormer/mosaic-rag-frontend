import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/task_bloc.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/widgets/chip_selector.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_result.dart';
import 'package:mosaic_rs_application/widgets/search_result_metadata_section.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';

class SearchResultListSection extends StatefulWidget {
  const SearchResultListSection({super.key});

  @override
  State<SearchResultListSection> createState() =>
      _SearchResultListSectionState();
}

class _SearchResultListSectionState extends State<SearchResultListSection>
    with AutomaticKeepAliveClientMixin<SearchResultListSection> {
  TextEditingController columnSelectorTextFieldController =
      TextEditingController();

  ScrollController scrollController = ScrollController();

  String columnToDisplay = '';
  List<String> chipsToDisplay = <String>[];
  bool firstChipsHaveBeenDisplayed = false;

  bool showPacman = false;

  @override
  void initState() {
    showPacman = Random().nextInt(10) == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) {
        if (taskState is TaskFinished) {
          if (columnToDisplay.isEmpty) {
            if (taskState.taskInfo.textColumns.contains('summary')) {
              columnToDisplay = 'summary';
            } else if (taskState.taskInfo.textColumns.contains('full-text')) {
              columnToDisplay = 'full-text';
            } else if (taskState.taskInfo.textColumns.isNotEmpty) {
              columnToDisplay = taskState.taskInfo.textColumns.first;
            }
          }

          if (chipsToDisplay.isEmpty &&
              !firstChipsHaveBeenDisplayed &&
              columnToDisplay.isNotEmpty) {
            firstChipsHaveBeenDisplayed = true;
            if (taskState.taskInfo.chipColumns.contains('language')) {
              chipsToDisplay.add('language');
            }
          }
        }

        return BlocBuilder<TaskBloc, TaskState>(builder: (context, taskState) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SearchResultMetadataSection(),
              if (taskState is TaskDoesNotExist)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        'Enter a search query to get started. You can modify the retrieval pipeline on the right.',
                        style: TextStyle(color: theme.greyTextColor),
                      ),
                    ),
                  ),
                ),
              if (taskState is TaskFinished)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 56, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 224,
                          child: FredericDropDownTextField(
                              onSubmit: (s) {
                                setState(() {
                                  columnToDisplay = s;
                                });
                              },
                              defaultValue: columnToDisplay,
                              controller: columnSelectorTextFieldController,
                              suggestedValues: taskState.taskInfo.textColumns),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Wrap(
                            spacing: 16,
                            children: taskState.taskInfo.chipColumns
                                .map((column) => ChipSelector(
                                    onTap: () {
                                      setState(() {
                                        final enabled =
                                            chipsToDisplay.contains(column);
                                        if (enabled) {
                                          chipsToDisplay.remove(column);
                                        } else {
                                          chipsToDisplay.add(column);
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(column),
                                      ),
                                    ),
                                    selected: chipsToDisplay.contains(column)))
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(child: const SizedBox(height: 14)),
              if (taskState is TaskInProgress)
                SliverToBoxAdapter(
                    child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: LoadingIndicator(
                      indicatorType: showPacman
                          ? Indicator.pacman
                          : Indicator.ballClipRotateMultiple,
                      colors: [theme.mainColor, theme.accentColor],
                    ),
                  ),
                )),
              if (taskState is TaskFinished)
                SliverPadding(
                  padding: const EdgeInsets.only(left: 16),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) => true
                        ? MosaicSearchResult(
                            rawData: taskState.taskInfo.data[index],
                            url: taskState.taskInfo.data[index]['url'] ??
                                '<missing-url>',
                            title: taskState.taskInfo.data[index]['title'] ??
                                '<missing-title>',
                            textHeader: columnToDisplay,
                            text:
                                '${taskState.taskInfo.data[index][columnToDisplay] ?? ''}',
                            chips: chipsToDisplay
                                .map((column) =>
                                    '$column: ${taskState.taskInfo.data[index][column] ?? ''}')
                                .toList(),
                          )
                        : MosaicSearchResult(
                            url: 'https://mosaic.ows.eu/service/webinterface/',
                            title:
                                'Wikipedia: Ancient Roman Mosaic of Lierna on Lake Como',
                            textHeader: 'Summary',
                            text:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, seLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nosLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nosd do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nosLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nos ad minim veniam quis nostrud exercitation. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation.',
                            chips: [
                              'wordcount: 187',
                              'lang: eng',
                              'index-date:2020-02-01'
                            ],
                          ),
                    itemCount: taskState.taskInfo.data.length,
                  ),
                ),
              if (taskState is TaskFinished && taskState.taskInfo.data.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        'Your search returned no results. Modify your query or the pipeline.',
                        style: TextStyle(color: theme.greyTextColor),
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
