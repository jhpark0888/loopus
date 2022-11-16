import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class SignUpTextWidget extends StatelessWidget {
  SignUpTextWidget({
    Key? key,
    this.highlightText,
    this.twohighlightText,
    required this.oneLinetext,
    required this.twoLinetext,
  }) : super(key: key);

  String? highlightText;
  String? twohighlightText;
  String oneLinetext;
  String twoLinetext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: highlightText ?? "",
              style: MyTextTheme.title(context)
                  .copyWith(color: AppColors.mainblue),
            ),
            TextSpan(
              text: oneLinetext,
              style: MyTextTheme.title(context),
            ),
          ])),
          const SizedBox(
            height: 14,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: twohighlightText ?? "",
              style: MyTextTheme.title(context)
                  .copyWith(color: AppColors.mainblue),
            ),
            TextSpan(
              text: twoLinetext,
              style: MyTextTheme.title(context),
            ),
          ])),
        ],
      ),
    );
  }
}
