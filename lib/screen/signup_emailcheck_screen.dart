import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_tag_screen.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  // const SignupEmailcheckScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
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
            Text(
              '학교 메일로 인증 메일을 보내드렸어요',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
                autocorrect: false,
                minLines: 1,
                maxLines: 2,
                autofocus: true,
                style: kSubTitle1Style,
                cursorColor: mainblack,
                cursorWidth: 1.5,
                cursorRadius: Radius.circular(2),
                controller: signupController.emailidcontroller,
                decoration: InputDecoration(
                    hintText: 'loopus@inu.ac.kr',
                    hintStyle: kSubTitle1Style.copyWith(
                      color: mainblack.withOpacity(0.38),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                          color: mainblack.withOpacity(
                            0.6,
                          ),
                          width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainblack, width: 1),
                    ),
                    suffix: signupController.emailcheck.value != true
                        ? Text(
                            '인증 대기 중...',
                            style: kButtonStyle.copyWith(
                                color: mainblack.withOpacity(0.38)),
                          )
                        : SvgPicture.asset(
                            'assets/icons/Check_Active_blue.svg')),
                validator: (value) => CheckValidate().validateEmail(value!)),
            // Container(
            //   height: 40,
            //   child: TextFormField(
            //       obscureText: true,
            //       controller: signupController.passwordcontroller,
            //       cursorColor: Colors.black,
            //       decoration: InputDecoration(
            //         hintText: "영어, 숫자, 특수문자 포함 8자리 이상",
            //         hintStyle: TextStyle(fontSize: 14),
            //         enabledBorder: OutlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: Colors.black, width: 1.2)),
            //         focusedBorder: OutlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: Colors.black, width: 1.5),
            //             borderRadius: BorderRadius.circular(3)),
            //         focusColor: Colors.black,
            //         contentPadding: EdgeInsets.all(10),
            //       ),
            //       validator: (value) =>
            //           CheckValidate().validatePassword(value!)),
            // ),
            // Container(
            //   height: 40,
            //   child: TextFormField(
            //       obscureText: true,
            //       controller: signupController.passwordcheckcontroller,
            //       cursorColor: Colors.black,
            //       decoration: InputDecoration(
            //         hintText: "비밀번호와 같아야 합니다.",
            //         hintStyle: TextStyle(fontSize: 14),
            //         enabledBorder: OutlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: Colors.black, width: 1.2)),
            //         focusedBorder: OutlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: Colors.black, width: 1.5),
            //             borderRadius: BorderRadius.circular(3)),
            //         focusColor: Colors.black,
            //         contentPadding: EdgeInsets.all(10),
            //       ),
            //       validator: (value) {
            //         if (value != signupController.passwordcontroller.text) {
            //           return "비밀번호와 같지 않습니다.";
            //         } else {
            //           return null;
            //         }
            //       }),
            // ),
            // TextButton(
            //   onPressed: () {
            //     emailRequest();
            //   },
            //   child: Text(
            //     '인증하기',
            //     style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.amber),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
