// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/screen/alert_screen.dart';
import 'package:loopus/screen/banpeople_screen.dart';
import 'package:loopus/screen/contact_content_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/user_device_info.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  final UserDeviceInfo _userDeviceInfo = Get.put(UserDeviceInfo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: mainWhite,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => _userDeviceInfo.appInfoData.isNotEmpty
                  ? Text(
                      _userDeviceInfo.appInfoData.keys.first +
                          ' ' +
                          _userDeviceInfo.appInfoData.values.first,
                      style: ktempFont.copyWith(
                        color: mainblack.withOpacity(0.6),
                      ),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '설정',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "개인",
              style: kmainbold.copyWith(color: maingray),
            ),
          ),
          CustomListTile(
            title: "개인 정보",
            onTap: () {
              Get.to(() => UserInfoScreen());
            },
          ),
          CustomListTile(
            title: "알림 설정",
            onTap: () {
              Get.to(() => AlertScreen());
            },
          ),
          CustomListTile(
            title: "차단 관리",
            onTap: () {
              Get.to(() => BanPeopleScreen());
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "서비스",
              style: kmainbold.copyWith(color: maingray),
            ),
          ),
          CustomListTile(
            title: "서비스 이용약관",
            onTap: () {
              Get.to(() => WebViewScreen(url: kTermsOfService));
            },
          ),
          CustomListTile(
            title: "개인정보 처리방침",
            onTap: () {
              Get.to(() => WebViewScreen(url: kPrivacyPolicy));
            },
          ),
          CustomListTile(
            title: "문의하기",
            onTap: () {
              Get.to(() => ContactContentScreen());
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile(
      {required this.onTap,
      required this.title,
      this.titleColor,
      this.trailing});

  final VoidCallback onTap;
  final String title;
  final Color? titleColor;
  final String? trailing;

  final HoverController _hoverController = HoverController();
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
          vertical: 12,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(title,
                  style: kmain.copyWith(
                      color: _hoverController.isHover.value
                          ? titleColor != null
                              ? titleColor!.withOpacity(0.5)
                              : maingray
                          : titleColor ?? mainblack)),
            ),
            if (trailing != null)
              Obx(
                () => Text(trailing!,
                    style: kmain.copyWith(
                        color: _hoverController.isHover.value
                            ? maingray
                            : mainblack)),
              ),
            // SvgPicture.asset('assets/icons/arrow_right.svg'),
          ],
        ),
      ),
    );
  }
}
