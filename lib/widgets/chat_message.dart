import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:shimmer/shimmer.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.message,
      this.isUser = false,
      this.shimmer = false});

  final String message;
  final bool isUser;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        if (shimmer)
          return Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Shimmer.fromColors(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: constraints.maxWidth * 0.45,
                      decoration: BoxDecoration(
                          color: theme.greyColor,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 16,
                      width: constraints.maxWidth * 0.45,
                      decoration: BoxDecoration(
                          color: theme.greyColor,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 16,
                      width: constraints.maxWidth * 0.3,
                      decoration: BoxDecoration(
                          color: theme.greyColor,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
                baseColor: theme.greyTextColor.withAlpha(40),
                highlightColor: theme.disabledGreyColor.withAlpha(40),
              ),
            ),
          );

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
                child: FredericCard(
                    borderColor:
                        isUser ? theme.cardBorderColor : Colors.transparent,
                    padding: const EdgeInsets.all(12),
                    child: IntrinsicWidth(
                      child: Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        textAlign: isUser ? TextAlign.end : TextAlign.start,
                      ),
                    )),
              ),
            ),
            if (!isUser) SizedBox(width: constraints.maxWidth * 0.3),
          ],
        );
      }),
    );
  }
}
