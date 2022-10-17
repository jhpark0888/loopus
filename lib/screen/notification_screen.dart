import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
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
          actions: [
            Center(
                child: Row(children: [
              SvgPicture.asset('assets/icons/appbar_more_option.svg')
            ]))
          ],
        ),
        body: Obx(() => SmartRefresher(
            controller: controller.alarmRefreshController,
            physics: const BouncingScrollPhysics(),
            enablePullDown: (controller.notificationscreenstate.value ==
                    ScreenState.loading)
                ? false
                : true,
            enablePullUp: (controller.notificationscreenstate.value ==
                    ScreenState.loading)
                ? false
                : controller.enablealarmPullup.value,
            header: const MyCustomHeader(),
            footer: const MyCustomFooter(),
            onRefresh: controller.alarmRefresh,
            onLoading: controller.alarmLoading,
            child: controller.notificationscreenstate.value ==
                    ScreenState.loading
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
                : controller.notificationscreenstate.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        controller.followreqRefresh();
                      })
                    : controller.notificationscreenstate.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            controller.followreqRefresh();
                          })
                        : ScrollNoneffectWidget(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (controller.newalarmList.isNotEmpty)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  '새로운 알림',
                                                  style: kmain.copyWith(
                                                      color: maingray),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    bottom: 28, top: 24),
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Dismissible(
                                                    key: controller
                                                        .newalarmList[index]
                                                        .key!,
                                                    child: controller
                                                        .newalarmList[index],
                                                    onDismissed: (direction) {
                                                      deleteNotification(
                                                              controller
                                                                  .newalarmList[
                                                                      index]
                                                                  .notification
                                                                  .id)
                                                          .then((value) {
                                                        if (value.isError ==
                                                            false) {
                                                          controller
                                                              .newalarmList
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    background: Container(
                                                      color: rankred,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          16),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/icons/Trash.svg'),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                                itemCount: controller
                                                    .newalarmList.length,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 24);
                                                },
                                              ),
                                            ]),
                                      if (controller.weekalarmList.isNotEmpty)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  '이번 주',
                                                  style: kmain.copyWith(
                                                      color: maingray),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    bottom: 28, top: 24),
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Dismissible(
                                                    key: controller
                                                        .weekalarmList[index]
                                                        .key!,
                                                    child: controller
                                                        .weekalarmList[index],
                                                    onDismissed: (direction) {
                                                      deleteNotification(
                                                              controller
                                                                  .weekalarmList[
                                                                      index]
                                                                  .notification
                                                                  .id)
                                                          .then((value) {
                                                        if (value.isError ==
                                                            false) {
                                                          controller
                                                              .weekalarmList
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    background: Container(
                                                      color: rankred,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          16),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/icons/Trash.svg'),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                                itemCount: controller
                                                    .weekalarmList.length,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 24);
                                                },
                                              )
                                            ]),
                                      if (controller.monthalarmList.isNotEmpty)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  '이번 달',
                                                  style: kmain.copyWith(
                                                      color: maingray),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    bottom: 28, top: 24),
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Dismissible(
                                                    key: controller
                                                        .monthalarmList[index]
                                                        .key!,
                                                    child: controller
                                                        .monthalarmList[index],
                                                    onDismissed: (direction) {
                                                      deleteNotification(
                                                              controller
                                                                  .monthalarmList[
                                                                      index]
                                                                  .notification
                                                                  .id)
                                                          .then((value) {
                                                        if (value.isError ==
                                                            false) {
                                                          controller
                                                              .monthalarmList
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    background: Container(
                                                      color: rankred,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          16),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/icons/Trash.svg'),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                                itemCount: controller
                                                    .monthalarmList.length,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 24);
                                                },
                                              )
                                            ]),
                                      if (controller.oldalarmList.isNotEmpty)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  '지난 알림',
                                                  style: kmain.copyWith(
                                                      color: maingray),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding: const EdgeInsets.only(
                                                    bottom: 28, top: 24),
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) {
                                                  return Dismissible(
                                                    key: controller
                                                        .oldalarmList[index]
                                                        .key!,
                                                    child: controller
                                                        .oldalarmList[index],
                                                    onDismissed: (direction) {
                                                      deleteNotification(
                                                              controller
                                                                  .oldalarmList[
                                                                      index]
                                                                  .notification
                                                                  .id)
                                                          .then((value) {
                                                        if (value.isError ==
                                                            false) {
                                                          controller
                                                              .oldalarmList
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    background: Container(
                                                      color: rankred,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          16),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/icons/Trash.svg'),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                                itemCount: controller
                                                    .oldalarmList.length,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 24);
                                                },
                                              )
                                            ]),
                                    ]),
                              ),
                            ),
                          )
            // CustomScrollView(
            //     physics: const BouncingScrollPhysics(),
            // key: const PageStorageKey("key2"),
            // slivers: [
            //   controller.isfollowreqEmpty.value
            //       ? SliverList(
            //           delegate: SliverChildBuilderDelegate(
            //               (context, index) {
            //             return Container(
            //               width: Get.width,
            //               height: Get.height * 0.75,
            //               child: Center(
            //                 child: Text(
            //                   '아직 팔로우한 학생이 없어요',
            //                   style: kSubTitle3Style.copyWith(
            //                     color: mainblack.withOpacity(0.38),
            //                   ),
            //                 ),
            //               ),
            //             );
            //           }, childCount: 1),
            //         )
            //       : Obx(
            //           () => SliverList(
            //               delegate: SliverChildBuilderDelegate(
            //                   (context, index) {
            //             return controller
            //                         .followreqscreenstate.value ==
            //                     ScreenState.loading
            //                 ? Padding(
            //                     padding: EdgeInsets.zero,
            //                     child: Column(
            //                       children: [
            //                         SizedBox(
            //                           height: 20,
            //                         ),
            //                         Image.asset(
            //                           'assets/icons/loading.gif',
            //                           scale: 6,
            //                         ),
            //                       ],
            //                     ),
            //                   )
            //                 : controller.followreqscreenstate
            //                             .value ==
            //                         ScreenState.disconnect
            //                     ? DisconnectReloadWidget(
            //                         reload: () {
            //                         controller.followreqRefresh();
            //                       })
            //                     : controller.followreqscreenstate
            //                                 .value ==
            //                             ScreenState.disconnect
            //                         ? ErrorReloadWidget(reload: () {
            //                             controller
            //                                 .followreqRefresh();
            //                           })
            //                         : Dismissible(
            //                             background: Container(
            //                               color: rankred,
            //                               child: Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .end,
            //                                   children: [
            //                                     Padding(
            //                                       padding: EdgeInsets
            //                                           .only(
            //                                               right:
            //                                                   16),
            //                                       child: SvgPicture
            //                                           .asset(
            //                                               'assets/icons/Trash.svg'),
            //                                     )
            //                                   ]),
            //                             ),
            //                             direction: DismissDirection
            //                                 .endToStart,
            //                             onDismissed: (direction) {
            //                               deleteNotification(
            //                                   controller
            //                                       .followalarmlist[
            //                                           index]
            //                                       .notification
            //                                       .id);
            //                               controller.followalarmlist
            //                                   .removeAt(index);
            //                               if (controller
            //                                   .followalarmlist
            //                                   .isEmpty) {
            //                                 controller
            //                                     .isfollowreqEmpty(
            //                                         true);
            //                               }
            //                             },
            //                             child: controller
            //                                 .followalarmlist[index],
            //                             key: controller
            //                                 .followalarmlist[index]
            //                                 .key!,
            //                           );
            //           },
            //                   childCount: controller
            //                               .followreqscreenstate
            //                               .value ==
            //                           ScreenState.success
            //                       ? controller
            //                           .followalarmlist.length
            //                       : 1)),
            //         )
            // ]),
            // )),
            //   ],
            // ),
            //   ),
            // ),
            )));
  }
}
