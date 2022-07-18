import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/user_image_widget.dart';

class ReplyWidget extends StatelessWidget {
  ReplyWidget({
    Key? key,
    required this.reply,
    required this.postid,
  }) : super(key: key);

  Reply reply;
  int postid;

  late final PostingDetailController postController =
      Get.find(tag: postid.toString());

  final Debouncer _debouncer = Debouncer();

  late int lastIsLiked;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 64, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: tapProfile,
            child: UserImageWidget(
              imageUrl: reply.user.profileImage ?? '',
              width: 35,
              height: 35,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: tapProfile,
                      child: Text(
                        reply.user.realName,
                        style: kmainbold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      calculateDate(reply.date),
                      style: k16Normal.copyWith(color: maingray),
                    )
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(
                            () => OtherProfileScreen(
                                user: reply.taggedUser,
                                userid: reply.taggedUser.userid,
                                realname: reply.taggedUser.realName),
                            preventDuplicates: false);
                      },
                    text: reply.taggedUser.realName,
                    style: kmainbold.copyWith(
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: reply.content,
                    style: kmainbold.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ])),
                const SizedBox(
                  height: 7,
                ),
                Obx(
                  () => Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.to(() => LikePeopleScreen(
                                id: reply.id,
                                likeType: LikeType.cocomment,
                              ));
                        },
                        child: Text(
                          '좋아요 ${reply.likecount.value}개',
                          style: k16Normal.copyWith(
                            color: maingray,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        onTap: tapLike,
                        child: reply.isLiked.value == 0
                            ? SvgPicture.asset(
                                "assets/icons/Favorite_Inactive.svg")
                            : SvgPicture.asset(
                                "assets/icons/Favorite_Active.svg"),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        onTap: () async {
                          postController.commentFocus.requestFocus();
                          postController.commentController.text = '\u200B ';
                          postController.commentController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: postController
                                      .commentController.text.length));
                          postController.selectedCommentId(reply.commentId);
                          postController.tagUser(reply.user);

                          await Future.delayed(
                              const Duration(milliseconds: 600));
                          Scrollable.ensureVisible(context,
                              alignment: 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease);
                        },
                        child: SvgPicture.asset("assets/icons/Reply_Arrow.svg"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: reply.user,
            userid: reply.user.userid,
            realname: reply.user.realName),
        preventDuplicates: false);
  }

  void tapLike() {
    if (num == 0) {
      lastIsLiked = reply.isLiked.value;
    }
    if (reply.isLiked.value == 0) {
      reply.isLiked(1);
      reply.likecount += 1;
    } else {
      reply.isLiked(0);
      reply.likecount -= 1;
    }

    num += 1;

    _debouncer.run(() {
      if (lastIsLiked != reply.isLiked.value) {
        likepost(reply.id, LikeType.cocomment);
        lastIsLiked = reply.isLiked.value;
        num = 0;
      }
    });
  }
}
