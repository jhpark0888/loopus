import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopus/constant.dart';

class CertfyTextFieldWidget extends StatelessWidget {
  CertfyTextFieldWidget({Key? key, required this.controller}) : super(key: key);

  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        maxLength: 6,
        maxLines: 1,
        style: MyTextTheme.main(context),
        cursorColor: AppColors.mainblack,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly
        ],
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColors.cardGray,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          hintText: "인증번호 6자리 입력",
          hintStyle:
              MyTextTheme.main(context).copyWith(color: AppColors.maingray),
        ));
  }
}
