import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartScreen extends StatelessWidget {
  PageController pageController = PageController(viewportFraction: 0.96);
  List text_start = [
    "당신의 대학 생활, 루프어스",
    "본인이 했던 활동들을 남겨보세요.",
    "다른 학생들과 활동을 공유해보세요.",
    "궁금한 점을 질문해보세요.",
    "나에게 맞는 공고를 찾아보세요."
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
              Container(
                height: 485,
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  children: List.generate(
                      5,
                      (int index) => Column(
                            children: [
                              SizedBox(
                                height: 160,
                              ),
                              Container(
                                  height: 200,
                                  width: 250,
                                  child: Image.asset(
                                      "assets/illustrations/tutorial_$index.png")),
                              Padding(
                                padding: index != 0
                                    ? const EdgeInsets.only(top: 30.0)
                                    : const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  text_start[index],
                                  style: kSubTitle1Style,
                                ),
                              ),
                            ],
                          )),
                ),
              ),
              Container(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 5,
                  effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey,
                      activeDotColor: mainblue),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                    onTap: () => Get.to(SignupCampusInfoScreen()),
                    child: Container(
                      decoration: BoxDecoration(
                          color: mainblue,
                          borderRadius: BorderRadius.circular(4)),
                      height: 40,
                      width: Get.width * 0.96,
                      child: Center(
                          child: Text("시작하기",
                              style: TextStyle(
                                  color: mainWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: InkWell(
                    onTap: () => Get.to(LogInScreen()),
                    child: Container(
                      decoration: BoxDecoration(
                          color: mainlightgrey,
                          borderRadius: BorderRadius.circular(4)),
                      height: 40,
                      width: Get.width * 0.96,
                      child: Center(
                        child: Text("이미 계정이 있어요", style: kButtonStyle),
                      ),
                    )),
              ),
              TextButton(
                  onPressed: () {
                    print("click");
                  },
                  child: Text(
                    "기업회원 / 교직원 입니다.",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: mainblack.withOpacity(0.6)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
