import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class NotificationDetailController extends GetxController {
  static NotificationDetailController get to => Get.find();
  RxBool isNotificationloading = false.obs;

  RxList<NotificationWidget> followalarmlist = <NotificationWidget>[].obs;
  RxList<NotificationWidget> alarmlist = <NotificationWidget>[].obs;

  @override
  void onInit() {
    isNotificationloading(true);
    getNotificationlist().then((value) {
      isNotificationloading(false);
    });
    super.onInit();
  }
}
