// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/contact_content_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class ContactFinishScreen extends StatelessWidget {
  const ContactFinishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '문의',
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '완료',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  '문의해주셔서 감사합니다',
                  style: kSubTitle1Style,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  '최대한 빠르게 답변드리도록 하겠습니다!\n메일 문의 : help@loopus.co.kr',
                  style: kBody1Style,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
