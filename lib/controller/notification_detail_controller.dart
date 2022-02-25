import 'package:get/get.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationDetailController extends GetxController {
  static NotificationDetailController get to => Get.find();
  // RxBool isNotificationloading = true.obs;
  // RxBool isfollowreqloading = true.obs;

  Rx<ScreenState> notificationscreenstate = ScreenState.loading.obs;
  Rx<ScreenState> followreqscreenstate = ScreenState.loading.obs;

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
    notificationscreenstate(ScreenState.loading);
    alarmlist.clear();
    isalarmEmpty(false);
    enablealarmPullup.value = true;

    await alarmloadItem();
    alarmRefreshController.refreshCompleted();
  }

  void alarmLoading() async {
    //페이지 처리
    await alarmloadItem();
    alarmRefreshController.loadComplete();
  }

  void followreqRefresh() async {
    followreqscreenstate(ScreenState.loading);

    followalarmlist.clear();
    isfollowreqEmpty(false);
    enablefollowreqPullup.value = true;

    await followreqloadItem();
    followreqRefreshController.refreshCompleted();
  }

  void followreqLoading() async {
    //페이지 처리
    await followreqloadItem();
    followreqRefreshController.loadComplete();
  }

  Future<void> alarmloadItem() async {
    await getNotificationlist(
        "", alarmlist.isEmpty ? 0 : alarmlist.last.notification.id);
  }

  Future<void> followreqloadItem() async {
    await getNotificationlist(NotificationType.follow.name,
        followalarmlist.isEmpty ? 0 : followalarmlist.last.notification.id);
  }
}
