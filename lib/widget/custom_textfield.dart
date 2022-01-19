import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopus/controller/login_controller.dart';

import '../utils/check_form_validate.dart';
import '../constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textController;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final String? counterText;
  final int? maxLength;

  CustomTextField({
    required this.textController,
    required this.hintText,
    required this.validator,
    required this.obscureText,
    required this.maxLines,
    required this.counterText,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      obscureText: obscureText,
      autocorrect: false,
      minLines: 1,
      maxLines: maxLines,
      autofocus: true,
      style: kSubTitle3Style.copyWith(height: 1.5),
      cursorColor: mainblack,
      cursorWidth: 1.2,
      cursorRadius: const Radius.circular(2),
      controller: textController,
      decoration: InputDecoration(
        counterText: counterText,
        contentPadding: const EdgeInsets.only(bottom: 12),
        isDense: true,
        hintText: hintText,
        hintStyle: kSubTitle3Style.copyWith(
          color: mainblack.withOpacity(0.38),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: mainblack, width: 1.2),
        ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: mainblack, width: 1.2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainblack, width: 1.2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainpink, width: 1.2),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainpink, width: 1.2),
        ),
      ),
      validator: validator,
    );
  }
}
