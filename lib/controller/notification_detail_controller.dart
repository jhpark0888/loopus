import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationDetailController extends GetxController {
  static NotificationDetailController get to => Get.find();
  RxBool isNotificationloading = true.obs;
  RxBool isfollowreqloading = true.obs;

  RxList<NotificationWidget> followalarmlist = <NotificationWidget>[].obs;
  RxList<NotificationWidget> alarmlist = <NotificationWidget>[].obs;

  RefreshController alarmRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController followreqRefreshController =
      RefreshController(initialRefresh: false);

  RxBool enablealarmPullup = true.obs;
  RxBool enablefollowreqPullup = true.obs;

  RxBool isalarmEmpty = false.obs;
  RxBool isfollowreqEmpty = false.obs;

  @override
  void onInit() {
    alarmRefresh();
    followreqRefresh();
    super.onInit();
  }

  void alarmRefresh() async {
    alarmlist.clear();
    isalarmEmpty(false);
    enablealarmPullup.value = true;

    await alarmloadItem().then((value) {
      isNotificationloading(false);
    });
    alarmRefreshController.refreshCompleted();
  }

  void alarmLoading() async {
    //페이지 처리
    await alarmloadItem();
    alarmRefreshController.loadComplete();
  }

  void followreqRefresh() async {
    followalarmlist.clear();
    isfollowreqEmpty(false);
    enablefollowreqPullup.value = true;

    await followreqloadItem().then((value) {
      isfollowreqloading(false);
    });
    followreqRefreshController.refreshCompleted();
  }

  void followreqLoading() async {
    //페이지 처리
    await followreqloadItem();
    followreqRefreshController.loadComplete();
  }

  Future<void> alarmloadItem() async {
    List notificationlist = await getNotificationlist(
        "", alarmlist.isEmpty ? 0 : alarmlist.last.notification.id);

    if (notificationlist.isEmpty && alarmlist.isEmpty) {
      isalarmEmpty.value = true;
    } else if (notificationlist.isEmpty && alarmlist.isNotEmpty) {
      enablealarmPullup.value = false;
    }

    for (var notification in notificationlist) {
      NotificationDetailController.to.alarmlist.add(
          NotificationWidget(key: UniqueKey(), notification: notification));
    }
  }

  Future<void> followreqloadItem() async {
    List notificationlist = await getNotificationlist(
        NotificationType.follow.name,
        followalarmlist.isEmpty ? 0 : followalarmlist.last.notification.id);

    if (notificationlist.isEmpty && followalarmlist.isEmpty) {
      isfollowreqEmpty.value = true;
    } else if (notificationlist.isEmpty && followalarmlist.isNotEmpty) {
      enablefollowreqPullup.value = false;
    }

    for (var notification in notificationlist) {
      NotificationDetailController.to.followalarmlist.add(
          NotificationWidget(key: UniqueKey(), notification: notification));
    }
  }
}
