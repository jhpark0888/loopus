import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/follow_people_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/user_image_widget.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget(
      {Key? key, required this.notification, required this.isnewAlarm})
      : super(key: key);

  NotificationModel notification;
  RxBool isnewAlarm;
  // late final FollowController followController = Get.put(
  //     FollowController(
  //         islooped: notification.looped!.value == FollowState.normal
  //             ? 0.obs
  //             : notification.looped!.value == FollowState.follower
  //                 ? 0.obs
  //                 : notification.looped!.value == FollowState.following
  //                     ? 1.obs
  //                     : 1.obs,
  //         id: notification.targetId,
  //         lastislooped: notification.looped!.value == FollowState.normal
  //             ? 0
  //             : notification.looped!.value == FollowState.follower
  //                 ? 0
  //                 : notification.looped!.value == FollowState.following
  //                     ? 1
  //                     : 1),
  //     tag: notification.targetId.toString());

  String notiText() {
    switch (notification.type) {
      case NotificationType.follow:
        return "?????? ???????????? ??????????????????.";
      case NotificationType.careerTag:
        return " '${notification.contents}' ???????????? ???????????? ??????????????????.";
      case NotificationType.postLike:
        return "???????????? ???????????? ???????????????.";
      case NotificationType.commentLike:
        return "???????????? ????????? ???????????????.";
      case NotificationType.replyLike:
        return "???????????? ????????? ???????????????.";
      case NotificationType.comment:
        return "???????????? ???????????? ????????? ???????????????.";
      case NotificationType.reply:
        return "???????????? ????????? ????????? ???????????????.";
      case NotificationType.schoolNoti:
        return "'${notification.contents}'??? ????????? ????????? ????????????.";
      case NotificationType.rankUpdate:
        return "????????? ????????? ???????????? ???????????????.";
      case NotificationType.groupCareerPost:
        return " '${notification.contents}' ???????????? ????????? ???????????? ??????????????????.";
      case NotificationType.empty1:
      case NotificationType.empty2:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return notification.type == NotificationType.follow
        ? GestureDetector(
            onTap: () {
              clicknotice();
            },
            child: Slidable(
              key: ValueKey(notification.id.toString()),
              closeOnScroll: true,
              groupTag: '1',
              endActionPane: ActionPane(
                extentRatio: 0.20,
                motion: const ScrollMotion(),
                children: [
                  // SlidableAction(onPressed: (c){},label: '',),
                  // SlidableAction(onPressed: (c){},label: '',),
                  SlidableAction(
                    spacing: 0,
                    flex: 1,
                    onPressed: (context) {
                      deleteNotification(notification.id).then((value) {
                        if (value.isError == false) {
                          NotificationDetailController.to
                              .removeNoti(notification);
                          showCustomDialog('????????? ??????????????????.', 1400);
                        }
                      });
                    },
                    label: '??????',
                    backgroundColor: AppColors.rankred,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    UserImageWidget(
                      imageUrl: notification.user.profileImage,
                      width: 36,
                      height: 36,
                      userType: notification.user.userType,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: notification.user.name,
                            style: MyTextTheme.mainbold(context)),
                        TextSpan(
                          text: notiText(),
                          style: MyTextTheme.mainheight(context)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              ' ?? ${alarmDurationCaculate(startDate: notification.date)}',
                          style: MyTextTheme.mainheight(context).copyWith(
                            color: AppColors.maingray,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ])),
                    ),
                    // const SizedBox(
                    //   width: 12,
                    // ),
                    // Obx(() => CustomExpandedButton(
                    //       onTap: followMotion,
                    //       title: followController.islooped.value == 0
                    //           ? "???????????????"
                    //           : "????????? ???",
                    //       isBlue:
                    //           followController.islooped.value == 0 ? true : false,
                    //       isBig: false,
                    //       buttonTag: notification.targetId.toString(),
                    //     ))
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: clicknotice,
            child: Slidable(
              key: ValueKey(notification.id.toString()),
              closeOnScroll: true,
              groupTag: '1',
              endActionPane: ActionPane(
                extentRatio: 0.20,
                motion: const ScrollMotion(),
                children: [
                  // SlidableAction(onPressed: (c){},label: '',),
                  // SlidableAction(onPressed: (c){},label: '',),
                  SlidableAction(
                    flex: 1,
                    onPressed: (context) {
                      deleteNotification(notification.id).then((value) {
                        if (value.isError == false) {
                          NotificationDetailController.to
                              .removeNoti(notification);
                          showCustomDialog('????????? ??????????????????.', 1400);
                        }
                      });
                    },
                    label: '??????',
                    backgroundColor: AppColors.rankred,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        clickprofile();
                      },
                      child: UserImageWidget(
                        imageUrl: notification.user.profileImage,
                        width: 36,
                        height: 36,
                        userType: notification.user.userType,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                clickprofile();
                              },
                            text: notification.user.name,
                            style: MyTextTheme.mainbold(context)),
                        TextSpan(
                          text: notification.type != NotificationType.schoolNoti
                              ? "?????? "
                              : "?????? ",
                          style: MyTextTheme.mainheight(context)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        // TextSpan(
                        //     text: notification.content,
                        //     style: kSubTitle1Style),
                        TextSpan(
                          text: notiText(),
                          style: MyTextTheme.mainheight(context)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                            text: ' ?? ${alarmDurationCaculate(
                              startDate: notification.date,
                            )}',
                            style: MyTextTheme.mainheight(context)
                                .copyWith(color: AppColors.maingray))
                      ])),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void followMotion() {
    // if (notification.looped!.value == FollowState.normal) {
    //   followController.islooped(1);
    //   notification.looped!(FollowState.following);
    // } else if (notification.looped!.value == FollowState.follower) {
    //   followController.islooped(1);

    //   notification.looped!(FollowState.wefollow);

    //   // ProfileController.to.myUserInfo
    //   //         .value.loopcount -
    //   //     1;

    // } else if (notification.looped!.value == FollowState.following) {
    //   followController.islooped(0);

    //   notification.looped!(FollowState.normal);
    // } else if (notification.looped!.value == FollowState.wefollow) {
    //   followController.islooped(0);

    //   notification.looped!(FollowState.follower);
    // }
  }

  void clickprofile() async {
    if (notification.user.userType == UserType.student) {
      Get.to(
          () => OtherProfileScreen(
              userid: notification.user.userId,
              realname: notification.user.name),
          preventDuplicates: false);
    } else {
      Get.to(
          () => OtherCompanyScreen(
              companyId: notification.user.userId,
              companyName: notification.user.name),
          preventDuplicates: false);
    }
  }

  void clicknotice() async {
    if (notification.type == NotificationType.careerTag) {
      late Project career;
      loading();
      getproject(notification.targetId, notification.userId).then((value) {
        if (value.isError == false) {
          Get.back();
          career = Project.fromJson(value.data);
          Future.delayed(const Duration(milliseconds: 300));
          Get.to(
              () => GroupCareerDetailScreen(
                    career: career,
                    name: (notification.user.name),
                  ),
              preventDuplicates: false);
        } else {
          errorSituation(value);
        }
      });
    } else if (notification.type == NotificationType.postLike ||
        notification.type == NotificationType.commentLike ||
        notification.type == NotificationType.replyLike ||
        notification.type == NotificationType.comment ||
        notification.type == NotificationType.reply ||
        notification.type == NotificationType.groupCareerPost ||
        notification.type == NotificationType.schoolNoti) {
      Get.to(
        () => PostingScreen(
          post: null,
          postid: notification.targetId,
          // likecount: 0.obs,
          // isLiked: 0.obs,
        ),
        preventDuplicates: false,
      );
    } else if (notification.type == NotificationType.follow) {
      if (notification.user.userType == UserType.student) {
        Get.to(
            () => OtherProfileScreen(
                userid: notification.targetId,
                realname: notification.user.name),
            preventDuplicates: false);
      } else {
        Get.to(
            () => OtherCompanyScreen(
                companyId: notification.user.userId,
                companyName: notification.user.name),
            preventDuplicates: false);
      }
    }

    if (notification.isread.value == false) {
      notification.isread.value = true;
      if (NotificationDetailController.to.newalarmList
          .any((noti) => noti.id == notification.id)) {
        NotificationModel readNoti = NotificationDetailController
            .to.newalarmList
            .firstWhere((noti) => noti.id == notification.id);

        NotificationDetailController.to.newalarmList.remove(readNoti);
        NotificationDetailController.to.weekalarmList.insert(0, readNoti);
      }
      isNotiRead(
        notification.id,
      ).then((value) {
        if (value.isError == false) {
          if (NotificationDetailController.to.newalarmList
              .where((noti) => noti.isread.value == false)
              .isEmpty) {
            HomeController.to.isNewAlarm.value = false;
          }
          print(NotificationDetailController.to.newalarmList
              .where((noti) => noti.isread.value == false)
              .isEmpty);
          print(NotificationDetailController.to.newalarmList
              .where((noti) => noti.isread.value == false));
        }
      });
    }
  }

  String alarmDurationCaculate({
    required DateTime startDate,
  }) {
    RxString durationResult = ''.obs;
    DateTime endDate = DateTime.now();
    DateFormat dateonlyFormat = DateFormat('yyyy-MM-dd');
    DateTime startDateOnlyDay =
        DateTime.parse(dateonlyFormat.format(startDate));
    DateTime endDateOnlyDay = DateTime.parse(dateonlyFormat.format(endDate));
    int _dateDiffence = (endDate.difference(startDate).inDays).toInt();
    int _dateOnlyDiffence =
        (endDateOnlyDay.difference(startDateOnlyDay).inDays).toInt();
    if ((_dateOnlyDiffence / 30).floor() > 0) {
      durationResult.value = '${((_dateOnlyDiffence / 7)).floor().toString()}???';
    } else if (_dateOnlyDiffence == 0) {
      durationResult.value = '??????';
    } else if (_dateOnlyDiffence <= 30) {
      durationResult.value = '$_dateOnlyDiffence???';
    }

    return durationResult.value;
  }

  void checkNewAlarmCount() {
    if (isnewAlarm.value == true) {}
  }
}
