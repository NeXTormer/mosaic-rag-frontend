import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/widgets/mosaic_search_result.dart';

import '../widgets/standard_elements/search_selector_segment.dart';

class ResultSection extends StatefulWidget {
  const ResultSection({super.key});

  @override
  State<ResultSection> createState() => _ResultSectionState();
}

class _ResultSectionState extends State<ResultSection> {
  SearchModeFilterController searchModeFilterController =
      SearchModeFilterController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 56, top: 8),
            child: SearchSelectorSegment(
                filterController: searchModeFilterController)),
        SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              itemBuilder: (context, index) => MosaicSearchResult(
                url: 'https://mosaic.ows.eu/service/webinterface/',
                title: 'Wikipedia: Ancient Roman Mosaic of Lierna on Lake Como',
                textHeader: 'Summary',
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation.',
                chips: ['wordcount: 187', 'lang: eng', 'index-date:2020-02-01'],
              ),
              itemCount: 10,
            ),
          ),
        )
      ],
    );
  }
}
