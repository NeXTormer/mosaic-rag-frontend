import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class FredericTextField extends StatefulWidget {
  FredericTextField(this.placeholder,
      {this.controller,
      this.defaultValue,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.icon = Icons.person,
      this.size = 16,
      this.height = 44,
      this.maxLines = 1,
      this.suffixIcon,
      this.onColorfulBackground = false,
      this.isPasswordField = false,
      this.onSuffixIconTap,
      this.verticalContentPadding = 0,
      this.text,
      this.brightContents = false,
      this.maxLength = 200});

  String? defaultValue;
  final String? placeholder;
  final TextInputType keyboardType;
  final IconData? icon;
  final Widget? suffixIcon;
  final double size;
  final bool isPasswordField;
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
  _FredericTextFieldState createState() => _FredericTextFieldState();
}

class _FredericTextFieldState extends State<FredericTextField> {
  final Color disabledBorderColor = theme.greyColor;

  bool showPassword = false;

  @override
  void initState() {
    widget.controller?.text = widget.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: TextFormField(
        onChanged: widget.onSubmit,
        initialValue: widget.defaultValue,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          fontSize: 13,
          color: theme.textColor,
        ),
        maxLines: widget.maxLines,
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        obscureText: widget.isPasswordField && !showPassword,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hoverColor: null,
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
          suffix: widget.isPasswordField
              ? Padding(
                  padding: const EdgeInsets.only(right: 8, left: 2),
                  child: GestureDetector(
                    onTap: () => setState(() => showPassword = !showPassword),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: showPassword
                          ? Colors.black87
                          : const Color(0xFFC9C9C9),
                      size: 16,
                    ),
                  ),
                )
              : Container(
                  height: 16,
                  width: 0,
                ),
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
