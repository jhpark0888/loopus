import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  RxList<NotificationWidget> newalarmList = <NotificationWidget>[].obs;
  RxList<NotificationWidget> weekalarmList = <NotificationWidget>[].obs;
  RxList<NotificationWidget> monthalarmList = <NotificationWidget>[].obs;
  RxList<NotificationWidget> oldalarmList = <NotificationWidget>[].obs;

  RefreshController alarmRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController followreqRefreshController =
      RefreshController(initialRefresh: false);

  RxBool enablealarmPullup = true.obs;
  RxBool enablefollowreqPullup = true.obs;

  RxBool isalarmEmpty = false.obs;
  RxBool isfollowreqEmpty = false.obs;

  @override
  void onInit() async{
    alarmRefresh();
    // followreqRefresh();
    super.onInit();
  }

  void alarmRefresh() async {
    notificationscreenstate(ScreenState.loading);
    alarmlist.clear();
    followalarmlist.clear();
    newalarmList.clear();
    weekalarmList.clear();
    monthalarmList.clear();
    oldalarmList.clear();
    isalarmEmpty(false);
    enablealarmPullup.value = true;

    await alarmloadItem();
    await followreqloadItem();
    sortAlarmList(alarmlist + followalarmlist);
    alarmRefreshController.refreshCompleted();
  }

  void alarmLoading() async {
    //페이지 처리
    await alarmloadItem();
    await followreqloadItem();
    sortAlarmList(alarmlist + followalarmlist);
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
    if(alarmlist.isNotEmpty){
    print(alarmlist.last.notification.id);}
    await getNotificationlist(
        "else", alarmlist.isEmpty ? 0 : alarmlist.last.notification.id);
  }

  Future<void> followreqloadItem() async {
    await getNotificationlist(NotificationType.follow.name,
        followalarmlist.isEmpty ? 0 : followalarmlist.last.notification.id);
  }

  void sortAlarmList(List<NotificationWidget> alarmList) {
    alarmList.sort((a, b) => b
              .notification.date
              .compareTo(a.notification.date));
    if (alarmList
        .where((noti) => noti.notification.isread.value == false)
        .isNotEmpty) {
      newalarmList.value = alarmList
          .where((noti) => noti.notification.isread.value == false)
          .toList()
          .obs;
      alarmList = alarmList
          .where((noti) => noti.notification.isread.value == true)
          .toList();
          newalarmList.forEach((element) {element.isnewAlarm.value == true;});
    }
    alarmList.forEach((noti) {
      if (notiDurationCaculate(startDate: noti.notification.date) == 'month') {
        monthalarmList.add(noti);
      } else if (notiDurationCaculate(startDate: noti.notification.date) ==
          'week') {
        weekalarmList.add(noti);
      } else {
        oldalarmList.add(noti);
      }
    });
    print('끝');
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

    if ((_dateOnlyDiffence / 30).floor() < 1) {
      durationResult.value = 'month';
      if (_dateOnlyDiffence <= 7) {
        durationResult.value = 'week';
      }
    } else if ((_dateOnlyDiffence / 30).floor() >= 1) {
      durationResult.value = 'old';
    }

    return durationResult.value;
  }
}
