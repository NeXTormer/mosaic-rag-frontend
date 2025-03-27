import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/widgets/mosaic_search_result_large.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/calendar_time_line.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';

import 'standard_elements/frederic_chip.dart';

import 'dart:js' as js;

class MosaicSearchResult extends StatelessWidget {
  MosaicSearchResult(
      {super.key,
      required this.url,
      required this.title,
      required this.text,
      this.rawData,
      this.textHeader = 'Excerpt',
      this.chips = const <String>[]});

  final Map<String, dynamic>? rawData;

  final String url;
  final List<String> chips;
  final String title;
  final String text;
  final String textHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                height: double.infinity,
                child: CalendarTimeLine(
                  isActive: true,
                  activeColor: theme.mainColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Center(
                            child:
                                MosaicSearchResultLarge(data: rawData ?? {}));
                      },
                    ),
                    child: IntrinsicHeight(
                      child: FredericCard(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 0),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Linkify(
                                      options: LinkifyOptions(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyle(fontFamily: 'Montserrat'),
                                      text: url,
                                      onOpen: (e) =>
                                          js.context.callMethod('open', [url]),
                                    ),
                                  ),
                                  for (final chip in chips)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: FredericChip(chip),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                textHeader,
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                    color: theme.greyTextColor, fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              IntrinsicHeight(
                                child: Text(
                                  text
                                      .replaceAll('\s+', '')
                                      .replaceAll('\n', ' '),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
