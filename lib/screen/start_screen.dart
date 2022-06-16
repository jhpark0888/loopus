import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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
              CustomExpandedButton(
                buttonTag: '시작하기',
                onTap: () => showContentModal(context),
                isBlue: true,
                isBig: true,
                title: '시작하기',
              ),
              const SizedBox(
                height: 12,
              ),
              CustomExpandedButton(
                buttonTag: '이미 계정이 있어요',
                onTap: () async {
                  String? login =
                      await FlutterSecureStorage().read(key: 'login detect');
                  print(login);
                  Get.to(
                    () => LogInScreen(),
                  );
                },
                isBlue: false,
                isBig: true,
                title: '이미 계정이 있어요',
              ),
              const SizedBox(
                height: 24,
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
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: kOnboadingTextChunk1[index],
                          style: kHeaderH2Style),
                      TextSpan(
                        text: kOnboadingTextChunk2[index],
                        style: kHeaderH2Style.copyWith(
                          color: mainblue,
                        ),
                      ),
                      TextSpan(
                        text: kOnboadingTextChunk3[index],
                        style: kHeaderH2Style,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
