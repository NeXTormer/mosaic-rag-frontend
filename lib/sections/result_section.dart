import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/widgets/chip_selector.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_result.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:provider/provider.dart';

import '../backend/search_manager.dart';
import '../widgets/standard_elements/search_selector_segment.dart';

class ResultSection extends StatefulWidget {
  const ResultSection({super.key});

  @override
  State<ResultSection> createState() => _ResultSectionState();
}

class _ResultSectionState extends State<ResultSection> {
  SearchModeFilterController searchModeFilterController =
      SearchModeFilterController();

  TextEditingController columnSelectorTextFieldController =
      TextEditingController();

  String columnToDisplay = '';
  List<String> chipsToDisplay = <String>[];
  bool firstChipsHaveBeenDisplayed = false;

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 56, top: 6),
                child: SearchSelectorSegment(
                    filterController: searchModeFilterController)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 56),
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
            const SizedBox(height: 14),
            searchManager.showLoadingBar
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ListView.builder(
                        itemBuilder: (context, index) => true
                            ? MosaicSearchResult(
                                url: searchManager.resultList.data[index]
                                    ['url'],
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
                    ),
                  )
          ],
        );
      },
    );
  }
}
