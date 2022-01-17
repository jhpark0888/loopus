import 'package:flutter/material.dart';
import 'package:loopus/controller/login_controller.dart';

import '../check_form_validate.dart';
import '../constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;

  CustomTextField({
    required this.textController,
    required this.hintText,
    required this.validator,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autocorrect: false,
      minLines: 1,
      maxLines: 1,
      autofocus: true,
      style: kSubTitle3Style,
      cursorColor: mainblack,
      cursorWidth: 1.2,
      cursorRadius: Radius.circular(2),
      controller: textController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 12),
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
