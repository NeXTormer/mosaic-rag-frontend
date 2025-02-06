import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/chip_selector.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_result.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';
import 'package:provider/provider.dart';

import '../backend/search_manager.dart';

class SearchResultListSection extends StatefulWidget {
  const SearchResultListSection({super.key});

  @override
  State<SearchResultListSection> createState() =>
      _SearchResultListSectionState();
}

class _SearchResultListSectionState extends State<SearchResultListSection> {
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
    return Consumer<SearchManager>(
      builder: (context, searchManager, child) {
        if (columnToDisplay.isEmpty) {
          if (searchManager.resultColumns.contains('summary')) {
            columnToDisplay = 'summary';
          } else if (searchManager.resultColumns.contains('full-text')) {
            columnToDisplay = 'full-text';
          } else if (searchManager.resultColumns.isNotEmpty) {
            columnToDisplay = searchManager.resultColumns.first;
          }
        }

        if (chipsToDisplay.isEmpty &&
            !firstChipsHaveBeenDisplayed &&
            columnToDisplay.isNotEmpty) {
          firstChipsHaveBeenDisplayed = true;
          if (searchManager.resultColumns.contains('language')) {
            chipsToDisplay.add('language');
          }
          if (searchManager.resultColumns.contains('wordCount')) {
            chipsToDisplay.add('wordCount');
          }
        }

        return CustomScrollView(
          controller: scrollController,
          slivers: [
            if (searchManager.metadata.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 56, right: 16, top: 16, bottom: 0),
                  child: FredericCard(
                    animated: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FredericHeading(
                              searchManager.metadata.first['title']),
                          // FredericHeading('werner'),
                          const SizedBox(height: 8),
                          Text(searchManager.metadata.first['data']),
                          // Text("werner findenig"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (searchManager.resultColumns.isEmpty &&
                !searchManager.showLoadingBar)
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
            if (searchManager.resultColumns.isNotEmpty)
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
                            suggestedValues: searchManager.resultColumns.isEmpty
                                ? ['full-text']
                                : searchManager.resultColumns),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 16,
                          children: searchManager.chipColumns
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
            searchManager.showLoadingBar
                ? SliverToBoxAdapter(
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
                  ))
                : SliverPadding(
                    padding: const EdgeInsets.only(left: 16),
                    sliver: SliverList.builder(
                      itemBuilder: (context, index) => true
                          ? MosaicSearchResult(
                              rawData: searchManager.resultList.data[index],
                              url: searchManager.resultList.data[index]['url'],
                              title: searchManager.resultList.data[index]
                                  ['title'],
                              textHeader: columnToDisplay,
                              text:
                                  '${searchManager.resultList.data[index][columnToDisplay]}',
                              chips: chipsToDisplay
                                  .map((column) =>
                                      '$column: ${searchManager.resultList.data[index][column]}')
                                  .toList(),
                            )
                          : MosaicSearchResult(
                              url:
                                  'https://mosaic.ows.eu/service/webinterface/',
                              title:
                                  'Wikipedia: Ancient Roman Mosaic of Lierna on Lake Como',
                              textHeader: 'Summary',
                              text:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation.',
                              chips: [
                                'wordcount: 187',
                                'lang: eng',
                                'index-date:2020-02-01'
                              ],
                            ),
                      itemCount: searchManager.resultList.data.length,
                    ),
                  )
          ],
        );
      },
    );
  }
}
