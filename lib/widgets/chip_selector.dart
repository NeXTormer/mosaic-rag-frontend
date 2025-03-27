import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/main.dart';

class ChipSelector extends StatelessWidget {
  const ChipSelector(
      {super.key,
      this.height = 44,
      this.borderRadius = 12,
      required this.onTap,
      required this.child,
      required this.selected});

  final double height;
  final double borderRadius;
  final Function() onTap;
  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: theme.cardBackgroundColor,
          border: Border.all(
              color: selected ? theme.mainColor : theme.cardBorderColor,
              width: 1)),
      child: Container(
          height: height,
          child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
              child: InkWell(
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  splashColor: Colors.grey.withAlpha(32),
                  highlightColor: Colors.grey.withAlpha(15),
                  onTap: onTap,
                  child: child))),
    );
  }
}
