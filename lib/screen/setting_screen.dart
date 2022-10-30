// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/screen/alert_screen.dart';
import 'package:loopus/screen/banpeople_screen.dart';
import 'package:loopus/screen/certification_screen.dart';
import 'package:loopus/screen/contact_content_screen.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _category("개인"),
            if (HomeController.to.myProfile.value.userType == UserType.student)
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
            _category("서비스"),
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
            if (HomeController.to.myProfile.value.userType == UserType.company)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _category("회원"),
                  CustomListTile(
                    title: "비밀번호 변경",
                    onTap: () {
                      Get.to(() => PwChangeScreen(
                            pwType: PwType.pwchange,
                          ));
                    },
                  ),
                  CustomListTile(
                    title: "로그아웃",
                    onTap: () {
                      showButtonDialog(
                          title: '로그아웃 하시겠어요?',
                          startContent: '언제든 다시 로그인 할 수 있어요',
                          leftFunction: () => Get.back(),
                          rightFunction: () {
                            logOut();
                          },
                          rightText: '로그아웃',
                          leftText: '취소');
                    },
                  ),
                  CustomListTile(
                    title: "회원탈퇴",
                    titleColor: rankred,
                    onTap: () {
                      showButtonDialog(
                          title: '정말 탈퇴하시겠어요?',
                          startContent: '탈퇴 시 작성된 모든 데이터는 삭제되며,\n이후',
                          highlightContent: " 복구가 불가능 ",
                          endContent: "해요\n다시 한 번 신중하게 생각 후 탈퇴를 진행해주세요",
                          highlightColor: rankred,
                          leftFunction: () => Get.back(),
                          rightFunction: () {
                            Get.to(() => CertificationScreen(
                                  certificateType: CertificateType.withDrawal,
                                ));
                          },
                          rightText: '탈퇴',
                          leftText: '취소');
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _category(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Text(
        text,
        style: kmainbold.copyWith(color: maingray),
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
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
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
