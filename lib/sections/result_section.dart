import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/sections/conversational_search_section.dart';
import 'package:mosaic_rs_application/sections/search_result_list_section.dart';

import '../widgets/standard_elements/search_selector_segment.dart';

class ResultSection extends StatefulWidget {
  const ResultSection({super.key});

  @override
  State<ResultSection> createState() => _ResultSectionState();
}

class _ResultSectionState extends State<ResultSection> {
  SearchModeFilterController searchModeFilterController =
      SearchModeFilterController();

  PageController pageController = PageController();

  @override
  void initState() {
    searchModeFilterController.addListener(() {
      pageController.animateToPage(searchModeFilterController.selection,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 56, top: 6),
            child: SearchSelectorSegment(
                filterController: searchModeFilterController)),
        Expanded(
            child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            SearchResultListSection(),
            ConversationalSearchSection(),
            Placeholder(
              child: Center(child: Text("Data flow explorer coming soon")),
            ),
            Placeholder(
              child: Center(child: Text("History coming soon")),
            )
          ],
        )),
      ],
    );
  }
}
