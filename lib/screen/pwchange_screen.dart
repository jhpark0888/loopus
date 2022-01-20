// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class PwChangeScreen extends StatelessWidget {
  const PwChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '비밀번호 변경',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '새로운 비밀번호',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: null,
              hintText: '',
              validator: null,
              obscureText: true,
              maxLines: 1,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              '새로운 비밀번호 확인',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: null,
              hintText: '',
              validator: null,
              obscureText: true,
              maxLines: 1,
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: mainblue,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    '변경하기',
                    style: kButtonStyle.copyWith(color: mainWhite),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
