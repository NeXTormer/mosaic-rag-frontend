import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/main.dart';

class HoverIconButton extends StatefulWidget {
  const HoverIconButton(this.onTap, {super.key});

  final Function() onTap;

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      child: Icon(
        Icons.highlight_remove,
        color: hover ? theme.negativeColor : theme.greyTextColor,
      ),
      onTap: widget.onTap,
      onHover: (hover_) => setState(() {
        hover = hover_;
      }),
    );
  }
}
