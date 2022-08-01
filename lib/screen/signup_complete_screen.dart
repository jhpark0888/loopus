import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/screen/univ_dept_search_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../utils/check_form_validate.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupCompleteScreen extends StatelessWidget {
  SignupCompleteScreen(
      {Key? key, required this.emailId, required this.password})
      : super(key: key);

  String emailId;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            color: mainWhite,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomExpandedButton(
                  onTap: () async {
                    login(context, emailId: emailId, password: password);
                  },
                  isBlue: true,
                  title: "시작하기",
                  isBig: true),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    oneLinetext: "인증이 완료됐어요", twoLinetext: "가입을 진심으로 환영해요!"),
                Image.asset(
                  'assets/illustrations/welcome_image.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "이제 루프어스를 통해\n본인만의 특별한 스토리를 완성하고\n수많은 기업들과 만나보세요",
                  style: kmainheight,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}