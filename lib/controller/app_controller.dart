import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/project_widget.dart';

enum RouteName {
  home,
  search,
  paper,
  bookmark,
  profile,
}

class AppController extends GetxService {
  static AppController get to => Get.find();
  RxBool ismyprofile = false.obs;
  RxInt currentIndex = 0.obs;

  Future<void> changePageIndex(int index) async {
    if (index == 0) {
      if (currentIndex.value == 0) {
        CustomScrollController.to.scrollToTop();
      }
      currentIndex(index);
    }
    if (index == 1) {
      currentIndex(index);
    }
    if (index == 2) {
      if (currentIndex.value != 2) {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 56),
            decoration: BoxDecoration(
              color: mainWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '작성 및 추가',
                      style: kHeaderH1Style,
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: SvgPicture.asset('assets/icons/Close.svg'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/icons/Edit.svg',
                        width: 24,
                      ),
                      decoration: BoxDecoration(
                        color: mainlightgrey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      '포스팅 작성하기',
                      style: kSubTitle3Style,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/icons/Add.svg',
                        width: 24,
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(
                        color: mainlightgrey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      '새로운 활동 추가하기',
                      style: kSubTitle3Style,
                    ),
                  ],
                )
              ],
            ),
          ),
          barrierColor: mainblack.withOpacity(0.3),
          enterBottomSheetDuration: Duration(milliseconds: 150),
          exitBottomSheetDuration: Duration(milliseconds: 150),
        );
      }
    }
    if (index == 3) {
      currentIndex(index);
    }
    if (index == 4) {
      ismyprofile.value = true;

      // if (currentIndex.value != 4) {
      //   //TODO: 임시
      //   ProfileController.to.isProfileLoading.value = true;
      //   ProfileController.to.loadmyProfile();
      // }
      currentIndex(index);
    }
  }
}
