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
    this.onchanged,
    this.onEditingComplete,
    this.autofocus,
    this.onSubmitted,
  }) : super(key: key);
  void Function()? ontap;
  void Function(String)? onchanged;
  String hinttext;
  bool readonly;
  bool? autofocus;
  TextEditingController? controller;
  TextInputAction? textInputAction;
  Function()? onEditingComplete;
  Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        autocorrect: false,
        readOnly: readonly,
        onTap: ontap,
        onChanged: onchanged,
        style: kmain,
        cursorColor: mainblack,
        cursorWidth: 1.2,
        cursorRadius: Radius.circular(5.0),
        autofocus: autofocus ?? false,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
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
          hintStyle: kmain.copyWith(color: maingray),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 14, 8),
            child: SvgPicture.asset(
              "assets/icons/search_inactive.svg",
              width: 20,
              height: 20,
              color: maingray,
            ),
          ),
        ));
  }
}
