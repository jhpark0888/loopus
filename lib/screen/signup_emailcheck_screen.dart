import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

import '../controller/ga_controller.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  final SignupController signupController = Get.find();
  final GAController _gaController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (signupController.signupcertification.value ==
                  Emailcertification.success) {
                Get.to(() => SignupTagScreen());
                await _gaController.logScreenView('signup_5');
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                    color: signupController.signupcertification.value ==
                            Emailcertification.success
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '받은 메일함',
                    style: kSubTitle1Style.copyWith(
                      color: mainblue,
                    ),
                  ),
                  const TextSpan(
                    text: '에서 학교 메일을 인증해주세요',
                    style: kSubTitle1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            //Todo: UX Writing
            //TODO: 이메일 인증 완료 시 화면
            //TODO: 회원가입 시 바로 로그인 되어야 함
            const Text(
              '이제 마지막 단계만 남았어요',
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
                //TODO: 학교 도메인 확인
                initialValue:
                    signupController.emailidcontroller.text + '@inu.ac.kr',
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
                  suffixIcon: signupController.signupcertification.value ==
                          Emailcertification.success
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, left: 0),
                          child: SvgPicture.asset(
                            'assets/icons/Check_Active_blue.svg',
                          ),
                        )
                      : signupController.signupcertification.value ==
                              Emailcertification.waiting
                          ? Obx(
                              () => Text(
                                '0${signupController.sec.value ~/ 60}:${NumberFormat('00', "ko").format(signupController.sec.value % 60)}',
                                style: kButtonStyle.copyWith(color: mainblack),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                emailRequest();
                              },
                              child: Text(
                                '재전송',
                                style: kButtonStyle.copyWith(color: mainblue),
                              )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
