// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/screen/contact_email_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:app_settings/app_settings.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '설정',
      ),
      body: Column(
        children: [
          CustomListTile(
            hoverTag: '계정 정보',
            title: '계정 정보',
            onTap: () {
              Get.to(() => UserInfoScreen());
            },
          ),
          CustomListTile(
            hoverTag: '알림 설정',
            title: '알림 설정',
            onTap: () {
              AppSettings.openNotificationSettings();
            },
          ),
          CustomListTile(
            hoverTag: '서비스 이용약관',
            title: '서비스 이용약관',
            onTap: () {
              Get.to(() => TermsOfServiceScreen());
            },
          ),
          CustomListTile(
            hoverTag: '개인정보 처리방침',
            title: '개인정보 처리방침',
            onTap: () {
              Get.to(() => PrivacyPolicyScreen());
            },
          ),
          CustomListTile(
            hoverTag: '문의하기',
            title: '문의하기',
            onTap: () {
              Get.to(() => ContactEmailScreen());
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({
    required this.onTap,
    required this.title,
    required this.hoverTag,
  });

  final VoidCallback onTap;
  final String title;
  final String hoverTag;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: hoverTag);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                title,
                style: kSubTitle3Style.copyWith(
                    color: _hoverController.isHover.value
                        ? mainblack.withOpacity(0.6)
                        : mainblack),
              ),
            ),
            Obx(
              () => SvgPicture.asset('assets/icons/Arrow_right.svg',
                  color: _hoverController.isHover.value
                      ? mainblack.withOpacity(0.6)
                      : mainblack),
            ),
          ],
        ),
      ),
    );
  }
}
