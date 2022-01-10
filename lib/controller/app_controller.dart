import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/bookmark_controller.dart';
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
    }
    if (index == 3) {
      if (currentIndex.value != 3) {
        BookmarkController.to.isBookmarkLoading.value = true;
        BookmarkController.to.onBookmarkRefresh();
      }
    }
    if (index == 4) {
      ismyprofile.value = true;

      if (currentIndex.value != 4) {
        //임시
        ProfileController.to.isProfileLoading.value = true;
        ProfileController.to.loadProfile();
      }
    }
    currentIndex(index);
  }
}
