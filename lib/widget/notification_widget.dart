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
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:loopus/trash_bin/question_detail_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
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

  @override
  Widget build(BuildContext context) {
    return notification.type == NotificationType.follow
        ? GestureDetector(
            onTap: () {
              clickprofile(notification.type);
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
                  SlidableAction(spacing: 0,
                    flex: 1,
                    onPressed: (context) {
                      deleteNotification(notification.id).then((value) {
                  if (value.isError == false) {
                    NotificationDetailController.to.removeNoti(notification);
                    showCustomDialog('알림이 삭제되었어요.', 1400);
                  }
                });
                    },
                    label: '삭제',
                    backgroundColor: rankred,
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
                            text: notification.user.name, style: kmainbold),
                        TextSpan(
                          text: "님이 회원님을 팔로우합니다.",
                          style:
                              kmainheight.copyWith(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              ' · ${alarmDurationCaculate(startDate: notification.date)}',
                          style: kmainheight.copyWith(
                            color: maingray,
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
                    //           ? "팔로우하기"
                    //           : "팔로잉 중",
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
                    NotificationDetailController.to.removeNoti(notification);
                    showCustomDialog('알림이 삭제되었어요.', 1400);
                  }
                });
                    },
                    label: '삭제',
                    backgroundColor: rankred,
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
                        clickprofile(notification.type);
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
                                clickprofile(notification.type);
                              },
                            text: notification.user.name,
                            style: kmainbold),
                        TextSpan(
                          text: "님이 ",
                          style:
                              kmainheight.copyWith(fontWeight: FontWeight.w400),
                        ),
                        // TextSpan(
                        //     text: notification.content,
                        //     style: kSubTitle1Style),
                        TextSpan(
                          text: notification.type == NotificationType.careerTag
                              ? " '${notification.contents!.content}' 커리어에 회원님을 초대했습니다."
                              : notification.type == NotificationType.postLike
                                  ? '회원님의 포스트를 좋아합니다.'
                                  : notification.type ==
                                          NotificationType.commentLike
                                      ? '회원님의 댓글을 좋아합니다.'
                                      : notification.type ==
                                              NotificationType.reply
                                          ? '회원님의 답변을 좋아합니다.'
                                          : notification.type ==
                                                  NotificationType.comment
                                              ? "회원님의 포스트에 댓글을 남겼습니다."
                                              : "회원님의 댓글에 답변을 남겼습니다.",
                          style:
                              kmainheight.copyWith(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                            text: ' · ${commentCalculateDate(
                              notification.date,
                            )}',
                            style: kmainheight.copyWith(color: maingray))
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

  void clickprofile(NotificationType type) async {
    if (type == NotificationType.follow) {
      Get.to(() => OtherProfileScreen(
          userid: notification.targetId, realname: notification.user.name));
    } else {
      Get.to(() => OtherProfileScreen(
          userid: notification.user.userId, realname: notification.user.name));
    }
  }

  void clicknotice() async {
    if (notification.type == NotificationType.careerTag) {
      late Project career;
      loading();
      getproject(notification.targetId, notification.userId).then((value) {
        if (value.isError == false) {
          Get.back();
          career = value.data;
          Future.delayed(const Duration(milliseconds: 300));
          Get.to(() => GroupCareerDetailScreen(
              career: career, name: (notification.user.name)));
        }
      });
    } else if (notification.type == NotificationType.postLike) {
      Get.to(
          () => PostingScreen(
                post: null,
                postid: notification.targetId,
                // likecount: 0.obs,
                // isLiked: 0.obs,
              ),
          opaque: false);
    } else if (notification.type == NotificationType.follow) {
      Get.to(() => OtherProfileScreen(
          userid: notification.targetId, realname: notification.user.name));
    } else if (notification.type.name.contains('reply')) {
      //다른 화면으로 이동함
      //서버에서 잘못 주는 듯
      Get.to(() => PostingScreen(
            postid: notification.contents!.postId,
            post: null,
          ));
    } else if (notification.type.name.contains('comment')) {
      Get.to(() => PostingScreen(postid: notification.targetId));
    }

    if (notification.isread.value == false) {
      notification.isread.value = true;
      isRead(
        notification.targetId,
        notification.type,
        notification.user.userId,
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
      durationResult.value = '${((_dateOnlyDiffence / 7)).floor().toString()}주';
    } else if (_dateOnlyDiffence == 0) {
      durationResult.value = '오늘';
    } else if (_dateOnlyDiffence <= 30) {
      durationResult.value = '$_dateOnlyDiffence일';
    }

    return durationResult.value;
  }

  void checkNewAlarmCount() {
    if (isnewAlarm.value == true) {}
  }
}
