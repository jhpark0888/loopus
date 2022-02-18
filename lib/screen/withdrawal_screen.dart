// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
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
              TextEditingController pwcontroller = TextEditingController();
              ModalController.to.showTextFieldDialog(
                  title: "비밀번호를 입력해주세요\n비밀번호 입력 후 확인 클릭 시 \n바로 회원탈퇴가 진행됩니다",
                  hintText: "8자리 이상",
                  textEditingController: pwcontroller,
                  obscureText: true,
                  validator: (value) =>
                      CheckValidate().validatePassword(value!),
                  leftFunction: () => Get.back(),
                  rightFunction: () {
                    deleteuser(pwcontroller.text);
                  });
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
                counterText: null,
                maxLength: null,
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
