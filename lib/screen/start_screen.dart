import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartScreen extends StatelessWidget {
  PageController pageController = PageController(viewportFraction: 1);
  ModalController _modalController = Get.put(ModalController());
  List text_start = [
    "당신의 대학 생활, 루프어스",
    "본인이 했던 활동들을 남겨보세요",
    "다른 학생들과 활동을 공유해보세요",
    "궁금한 점을 질문해보세요",
    "나에게 맞는 공고를 찾아보세요"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: mainWhite,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  children: List.generate(
                    5,
                    (int index) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200,
                            width: 250,
                            child: Image.asset(
                                "assets/illustrations/tutorial_$index.png")),
                        Text(
                          text_start[index],
                          style: kSubTitle1Style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: 5,
                          effect: const WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              dotColor: Color(0xffe7e7e7),
                              activeDotColor: mainblue),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _modalController.showContentModal(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                              color: mainblue,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            "시작하기",
                            textAlign: TextAlign.center,
                            style: kButtonStyle.copyWith(
                              color: mainWhite,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () => Get.to(() => LogInScreen()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0xffe7e7e7),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            "이미 계정이 있어요",
                            textAlign: TextAlign.center,
                            style: kButtonStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                color: mainblack),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextButton(
                        onPressed: () {
                          print("click");
                        },
                        child: Text(
                          "기업회원 / 교직원 입니다",
                          style: TextStyle(
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                  color: mainblack.withOpacity(0.6),
                                  offset: const Offset(0, -6))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: mainblack.withOpacity(0.6),
                            decorationThickness: 1,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
