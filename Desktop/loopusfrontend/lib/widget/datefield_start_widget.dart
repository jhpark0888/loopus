import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class StartDateTextFormField extends StatelessWidget {
  StartDateTextFormField(
      {Key? key,
      required this.controller,
      this.focusNode,
      required this.maxLenght,
      this.hinttext,
      this.validator})
      : super(key: key);

  TextEditingController controller;
  FocusNode? focusNode;
  int maxLenght;
  String? hinttext;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        validator: validator ?? null,
        focusNode: focusNode ?? null,
        controller: controller,
        cursorColor: mainblack,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: mainblack, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: mainblack, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: mainpink, width: 2),
          ),
          hintText: hinttext ?? '',
        ),
        textAlign: TextAlign.center,
        autocorrect: false,
        cursorWidth: 1.5,
        cursorRadius: Radius.circular(2),
        maxLength: maxLenght,
      ),
      height: 75,
      width: 48,
    );
  }
}
