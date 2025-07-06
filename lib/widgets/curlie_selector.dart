import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_drop_down_text_field.dart';

class CurlieSelector extends StatefulWidget {
  const CurlieSelector({super.key, this.labels = const []});

  final List<String> labels;

  @override
  State<CurlieSelector> createState() => _CurlieSelectorState();
}

class _CurlieSelectorState extends State<CurlieSelector> {
  Map<String, int> entries = {};
  int maxDepth = 0;

  List<Widget> dropdowns = [];

  @override
  void initState() {
    entries = countAndSort(widget.labels);

    var depths = widget.labels.map((s) => s.split('/').length);
    maxDepth = depths.reduce(max);

    if (entries.isNotEmpty) {
      dropdowns.add(SizedBox(
        width: 200,
        child: FredericDropDownTextField(
            onSubmit: (s) {},
            defaultValue: entries.keys.first,
            suggestedValues: ['suggestedValues']),
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56, top: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: dropdowns,
        ),
      ),
    );
  }

  void onSelect(int index, String label) {}

  Map<String, int> countAndSort(List<String> list) {
    final counts = <String, int>{};

    // Count the occurrences of each element.
    for (final item in list) {
      counts[item] = (counts[item] ?? 0) + 1;
    }

    // Sort the map by value in descending order.
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Create a new map from the sorted entries.
    return LinkedHashMap<String, int>.fromEntries(sortedEntries);
  }
}
