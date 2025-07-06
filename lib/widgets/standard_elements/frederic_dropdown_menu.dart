import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/main.dart' show theme;

class FredericDropdownMenu extends StatelessWidget {
  FredericDropdownMenu(this.text,
      {Color? mainColor,
      Color? textColor,
      required this.items,
      required this.onPressed,
      this.inverted = false,
      this.fontSize = 15,
      this.haptics = false,
      this.fontWeight = FontWeight.w600}) {
    this.mainColor = mainColor ?? theme.mainColor;
    this.textColor = textColor ?? theme.textColor;
  }

  late final Color mainColor;
  late final Color textColor;
  final double height = 44;
  final String text;
  final bool inverted;
  final bool haptics;
  final double fontSize;
  final FontWeight fontWeight;

  final List<String> items;
  final void Function(String?) onPressed;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
            onChanged: onPressed,
            customButton: Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: inverted ? Border.all(color: mainColor) : null,
                  color: inverted ? (theme.cardBackgroundColor) : mainColor),
              child: Center(
                  child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  key: ValueKey<String>(text),
                  style: TextStyle(
                      color: (theme.isBright
                          ? theme.backgroundColor
                          : theme.textColorColorfulBackground),
                      fontWeight: fontWeight,
                      fontSize: fontSize),
                ),
              )),
            ),
            dropdownStyleData: DropdownStyleData(
              width: 240,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.cardBackgroundColor,
              ),
              // offset: const Offset(0, 8),
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                            color: inverted ? mainColor : textColor,
                            fontWeight: fontWeight,
                            fontSize: fontSize),
                      ),
                    ))
                .toList()));
  }
}
