import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message, this.isUser = false});

  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (isUser) SizedBox(width: constraints.maxWidth * 0.3),
            Expanded(
              child: FredericCard(
                  borderColor:
                      isUser ? theme.cardBorderColor : Colors.transparent,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    textAlign: isUser ? TextAlign.end : TextAlign.start,
                  )),
            ),
            if (!isUser) SizedBox(width: constraints.maxWidth * 0.3),
          ],
        );
      }),
    );
  }
}
