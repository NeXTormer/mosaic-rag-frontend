import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/calendar_time_line.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';

import 'standard_elements/frederic_chip.dart';

class MosaicSearchResult extends StatelessWidget {
  MosaicSearchResult(
      {super.key,
      required this.url,
      required this.title,
      required this.text,
      this.textHeader = 'Excerpt',
      this.chips = const <String>[]});

  final String url;
  final List<String> chips;
  final String title;
  final String text;
  final String textHeader;

  RegExp domainRegExp =
      RegExp(r'/^(?:https?:\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n?]+)/img');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, right: 24),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            CalendarTimeLine(
              isActive: true,
              activeColor: theme.mainColor,
            ),
            SizedBox(width: 16),
            Expanded(
              child: FredericCard(
                height: 200,
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          domainRegExp.firstMatch(url)?.group(1) ?? url,
                          style: GoogleFonts.montserrat(
                              color: theme.mainColor, fontSize: 12),
                        ),
                        Expanded(
                          child: Container(),
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
                        style: GoogleFonts.montserrat(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      textHeader,
                      style: GoogleFonts.montserrat(
                          color: theme.greyTextColor, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        text,
                        style: GoogleFonts.montserrat(
                            color: theme.textColor,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
