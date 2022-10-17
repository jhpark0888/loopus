// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/banpeople_screen.dart';
import 'package:loopus/screen/certification_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/screen/withdrawal_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserInfoScreen extends StatelessWidget {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '개인 정보',
      ),
      body: Column(
        children: [
          CustomListTile(
            title: "이름",
            titleColor: maingray,
            onTap: () => userInfoModify(context),
            trailing: HomeController.to.myProfile.value.name,
          ),
          CustomListTile(
            title: "대학",
            titleColor: maingray,
            onTap: () => userInfoModify(context),
            trailing: HomeController.to.myProfile.value is Person
                ? (HomeController.to.myProfile.value as Person).univName
                : "",
          ),
          CustomListTile(
            title: "학과",
            titleColor: maingray,
            onTap: () => userInfoModify(context),
            trailing: HomeController.to.myProfile.value is Person
                ? (HomeController.to.myProfile.value as Person).department
                : "",
          ),
          CustomListTile(
            title: "입학 연도",
            titleColor: maingray,
            onTap: () => userInfoModify(context),
            trailing: HomeController.to.myProfile.value is Person
                ? (HomeController.to.myProfile.value as Person).admissionYear
                : "",
          ),
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
          CustomListTile(
            title: "채팅 데이터베이스 초기화",
            onTap: () {
              showButtonDialog(
                  title: '데이터베이스를 초기화 하시겠어요?',
                  startContent: '채팅 정보가 날라가게 돼요',
                  leftFunction: () => Get.back(),
                  rightFunction: () async {
                    deleteDatabase(join(await getDatabasesPath(),
                        'MY_database${HomeController.to.myProfile.value.userId}.db'));

                    deleteDatabase(
                            join(await getDatabasesPath(), 'MY_database.db'))
                        .then((value) => showBottomSnackbar('삭제되었어요'));
                    Future.delayed(const Duration(milliseconds: 300));
                    Get.back();
                  },
                  rightText: '초기화',
                  leftText: '취소');
            },
          ),
        ],
      ),
    );
  }

  void userInfoModify(BuildContext context) {
    showBottomdialog(context,
        func1: () {
          Get.to(() => CertificationScreen(
                certificateType: CertificateType.userInfoChange,
              ));
        },
        func2: () => Get.back(),
        value1: '재인증을 통해 개인 정보 수정하기',
        value2: '취소',
        buttonColor1: mainblue,
        buttonColor2: maingray,
        title: "개인 정보 수정을 위해선 재인증 절차가 필요합니다\n",
        accentTitle: "학적이 변경된 경우, 변경된 학적 정보를 입력해주세요",
        isOne: false);
  }
}
