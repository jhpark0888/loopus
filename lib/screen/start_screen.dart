import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return SafeArea(
      child: Scaffold(
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
                CustomExpandedButton(
                  onTap: () => showContentModal(context),
                  isBlue: true,
                  isBig: true,
                  title: '시작하기',
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomExpandedButton(
                  onTap: () async {
                    String? login =
                        await FlutterSecureStorage().read(key: 'login detect');
                    print(login);
                    Get.to(
                      () => LogInScreen(),
                    );
                  },
                  boxColor: dividegray,
                  textColor: mainblack,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/Home_Logo.svg',
                width: 200,
                height: 105,
              ),
              const SizedBox(
                height: 24,
              ),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(text: "내 모든 일상이 포트폴리오가 되다,", style: kmain),
                TextSpan(text: " 루프어스", style: kmain.copyWith(color: mainblue))
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
