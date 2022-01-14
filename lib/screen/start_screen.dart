import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/screen/login_screen.dart';

//TODO : 일러스트 다시 만들까...

class StartScreen extends StatelessWidget {
  final PageController pageController = PageController(viewportFraction: 1);
  final ModalController _modalController = Get.put(ModalController());

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
                flex: 7,
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
                              "assets/illustrations/tutorial_$index.png"),
                        ),
                        SizedBox(
                          height: index != 0 ? 24 : 0,
                        ),
                        Text(
                          kOnboadingText[index],
                          style: kSubTitle1Style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        height: 24,
                      ),
                      InkWell(
                        onTap: () => _modalController.showContentModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: mainblue,
                            borderRadius: BorderRadius.circular(4),
                          ),
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
                        onTap: () => Get.to(
                          () => LogInScreen(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffe7e7e7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "이미 계정이 있어요",
                            textAlign: TextAlign.center,
                            style: kButtonStyle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "기업회원 또는 교직원입니다",
                          style: kButtonStyle.copyWith(
                            color: mainblack.withOpacity(0.6),
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
