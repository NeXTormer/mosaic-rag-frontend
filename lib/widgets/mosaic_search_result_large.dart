import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/map_display.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_divider.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';

class MosaicSearchResultLarge extends StatelessWidget {
  MosaicSearchResultLarge({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final metadataFields = <String>[];
    final textFields = <String>[];

    for (final entry in data.entries) {
      if (RegExp(r'\s').allMatches('${entry.value}').length < 10) {
        metadataFields.add(entry.key);
      } else {
        textFields.add(entry.key);
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth * 0.6,
        height: constraints.maxHeight * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SingleChildScrollView(
            child: FredericCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FredericHeading(
                                  data['title'] ?? '<missing title>'),
                              const SizedBox(height: 16),
                              for (final key in metadataFields)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _DataValue(
                                      title: key, value: '${data[key] ?? ''}'),
                                ),
                              _DataValue(
                                title: 'Columns',
                                value: data.keys.join(', '),
                                typewriter: true,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 300, width: 300, child: MapDisplay())
                      ],
                    ),
                  ),
                  FredericDivider(),
                  const SizedBox(height: 16),
                  for (final key in textFields)
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 16, right: 16),
                      child: _DataValue(
                        title: key,
                        value: '${data[key]}',
                        largeTitle: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DataValue extends StatelessWidget {
  const _DataValue(
      {super.key,
      required this.title,
      required this.value,
      this.typewriter = false,
      this.largeTitle = false});

  final String title;
  final String value;

  final bool typewriter;
  final bool largeTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: largeTitle ? 14 : 12,
              color: theme.greyTextColor,
              fontWeight: largeTitle ? FontWeight.w600 : FontWeight.w500),
        ),
        SelectableText(value,
            style: typewriter
                ? GoogleFonts.robotoMono()
                : GoogleFonts.montserrat())
      ],
    );
  }
}
