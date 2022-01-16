// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '회원탈퇴',
        actions: [
          TextButton(
            onPressed: () {
              ModalController.to.showButtonDialog(
                  leftText: '취소',
                  rightText: '탈퇴',
                  title: '정말 탈퇴하시겠어요?',
                  content: '회원님의 모든 정보와 데이터들이 삭제돼요',
                  leftFunction: () {},
                  rightFunction: () => Get.back());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '탈퇴하기',
                style: kSubTitle2Style.copyWith(color: mainpink),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            children: [
              Text(
                '탈퇴하시는 이유가 무엇인가요?',
                style: kSubTitle1Style,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '적어주신 내용들을 적극적으로 개선하겠습니다',
                style: kBody1Style,
              ),
              SizedBox(
                height: 32,
              ),
              CustomTextField(
                textController: null,
                hintText: '탈퇴 사유...',
                validator: null,
                obscureText: false,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
