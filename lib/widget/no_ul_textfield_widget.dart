import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class NoUlTextField extends StatelessWidget {
  NoUlTextField({
    Key? key,
    required this.controller,
    this.hintText,
    required this.obscureText,
    this.maxLines,
    this.maxLength,
    this.onChanged
  }) : super(key: key);
  TextEditingController? controller;
  bool obscureText;
  int? maxLines;
  int? maxLength;
  String? hintText;
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: TextDirection.ltr,
      maxLength: maxLength,
      obscureText: obscureText,
      autocorrect: false,
      minLines: 6,
      maxLines: maxLines,
      autofocus: false,
      style: kmain.copyWith(height: 1.5),
      cursorColor: mainblue,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(2),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 12),
        isDense: true,
        hintText: hintText,
        hintStyle: kmain.copyWith(
          color: mainblack.withOpacity(0.38),
        ),
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}
