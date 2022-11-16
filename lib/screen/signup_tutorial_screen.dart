import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({Key? key, required this.emailId, required this.password})
      : super(key: key);

  PageController pageController = PageController();
  int tutorialCount = 8;
  RxInt currentIndex = 1.obs;
  String emailId;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          leading: Container(),
          actions: [
            GestureDetector(
                onTap: () {
                  if (currentIndex.value == tutorialCount) {
                    login(
                      context,
                      emailId: emailId,
                      password: password,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Obx(
                      () => Text("시작하기",
                          style: MyTextTheme.navigationTitle(context).copyWith(
                            color: currentIndex.value == tutorialCount
                                ? AppColors.mainblue
                                : AppColors.maingray,
                          )),
                    ),
                  ),
                ))
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: (552.16 / 255) * (Get.width - 120),
              child: PageView.builder(
                controller: pageController,
                itemBuilder: (context, index) => KeepAliveWidget(
                  child: Image.asset(
                    "assets/illustrations/tutorial${index + 1}.png",
                    width: Get.width - 120,
                  ),
                ),
                itemCount: tutorialCount,
                onPageChanged: (index) {
                  currentIndex.value = index + 1;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: tutorialCount,
                effect: ScrollingDotsEffect(
                  dotColor: AppColors.maingray,
                  activeDotColor: AppColors.mainblue,
                  spacing: 8,
                  dotWidth: 7,
                  dotHeight: 7,
                ),
              ),
            ),
          ],
        ));
  }
}
