import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/widget/signup_text_widget.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.mainWhite,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomExpandedButton(
                onTap: () async {
                  login(
                    context,
                    emailId: emailId,
                    password: password,
                  );
                },
                isBlue: true,
                title: "시작하기",
                isBig: true),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    oneLinetext: "",
                    highlightText: "인증이 완료됐어요",
                    twoLinetext: "가입을 진심으로 환영해요!"),
                Image.asset(
                  'assets/illustrations/welcome_image.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "이제 루프어스를 통해\n"
                  "본인만의 특별한 스토리를 완성하고\n"
                  "회원님을 기다리고 있는 기업들을 만나보세요",
                  style: MyTextTheme.mainheight(context),
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
