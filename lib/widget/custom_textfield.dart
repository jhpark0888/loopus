import 'package:flutter/material.dart';

import '../constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textController;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final String? counterText;
  final int? maxLength;
  final void Function()? ontap;
  final void Function(String)? onfieldSubmitted;
  final bool? autofocus;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final Widget? suffix;
  final TextInputType? keyboardType;

  CustomTextField(
      {required this.textController,
      required this.hintText,
      required this.validator,
      required this.obscureText,
      required this.maxLines,
      required this.counterText,
      required this.maxLength,
      this.keyboardType,
      this.readOnly,
      this.autofocus,
      this.suffix,
      this.ontap,
      this.textInputAction,
      this.onfieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onTap: ontap,
      obscureText: obscureText,
      autocorrect: false,
      readOnly: readOnly ?? false,
      minLines: 1,
      maxLines: maxLines ?? 1,
      autofocus: autofocus ?? true,
      style: kmain,
      cursorColor: mainblue,
      cursorWidth: 1.2,
      cursorRadius: const Radius.circular(2),
      controller: textController,
      onFieldSubmitted: onfieldSubmitted,
      decoration: InputDecoration(
          counterText: counterText,
          contentPadding: const EdgeInsets.only(bottom: 12),
          isDense: true,
          hintText: hintText,
          hintStyle: kmain.copyWith(
            color: maingray,
          ),
          suffix: suffix,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: maingray, width: 1),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: maingray, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: maingray, width: 1),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: rankred, width: 1),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: rankred, width: 1),
          ),
          errorStyle: kmain.copyWith(color: rankred)),
      validator: validator,
    );
  }
}
