import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationDetailController extends GetxController {
  static NotificationDetailController get to => Get.find();
  // RxBool isNotificationloading = true.obs;
  // RxBool isfollowreqloading = true.obs;

  Rx<ScreenState> notificationscreenstate = ScreenState.loading.obs;
  // Rx<ScreenState> followreqscreenstate = ScreenState.loading.obs;

  // RxList<NotificationModel> followalarmlist = <NotificationModel>[].obs;
  RxList<NotificationModel> alarmlist = <NotificationModel>[].obs;
  RxList<NotificationModel> newalarmList = <NotificationModel>[].obs;
  RxList<NotificationModel> weekalarmList = <NotificationModel>[].obs;
  RxList<NotificationModel> monthalarmList = <NotificationModel>[].obs;
  RxList<NotificationModel> oldalarmList = <NotificationModel>[].obs;

  RefreshController alarmRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController followreqRefreshController =
      RefreshController(initialRefresh: false);

  RxBool enablealarmPullup = true.obs;
  RxBool enablefollowreqPullup = true.obs;

  RxBool isalarmEmpty = false.obs;
  RxBool isfollowreqEmpty = false.obs;

  @override
  void onInit() async {
    await alarmRefresh();
    // followreqRefresh();

    super.onInit();
  }

  Future alarmRefresh() async {
    notificationscreenstate(ScreenState.loading);

    alarmlist.value = [];
    newalarmList.value = [];
    weekalarmList.value = [];
    monthalarmList.value = [];
    oldalarmList.value = [];
    isalarmEmpty(false);
    enablealarmPullup.value = true;

    await alarmloadItem();
    // await followreqloadItem();
    alarmRefreshController.refreshCompleted();
  }

  void alarmLoading() async {
    //페이지 처리
    await alarmloadItem();
    // await followreqloadItem();
    alarmRefreshController.loadComplete();
    print(alarmlist.length);
  }

  // void followreqRefresh() async {
  //   followreqscreenstate(ScreenState.loading);

  //   followalarmlist.clear();
  //   isfollowreqEmpty(false);
  //   enablefollowreqPullup.value = true;

  //   await followreqloadItem();
  //   followreqRefreshController.refreshCompleted();
  // }

  // void followreqLoading() async {
  //   //페이지 처리
  //   await followreqloadItem();
  //   followreqRefreshController.loadComplete();
  // }

  Future<void> alarmloadItem() async {
    // if (alarmlist.isNotEmpty) {
    //   print("알람 마지막 ID:${alarmlist.last.id}");
    // }

    await getNotificationlist("", alarmlist.isEmpty ? 0 : alarmlist.last.id)
        .then((value) {
      if (value.isError == false) {
        List<NotificationModel> notificationlist = List.from(value.data)
            .map((project) => NotificationModel.fromJson(project))
            .toList();

        if (notificationlist.isEmpty && alarmlist.isEmpty) {
          isalarmEmpty.value = true;
        } else if (notificationlist.isEmpty && alarmlist.isNotEmpty) {
          enablealarmPullup.value = false;
        }

        alarmlist.addAll(notificationlist);
        sortAlarmList(notificationlist);

        notificationscreenstate(ScreenState.success);
      } else {
        errorSituation(value);
      }
    });
  }

  // Future<void> followreqloadItem() async {
  //   if (followalarmlist.isNotEmpty) {
  //     print("팔로우 알람 마지막 ID: ${followalarmlist.last.id}");
  //   }
  //   await getNotificationlist(NotificationType.follow.name,
  //           followalarmlist.isEmpty ? 0 : followalarmlist.last.id)
  //       .then((value) {
  //     if (value.isError == false) {
  //       List<NotificationModel> notificationlist = List.from(value.data)
  //           .map((project) => NotificationModel.fromJson(project))
  //           .toList();

  //       if (notificationlist.isEmpty && followalarmlist.isEmpty) {
  //         isfollowreqEmpty.value = true;
  //       } else if (notificationlist.isEmpty && followalarmlist.isNotEmpty) {
  //         enablefollowreqPullup.value = false;
  //       }

  //       followalarmlist.addAll(notificationlist);
  //       sortAlarmList(notificationlist);

  //       followreqscreenstate(ScreenState.success);
  //     } else {
  //       errorSituation(value);
  //     }
  //   });
  // }

  void sortAlarmList(List<NotificationModel> alarmList) {
    // List<NotificationModel> allAlarmList = [];
    // allAlarmList.addAll(alarmlist);
    // allAlarmList.addAll(followalarmlist);
    alarmList.sort((a, b) => b.date.compareTo(a.date));
    // if (allAlarmList.where((noti) => noti.isread.value == false).isNotEmpty) {
    //   newalarmList.value =
    //       sumAlarmList.where((noti) => noti.isread.value == false).toList().obs;
    //   allAlarmList =
    //       sumAlarmList.where((noti) => noti.isread.value == true).toList();
    //   // newalarmList.forEach((element) {
    //   //   element.isnewAlarm.value == true;
    //   // });
    // }
    alarmList.forEach((noti) {
      String strDateDiffer = notiDurationCaculate(startDate: noti.date);
      // if (strDateDiffer == 'today') {
      //   newalarmList.add(noti);
      // } else
      if (strDateDiffer == 'week') {
        if (noti.isread.value == false) {
          newalarmList.add(noti);
        } else {
          weekalarmList.add(noti);
        }
      } else if (strDateDiffer == 'month') {
        monthalarmList.add(noti);
      } else {
        oldalarmList.add(noti);
      }
    });
  }

  void removeNoti(NotificationModel noti) {
    if (newalarmList.contains(noti) == true) {
      newalarmList.remove(noti);
    } else if (weekalarmList.contains(noti) == true) {
      weekalarmList.remove(noti);
    } else if (monthalarmList.contains(noti) == true) {
      monthalarmList.remove(noti);
    } else {
      oldalarmList.remove(noti);
    }
  }

  String notiDurationCaculate({
    required DateTime startDate,
  }) {
    RxString durationResult = ''.obs;
    DateTime endDate = DateTime.now();
    DateFormat dateonlyFormat = DateFormat('yyyy-MM-dd');
    DateTime startDateOnlyDay =
        DateTime.parse(dateonlyFormat.format(startDate));
    DateTime endDateOnlyDay = DateTime.parse(dateonlyFormat.format(endDate));
    int _dateOnlyDiffence =
        (endDateOnlyDay.difference(startDateOnlyDay).inDays).toInt();
    int _dateDiffence = (endDate.difference(startDate).inDays).toInt();

    // if (_dateOnlyDiffence <= 1) {
    //   durationResult.value = 'today';
    // } else
    if (_dateOnlyDiffence <= 7) {
      durationResult.value = 'week';
    } else if ((_dateOnlyDiffence / 30).floor() < 1) {
      durationResult.value = 'month';
    } else if ((_dateOnlyDiffence / 30).floor() >= 1) {
      durationResult.value = 'old';
    }

    return durationResult.value;
  }
}
