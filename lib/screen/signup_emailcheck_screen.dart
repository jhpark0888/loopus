import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              if (signupController.emailcheck.value == true) {
                Get.to(() => SignupTagScreen());
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                    color: signupController.emailcheck.value == true
                        ? mainblue
                        : mainblack.withOpacity(0.38)),
              ),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Column(
          children: [
            const Text(
              '받은 메일함에서 계정을 인증해주세요',
              style: kSubTitle1Style,
            ),
            const SizedBox(
              height: 16,
            ),
            //Todo: UX Writing
            //TODO: 이메일 인증 완료 시 화면
            //TODO: 회원가입 시 바로 로그인 되어야 함
            const Text(
              '왜 이메일 인증을 해야하는가?',
              style: kBody2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Obx(
              () => TextFormField(
                readOnly: true,
                style: kSubTitle1Style.copyWith(
                  color: mainblack.withOpacity(0.6),
                ),
                controller: signupController.emailidcontroller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  isDense: false,
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: const BorderSide(color: mainblack, width: 1.2),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: const BorderSide(color: mainblack, width: 1.2),
                  ),
                  suffixIconConstraints:
                      BoxConstraints(minHeight: 24, minWidth: 24),
                  suffixIcon: signupController.emailcheck.value != false
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, left: 0),
                          child: SvgPicture.asset(
                            'assets/icons/Check_Active_blue.svg',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 0),
                          child: Text(
                            '인증 대기 중...',
                            style: kButtonStyle.copyWith(
                                color: mainblack.withOpacity(0.38)),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
