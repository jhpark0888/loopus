// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/contact_content_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class ContactEmailScreen extends StatelessWidget {
  const ContactEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '문의',
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(ContactContentScreen());
            },
            child: Text(
              '다음',
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
            children: [
              Text(
                '답변 받으실 이메일 주소를 입력해주세요',
                style: kSubTitle1Style,
              ),
              SizedBox(
                height: 32,
              ),
              CustomTextField(
                textController: null,
                hintText: 'loopus@loopus.co.kr',
                validator: null,
                obscureText: false,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
