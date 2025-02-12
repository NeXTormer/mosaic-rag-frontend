import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/sections/conversational_search_section.dart';
import 'package:mosaic_rs_application/sections/log_section.dart';
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
            LogSection(),

            // Center(
            //   child: MosaicSearchResultLarge(data: {
            //     "id": "237240a8-557c-4831-ac79-5f39fc71dbd1",
            //     "url": "https://simple.wikipedia.org/wiki/Werner_Scholl",
            //     "title": "Wikipedia: Werner Scholl",
            //     "textSnippet":
            //         "Werner Scholl (1922-1944) was the brother of Hans Scholl and Sophie Scholl. Like his siblings, Werner joined the Hitler Youth when Hitler came to power.",
            //     "language": "eng",
            //     "warcDate": 1705357103000000,
            //     "wordCount": 29,
            //     "locations": [],
            //     "keywords": [],
            //     "_original_ranking_": 1,
            //     "full-text":
            //         "Wikipedia: Werner Scholl\nWerner Scholl (1922-1944) was the brother of Hans Scholl and Sophie Scholl. Like his siblings, Werner joined the Hitler Youth when Hitler came to power."
            //   }),
            // ),
          ],
        )),
      ],
    );
  }
}
