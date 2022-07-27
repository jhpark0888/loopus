import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/follow_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:loopus/trash_bin/question_detail_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  NotificationModel notification;
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  UserImageWidget(
                    imageUrl: notification.user.profileImage ?? '',
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: notification.user.realName, style: kmainbold),
                      TextSpan(
                        text: "님이 회원님을 팔로우합니다.",
                        style: kSubTitle1Style.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text:
                            ' · ${alarmDurationCaculate(startDate: notification.date)}',
                        style: kSubTitle1Style.copyWith(
                          color: mainblack.withOpacity(0.38),
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
          )
        : GestureDetector(
            onTap: clicknotice,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      clickprofile(notification.type);
                    },
                    child: UserImageWidget(
                      imageUrl: notification.user.profileImage ?? '',
                      width: 36,
                      height: 36,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  clickprofile(notification.type);
                                },
                              text: notification.user.realName,
                              style: kSubTitle1Style),
                          TextSpan(
                            text: "님이 ",
                            style: kSubTitle1Style.copyWith(
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                              text: notification.content,
                              style: kSubTitle1Style),
                          TextSpan(
                            text: notification.type == NotificationType.question
                                ? " 질문에 답변을 남겼어요 "
                                : notification.type == NotificationType.tag
                                    ? " 활동에 회원님을 태그했어요 "
                                    : " 포스팅에 좋아요를 남겼어요 ",
                            style: kSubTitle1Style.copyWith(
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                              text: ' · ${alarmDurationCaculate(
                                  startDate: notification.date,
                                  )}',
                              style: kSubTitle3Style.copyWith(
                                  color: mainblack.withOpacity(0.38)))
                        ])),
                  ),
                ],
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
          userid: notification.targetId, realname: notification.user.realName));
    } else {
      Get.to(() => OtherProfileScreen(
          userid: notification.user.userid,
          realname: notification.user.realName));
    }
  }

  void clicknotice() {
    if (notification.type == NotificationType.tag) {
      // Get.to(() => ProjectScreen(projectid: notification.targetId, isuser: 0));
    } else if (notification.type == NotificationType.like) {
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
          userid: notification.targetId, realname: notification.user.realName));
    }

    if (notification.isread.value == false) {
      print('실행되었다.');

      isRead(
        notification.targetId,
        notification.type,
        notification.user.userid,
      );
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
    }
    else if (_dateOnlyDiffence == 0) {
      durationResult.value = '오늘';
    }
    else if (_dateOnlyDiffence <= 30) {
      durationResult.value = '$_dateOnlyDiffence일';
    }
  

  return durationResult.value;
}
}
