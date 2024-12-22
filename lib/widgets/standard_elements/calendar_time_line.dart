import 'package:flutter/material.dart';

import '../../main.dart';

class CalendarTimeLine extends StatelessWidget {
  CalendarTimeLine(
      {this.isActive = false, this.finished = false, Color? activeColor}) {
    this.activeColor = activeColor ?? theme.mainColor;
    disabledColor = theme.disabledGreyColor;
    this.finishedColor = theme.positiveColor;
  }

  final bool isActive;
  final bool finished;

  late final Color activeColor;
  late final Color disabledColor;
  late final Color finishedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: !isActive
                ? finished
                    ? [
                        circle(finishedColor, 8),
                        circle(finishedColor.withOpacity(0.1), 16)
                      ]
                    : [
                        circle(disabledColor, 10),
                        circle(Colors.white, 6),
                        circle(Colors.transparent, 16)
                      ]
                : [
                    circle(activeColor, 10),
                    circle(activeColor.withOpacity(0.1), 20)
                  ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              width: 3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: !isActive
                          ? finished
                              ? [finishedColor, finishedColor.withAlpha(0)]
                              : [disabledColor, disabledColor.withAlpha(0)]
                          : [activeColor, activeColor.withAlpha(0)]),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
          ),
        ],
      ),
    );
  }

  Widget circle(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}
