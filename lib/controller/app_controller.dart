import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/project_widget.dart';

enum RouteName { Home, Search, Paper, Bookmark, Profile }

class AppController extends GetxService {
  static AppController get to => Get.find();

  RxInt currentIndex = 0.obs;

  Future<void> changePageIndex(int index) async {
    if (index == 4) {
      String? user_id = await FlutterSecureStorage().read(key: "id");
      await getProfile(user_id).then((response) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        ProfileController.to.user(User.fromJson(responseBody));

        List projectmaplist = responseBody['project'];
        ProfileController.to.projectlist(projectmaplist
            .map((project) => Project.fromJson(project))
            .map((project) => ProjectWidget(
                  project: project,
                ))
            .toList());
      });
    }
    currentIndex(index);
  }
}
