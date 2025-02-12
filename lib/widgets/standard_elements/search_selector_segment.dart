import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

enum SearchMode { ResultList, Conversational, DataFlowExplorer, History }

class SearchSelectorSegment extends StatefulWidget {
  SearchSelectorSegment({required this.filterController});

  final SearchModeFilterController filterController;

  @override
  _ActivityFilterSegmentState createState() => _ActivityFilterSegmentState();
}

class _ActivityFilterSegmentState extends State<SearchSelectorSegment> {
  int selectedIndex = 0;

  final resultListKey = GlobalKey();
  final conversationalKey = GlobalKey();
  final dataflowKey = GlobalKey();
  final historyKey = GlobalKey();

  List<GlobalKey> keys = <GlobalKey>[];

  final dotKey = GlobalKey();

  double positionedX = 0;

  @override
  void initState() {
    keys.add(resultListKey);
    keys.add(conversationalKey);
    keys.add(dataflowKey);
    keys.add(historyKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 0;
    try {
      return SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FilterButton('Search result list',
                    key: resultListKey,
                    rightPadding: padding,
                    isActive: selectedIndex == 0, onPressed: () {
                  setState(() {
                    handleMuscleFilters(SearchMode.ResultList);
                    selectedIndex = 0;
                  });
                }),
                SizedBox(width: 72),
                _FilterButton('Conversational search',
                    key: conversationalKey,
                    rightPadding: padding,
                    isActive: selectedIndex == 1, onPressed: () {
                  setState(() {
                    handleMuscleFilters(SearchMode.Conversational);
                    selectedIndex = 1;
                  });
                }),
                SizedBox(width: 72),
                _FilterButton('Data flow explorer',
                    key: dataflowKey,
                    rightPadding: padding,
                    isActive: selectedIndex == 2, onPressed: () {
                  setState(() {
                    handleMuscleFilters(SearchMode.DataFlowExplorer);
                    selectedIndex = 2;
                  });
                }),
                SizedBox(width: 72),
                _FilterButton('Logs',
                    key: historyKey,
                    rightPadding: padding,
                    isActive: selectedIndex == 3, onPressed: () {
                  setState(() {
                    handleMuscleFilters(SearchMode.History);
                    selectedIndex = 3;
                  });
                }),
                SizedBox(width: 12)
              ],
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              bottom: 0,
              left: keys[selectedIndex].positionedDifference(dotKey),
              child: Icon(
                Icons.circle,
                size: 8,
                color: theme.mainColor,
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print(e);

      return SliverToBoxAdapter(
          child: Container(
        child: kDebugMode ? Text(e.toString()) : Container(height: 16),
      ));
    }
  }

  void handleMuscleFilters(SearchMode activeFilter) {
    switch (activeFilter) {
      case SearchMode.ResultList:
        widget.filterController.selection = 0;

        break;
      case SearchMode.Conversational:
        widget.filterController.selection = 1;
        break;
      case SearchMode.DataFlowExplorer:
        widget.filterController.selection = 2;
        break;
      case SearchMode.History:
        widget.filterController.selection = 3;
        break;
    }
  }
}

extension GlobalKeyExtension on GlobalKey {
  double positionedDifference(GlobalKey other) {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject
        ?.getTransformTo(other.currentContext?.findRenderObject())
        .getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      Rect? rect =
          renderObject?.paintBounds.shift(Offset(translation.x, translation.y));
      if (rect != null) {
        return rect.left - 56; //16;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}

class SearchModeFilterController with ChangeNotifier {
  SearchModeFilterController() {}

  int _currentSelection = 0;

  bool get showResultList => _currentSelection == 0;
  int get selection => _currentSelection;

  set selection(int value) {
    _currentSelection = value;
    notifyListeners();
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton(String label,
      {required this.isActive,
      required this.rightPadding,
      required this.onPressed,
      Key? key})
      : this.label = label,
        super(key: key);

  final Function() onPressed;
  final double rightPadding;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding, top: 10, bottom: 10),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
              color: isActive ? theme.mainColor : theme.greyTextColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              fontSize: 14),
        ),
      ),
    );
  }
}
