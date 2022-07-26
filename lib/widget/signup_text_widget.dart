import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class SignUpTextWidget extends StatelessWidget {
  SignUpTextWidget({
    Key? key,
    this.highlightText,
    required this.oneLinetext,
    required this.twoLinetext,
  }) : super(key: key);

  String? highlightText;
  String oneLinetext;
  String twoLinetext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: highlightText ?? "",
              style: ktitle.copyWith(color: mainblue),
            ),
            TextSpan(
              text: oneLinetext,
              style: ktitle,
            ),
          ])),
          const SizedBox(
            height: 14,
          ),
          Text(
            twoLinetext,
            style: ktitle,
          ),
        ],
      ),
    );
  }
}
