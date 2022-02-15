import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/blue_button.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return notification.type == NotificationType.follow
        ? GestureDetector(
            onTap: () {
              Get.to(() => OtherProfileScreen(
                  userid: notification.targetId,
                  isuser: 0,
                  realname: notification.user.realName));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  ClipOval(
                      child: notification.user.profileImage == null
                          ? Image.asset(
                              "assets/illustrations/default_profile.png",
                              width: 56,
                              height: 56,
                            )
                          : CachedNetworkImage(
                              height: 56,
                              width: 56,
                              imageUrl: notification.user.profileImage!,
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: const Color(0xffe7e7e7),
                                child: Container(),
                              ),
                              fit: BoxFit.cover,
                            )),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(children: [
                          TextSpan(
                              text: notification.user.realName,
                              style: kSubTitle2Style),
                          TextSpan(text: "님이 ", style: kSubTitle3Style),
                          TextSpan(text: "루프를 요청했어요 ", style: kSubTitle2Style),
                          TextSpan(
                              text: DurationCaculator().messagedurationCaculate(
                                  startDate: notification.date,
                                  endDate: DateTime.now()),
                              style: kSubTitle2Style.copyWith(
                                  color: mainblack.withOpacity(0.38)))
                        ])),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  BlueTextButton(onTap: () {}, text: "루프 맺기", hoverTag: "팔로우")
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              if (notification.type == NotificationType.question) {
                Get.to(() => QuestionDetailScreen(
                    questionid: notification.targetId,
                    isuser: 1,
                    realname: notification.user.realName));
              } else if (notification.type == NotificationType.tag) {
                Get.to(() =>
                    ProjectScreen(projectid: notification.targetId, isuser: 0));
              } else if (notification.type == NotificationType.like) {
                Get.to(() => PostingScreen(
                    userid: ProfileController.to.myUserInfo.value.userid,
                    isuser: 1,
                    postid: notification.targetId,
                    title: notification.content!,
                    realName: ProfileController.to.myUserInfo.value.realName,
                    department:
                        ProfileController.to.myUserInfo.value.department,
                    postDate: DateTime.now(),
                    profileImage:
                        ProfileController.to.myUserInfo.value.profileImage,
                    thumbNail: null,
                    likecount: 0.obs,
                    isLiked: 0.obs,
                    isMarked: 0.obs));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  ClipOval(
                      child: notification.user.profileImage == null
                          ? Image.asset(
                              "assets/illustrations/default_profile.png",
                              width: 56,
                              height: 56,
                            )
                          : CachedNetworkImage(
                              height: 56,
                              width: 56,
                              imageUrl: notification.user.profileImage!,
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: const Color(0xffe7e7e7),
                                child: Container(),
                              ),
                              fit: BoxFit.cover,
                            )),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: RichText(
                        maxLines: 2,
                        text: TextSpan(children: [
                          TextSpan(
                              text: notification.user.realName,
                              style: kSubTitle2Style),
                          TextSpan(text: "님이 ", style: kSubTitle3Style),
                          TextSpan(
                              text: notification.content,
                              style: kSubTitle2Style),
                          TextSpan(
                              text: notification.type ==
                                      NotificationType.question
                                  ? " 질문에 답글을 남겼어요 "
                                  : notification.type == NotificationType.tag
                                      ? " 활동에 당신을 태그했어요 "
                                      : " 포스팅에 좋아요를 남겼어요 ",
                              style: kSubTitle3Style),
                          TextSpan(
                              text: DurationCaculator().messagedurationCaculate(
                                  startDate: notification.date,
                                  endDate: DateTime.now()),
                              style: kSubTitle2Style.copyWith(
                                  color: mainblack.withOpacity(0.38)))
                        ])),
                  ),
                ],
              ),
            ),
          );
  }
}
