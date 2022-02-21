// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/contact_email_screen.dart';
import 'package:loopus/screen/contact_finish_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class ContactContentScreen extends StatelessWidget {
  const ContactContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '문의',
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(ContactEmailScreen());
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '문의 내용을 적어주세요',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 32,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: null,
              hintText: '문의 내용...',
              validator: null,
              obscureText: false,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
