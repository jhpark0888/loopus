import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/screen/signup_type_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/screen/login_screen.dart';

class StartScreen extends StatelessWidget {
  final PageController pageController = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: AppColors.mainWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomExpandedButton(
                onTap: () {
                  // showContentModal(context);
                  Get.to(() => SignupTypeScreen());
                },
                isBlue: true,
                isBig: true,
                title: '시작하기',
              ),
              const SizedBox(
                height: 14,
              ),
              CustomExpandedButton(
                onTap: () async {
                  Get.to(
                    () => LogInScreen(),
                  );
                },
                boxColor: AppColors.cardGray,
                textColor: AppColors.mainblack,
                isBlue: false,
                isBig: true,
                title: '이미 계정이 있어요',
              ),
              const SizedBox(
                height: 14,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "시작할 경우 ",
                        style: MyTextTheme.caption(context)
                            .copyWith(color: AppColors.maingray)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => WebViewScreen(url: kPrivacyPolicy));
                          },
                        text: "개인정보처리방침 ",
                        style: MyTextTheme.caption(context).copyWith(
                            color: AppColors.maingray,
                            decoration: TextDecoration.underline)),
                    TextSpan(
                        text: "및 ",
                        style: MyTextTheme.caption(context)
                            .copyWith(color: AppColors.maingray)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => WebViewScreen(url: kTermsOfService));
                          },
                        text: "이용약관",
                        style: MyTextTheme.caption(context).copyWith(
                            color: AppColors.maingray,
                            decoration: TextDecoration.underline)),
                    TextSpan(
                        text: "에 동의됩니다",
                        style: MyTextTheme.caption(context)
                            .copyWith(color: AppColors.maingray)),
                  ])),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: AppColors.mainWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/illustrations/loop_splash.png',
                width: 200,
                height: 120,
              ),
              // const SizedBox(
              //   height: 24,
              // ),
              // RichText(
              //     text: TextSpan(children: [
              //   const TextSpan(text: "내 모든 일상이 포트폴리오가 되다,", style: MyTextTheme.main(context)),
              //   TextSpan(text: " 루프어스", style: MyTextTheme.main(context).copyWith(color: AppColors.mainblue))
              // ]))
            ],
          ),
        ),
      ),
    );
  }
}
