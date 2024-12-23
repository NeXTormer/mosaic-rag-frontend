import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class FredericDropDownTextField extends StatefulWidget {
  FredericDropDownTextField(this.placeholder,
      {this.controller,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.icon = Icons.person,
      this.size = 16,
      this.height = 44,
      this.maxLines = 1,
      this.suffixIcon,
      this.onColorfulBackground = false,
      this.onSuffixIconTap,
      this.verticalContentPadding = 0,
      this.text,
      this.brightContents = false,
      this.maxLength = 200});

  final String placeholder;
  final TextInputType keyboardType;
  final IconData? icon;
  final Widget? suffixIcon;
  final double size;
  final bool brightContents;
  final bool onColorfulBackground;
  final TextEditingController? controller;
  final double height;
  final int maxLines;
  final double verticalContentPadding;
  final int maxLength;
  final String? text;

  final void Function(String)? onSubmit;
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
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: DropdownMenu(
        dropdownMenuEntries: [
          DropdownMenuEntry(value: 'value', label: 'label')
        ],
        trailingIcon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.greyTextColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: widget.onColorfulBackground
                  ? theme.textColorColorfulBackground
                  : theme.greyTextColor),
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.icon == null ? 16 : 8,
              vertical: widget.verticalContentPadding),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                width: 0.6,
                color: widget.brightContents ? Colors.white : theme.mainColor),
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
      ),
    );

    return Container(
      height: widget.height,
      child: TextField(
        onSubmitted: widget.onSubmit,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          fontSize: 14,
          color: widget.onColorfulBackground
              ? theme.textColorColorfulBackground
              : theme.greyTextColor,
          letterSpacing: 0.2,
        ),
        maxLines: widget.maxLines,
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        obscureText: false,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              color: widget.onColorfulBackground
                  ? theme.textColorColorfulBackground
                  : theme.greyTextColor),
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  size: widget.size,
                  color: widget.brightContents
                      ? Colors.white
                      : theme.mainColorInText,
                ),
          suffixIcon: widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.icon == null ? 16 : 8,
              vertical: widget.verticalContentPadding),
          hintText: widget.placeholder,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                width: 0.6,
                color: widget.brightContents ? Colors.white : theme.mainColor),
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
      ),
    );
  }
}
