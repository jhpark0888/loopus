import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopus/constant.dart';

class SearchTextFieldWidget extends StatelessWidget {
  SearchTextFieldWidget({
    Key? key,
    required this.ontap,
    required this.hinttext,
    required this.readonly,
    required this.controller,
    this.textInputAction,
    this.onEditingComplete,
  }) : super(key: key);
  void Function()? ontap;
  String hinttext;
  bool readonly;
  TextEditingController? controller;
  TextInputAction? textInputAction;
  Function()? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        autocorrect: false,
        readOnly: readonly,
        onTap: ontap,
        style: k16Normal,
        cursorColor: mainblack,
        cursorWidth: 1.2,
        cursorRadius: Radius.circular(5.0),
        autofocus: false,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          filled: true,
          fillColor: cardGray,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.only(right: 24),
          isDense: true,
          hintText: hinttext,
          hintStyle: k16Normal.copyWith(color: maingray),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 14, 8),
            child: SvgPicture.asset(
              "assets/icons/Search_Inactive.svg",
              width: 20,
              height: 20,
              color: maingray,
            ),
          ),
        ));
  }
}
