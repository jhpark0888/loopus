import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/screen/login_screen.dart';

class StartScreen extends StatelessWidget {
  final PageController pageController = PageController(viewportFraction: 1);
  final ModalController _modalController = Get.put(ModalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: mainWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
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
                height: 12,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: mainWhite,
        child: PageView(
          physics: const BouncingScrollPhysics(),
          controller: pageController,
          children: List.generate(
            3,
            (int index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child:
                      Image.asset("assets/illustrations/tutorial_$index.png"),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  kOnboadingText[index],
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
