import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  NotificationDetailController controller =
      Get.put(NotificationDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '알림',
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 43,
                toolbarHeight: 43,
                elevation: 0,
                flexibleSpace: Column(
                  children: [
                    TabBar(
                      labelStyle: kButtonStyle,
                      labelColor: mainblack,
                      unselectedLabelStyle: kBody1Style,
                      unselectedLabelColor: mainblack.withOpacity(0.6),
                      indicator: const UnderlineIndicator(
                        strokeCap: StrokeCap.round,
                        borderSide: BorderSide(width: 2),
                      ),
                      indicatorColor: mainblack,
                      tabs: const [
                        Tab(
                          height: 40,
                          child: Text(
                            "알림",
                          ),
                        ),
                        Tab(
                          height: 40,
                          child: Text(
                            "루프 요청",
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xffe7e7e7),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              Obx(
                () => SmartRefresher(
                  controller: controller.alarmRefreshController,
                  enablePullDown:
                      (controller.isNotificationloading.value == true)
                          ? false
                          : true,
                  enablePullUp: (controller.isNotificationloading.value == true)
                      ? false
                      : controller.enablealarmPullup.value,
                  header: ClassicHeader(
                    spacing: 0.0,
                    height: 60,
                    completeDuration: Duration(milliseconds: 600),
                    textStyle: TextStyle(color: mainblack),
                    refreshingText: '',
                    releaseText: "",
                    completeText: "",
                    idleText: "",
                    refreshingIcon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 6,
                        ),
                        // SizedBox(
                        //   height: 4,
                        // ),
                        // Text(
                        //   '새로운 포스팅 받는 중...',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //     color: mainblue.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                    releaseIcon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 6,
                        ),
                        // SizedBox(
                        //   height: 4,
                        // ),
                        // Text(
                        //   '새로운 포스팅 받는 중...',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //     color: mainblue.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                    completeIcon: Column(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: mainblue,
                        ),
                        // const SizedBox(
                        //   height: 4,
                        // ),
                        // Text(
                        //   '완료!',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //     color: mainblue.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                    idleIcon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/loading.png',
                          scale: 12,
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // Text(
                        //   '당겨주세요',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //     color: mainblue.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  footer: ClassicFooter(
                    completeDuration: Duration.zero,
                    loadingText: "",
                    canLoadingText: "",
                    idleText: "",
                    idleIcon: Container(),
                    noMoreIcon: Container(
                      child: Text('as'),
                    ),
                    loadingIcon: Image.asset(
                      'assets/icons/loading.gif',
                      scale: 6,
                    ),
                    canLoadingIcon: Image.asset(
                      'assets/icons/loading.gif',
                      scale: 6,
                    ),
                  ),
                  onRefresh: controller.alarmRefresh,
                  onLoading: controller.alarmLoading,
                  child: Obx(
                    () => controller.isalarmEmpty.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    '알람이 없습니다',
                                    style: kSubTitle2Style.copyWith(
                                      color: mainblack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.alarmlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget item = controller.alarmlist[index];
                              return Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: Row(children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Icon(Icons.delete),
                                    )
                                  ]),
                                ),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction) {
                                  deleteNotification(controller
                                      .alarmlist[index].notification.id);
                                  controller.alarmlist.removeAt(index);
                                  if (controller.alarmlist.isEmpty) {
                                    controller.isalarmEmpty(true);
                                  }
                                },
                                child: item,
                                key: item.key!,
                              );
                            }),
                  ),
                ),
              ),
              Obx(() => SmartRefresher(
                    controller: controller.followreqRefreshController,
                    enablePullDown:
                        (controller.isfollowreqloading.value == true)
                            ? false
                            : true,
                    enablePullUp: (controller.isfollowreqloading.value == true)
                        ? false
                        : controller.enablefollowreqPullup.value,
                    header: ClassicHeader(
                      spacing: 0.0,
                      height: 60,
                      completeDuration: Duration(milliseconds: 600),
                      textStyle: TextStyle(color: mainblack),
                      refreshingText: '',
                      releaseText: "",
                      completeText: "",
                      idleText: "",
                      refreshingIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   '새로운 포스팅 받는 중...',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.bold,
                          //     color: mainblue.withOpacity(0.6),
                          //   ),
                          // ),
                        ],
                      ),
                      releaseIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   '새로운 포스팅 받는 중...',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.bold,
                          //     color: mainblue.withOpacity(0.6),
                          //   ),
                          // ),
                        ],
                      ),
                      completeIcon: Column(
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: mainblue,
                          ),
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   '완료!',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.bold,
                          //     color: mainblue.withOpacity(0.6),
                          //   ),
                          // ),
                        ],
                      ),
                      idleIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.png',
                            scale: 12,
                          ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // Text(
                          //   '당겨주세요',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.bold,
                          //     color: mainblue.withOpacity(0.6),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    footer: ClassicFooter(
                      completeDuration: Duration.zero,
                      loadingText: "",
                      canLoadingText: "",
                      idleText: "",
                      idleIcon: Container(),
                      noMoreIcon: Container(
                        child: Text('as'),
                      ),
                      loadingIcon: Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                      canLoadingIcon: Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                    ),
                    onRefresh: controller.followreqRefresh,
                    onLoading: controller.followreqLoading,
                    child: Obx(
                      () => controller.isfollowreqEmpty.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      '루프요청이 없습니다',
                                      style: kSubTitle2Style.copyWith(
                                        color: mainblack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.followalarmlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                Widget item = controller.followalarmlist[index];
                                return Dismissible(
                                  background: Container(
                                    color: Colors.red,
                                    child: Row(children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Icon(Icons.delete),
                                      )
                                    ]),
                                  ),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (direction) {
                                    deleteNotification(controller
                                        .followalarmlist[index]
                                        .notification
                                        .id);
                                    controller.followalarmlist.removeAt(index);
                                    if (controller.followalarmlist.isEmpty) {
                                      controller.isfollowreqEmpty(true);
                                    }
                                  },
                                  child: item,
                                  key: item.key!,
                                );
                              }),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
