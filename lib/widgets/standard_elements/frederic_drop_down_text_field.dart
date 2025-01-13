import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class FredericDropDownTextField extends StatefulWidget {
  FredericDropDownTextField(
      {this.controller,
      required this.onSubmit,
      required this.defaultValue,
      required this.suggestedValues,
      this.keyboardType = TextInputType.text,
      this.height = 44,
      this.maxLines = 1,
      this.suffixIcon,
      this.onColorfulBackground = false,
      this.onSuffixIconTap,
      this.verticalContentPadding = 0,
      this.text,
      this.brightContents = false,
      this.maxLength = 200});

  final List<String> suggestedValues;
  final String defaultValue;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool brightContents;
  final bool onColorfulBackground;
  final TextEditingController? controller;
  final double height;
  final int maxLines;
  final double verticalContentPadding;
  final int maxLength;
  final String? text;

  final void Function(String) onSubmit;
  final void Function()? onSuffixIconTap;

  @override
  _FredericDropDownTextFieldState createState() =>
      _FredericDropDownTextFieldState();
}

class _FredericDropDownTextFieldState extends State<FredericDropDownTextField> {
  final Color textColor = Colors.black87;
  final Color disabledBorderColor = theme.greyColor; //Color(0xFFE2E2E2);

  @override
  void initState() {
    widget.controller?.text = widget.text ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(builder: (context, constraints) {
        return DropdownMenu(
          controller: widget.controller,
          onSelected: (data) => widget.onSubmit(data ?? ''),
          width: constraints.maxWidth,
          initialSelection: widget.defaultValue,
          dropdownMenuEntries: widget.suggestedValues
              .map((string) => DropdownMenuEntry(
                    value: string,
                    label: string,
                  ))
              .toList(),
          trailingIcon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.greyTextColor,
          ),
          textStyle: TextStyle(fontSize: 13),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                color: widget.onColorfulBackground
                    ? theme.textColorColorfulBackground
                    : theme.greyTextColor),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16, vertical: widget.verticalContentPadding),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  width: 0.6,
                  color:
                      widget.brightContents ? Colors.white : theme.mainColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 0.6, color: disabledBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 0.6, color: disabledBorderColor),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 0.6)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 0.6, color: disabledBorderColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 0.6, color: disabledBorderColor)),
          ),
        );
      }),
    );
  }
}
