import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: SliverAppBar(
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
                            borderSide: BorderSide(width: 1.2),
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
                                "팔로우",
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
                  ),
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
                      ],
                    ),
                    releaseIcon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 6,
                        ),
                      ],
                    ),
                    completeIcon: Column(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: mainblue,
                        ),
                      ],
                    ),
                    idleIcon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/loading.png',
                          scale: 12,
                        ),
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
                  child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      key: const PageStorageKey("key1"),
                      slivers: [
                        controller.isalarmEmpty.value
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return Container(
                                    width: Get.width,
                                    height: Get.height * 0.75,
                                    child: Center(
                                      child: Text(
                                        '새로운 알림이 없어요',
                                        style: kSubTitle3Style.copyWith(
                                          color: mainblack.withOpacity(0.38),
                                        ),
                                      ),
                                    ),
                                  );
                                }, childCount: 1),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                return controller.isNotificationloading.value
                                    ? Padding(
                                        padding: EdgeInsets.zero,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Image.asset(
                                              'assets/icons/loading.gif',
                                              scale: 6,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Dismissible(
                                        background: Container(
                                          color: mainpink,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 16),
                                                  child: SvgPicture.asset(
                                                      'assets/icons/Trash.svg'),
                                                )
                                              ]),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          deleteNotification(controller
                                              .alarmlist[index]
                                              .notification
                                              .id);
                                          controller.alarmlist.removeAt(index);
                                          if (controller.alarmlist.isEmpty) {
                                            controller.isalarmEmpty(true);
                                          }
                                        },
                                        child: controller.alarmlist[index],
                                        key: controller.alarmlist[index].key!,
                                      );
                              },
                                    childCount:
                                        controller.isNotificationloading.value
                                            ? 1
                                            : controller.alarmlist.length))
                      ]),
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
                        ],
                      ),
                      releaseIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                        ],
                      ),
                      completeIcon: Column(
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: mainblue,
                          ),
                        ],
                      ),
                      idleIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.png',
                            scale: 12,
                          ),
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
                    child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        key: const PageStorageKey("key2"),
                        slivers: [
                          controller.isfollowreqEmpty.value
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Container(
                                      width: Get.width,
                                      height: Get.height * 0.75,
                                      child: Center(
                                        child: Text(
                                          '아직 팔로우한 학생이 없어요',
                                          style: kSubTitle3Style.copyWith(
                                            color: mainblack.withOpacity(0.38),
                                          ),
                                        ),
                                      ),
                                    );
                                  }, childCount: 1),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                  return controller.isfollowreqloading.value
                                      ? Padding(
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Image.asset(
                                                'assets/icons/loading.gif',
                                                scale: 6,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Dismissible(
                                          background: Container(
                                            color: mainpink,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 16),
                                                    child: SvgPicture.asset(
                                                        'assets/icons/Trash.svg'),
                                                  )
                                                ]),
                                          ),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            deleteNotification(controller
                                                .followalarmlist[index]
                                                .notification
                                                .id);
                                            controller.followalarmlist
                                                .removeAt(index);
                                            if (controller
                                                .followalarmlist.isEmpty) {
                                              controller.isfollowreqEmpty(true);
                                            }
                                          },
                                          child:
                                              controller.followalarmlist[index],
                                          key: controller
                                              .followalarmlist[index].key!,
                                        );
                                },
                                      childCount: controller
                                              .isfollowreqloading.value
                                          ? 1
                                          : controller.followalarmlist.length))
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
