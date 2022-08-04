// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/banpeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/screen/withdrawal_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class UserInfoScreen extends StatelessWidget {
  final LogInController _logInController = Get.put(LogInController());
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '계정 정보',
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              '나의 학교',
              style: ktempFont,
            ),
            trailing: Text(
              '인천대학교 송도캠퍼스',
              style: ktempFont,
            ),
          ),
          ListTile(
            title: Text(
              '전공 학과',
              style: ktempFont,
            ),
            trailing: Text(
              profileController.myUserInfo.value.department,
              style: ktempFont,
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => BanPeopleScreen());
            },
            title: Text(
              '차단 목록',
              style: ktempFont,
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => PwChangeScreen(
                    pwType: PwType.pwchange,
                  ));
            },
            title: Text(
              '비밀번호 변경',
              style: ktempFont,
            ),
          ),
          ListTile(
            onTap: () {
              // FlutterSecureStorage().delete(key: "token");
              // FlutterSecureStorage().delete(key: "id");
              showButtonDialog(
                  title: '로그아웃하시겠어요?',
                  content: '중요한 알림을 받지 못하게 돼요',
                  leftFunction: () => Get.back(),
                  rightFunction: () {
                    logOut();
                  },
                  rightText: '로그아웃',
                  leftText: '취소');
              // _logInController.isLogout.value = true;
              // logOut().then((value) {
              //   _logInController.isLogout.value = false;
              //   Get.offAll(() => StartScreen());
              // });
            },
            title: Text(
              '로그아웃',
              style: ktempFont,
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => WithdrawalScreen());
            },
            title: Text(
              '회원탈퇴',
              style: ktempFont.copyWith(color: rankred),
            ),
          )
        ],
      ),
    );
  }

  Future<void> logOut() async {
    loading();
    AppController.to.currentIndex.value = 0;
    String? userid = await FlutterSecureStorage().read(key: "id");
    await FirebaseMessaging.instance.unsubscribeFromTopic(userid!);

    FlutterSecureStorage().delete(key: "token");
    FlutterSecureStorage().delete(key: "id");

    Get.delete<AppController>();
    Get.delete<HomeController>();
    Get.delete<SearchController>();
    Get.delete<ProfileController>();
    Get.offAll(() => StartScreen());
  }
}
