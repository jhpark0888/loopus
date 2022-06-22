import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/comment_model.dart';
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

  late final LikeController likeController = Get.put(
      LikeController(
          isliked: reply.isLiked,
          id: reply.id,
          lastisliked: reply.isLiked.value,
          liketype: Liketype.reply),
      tag: 'reply${reply.id}');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 64, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserImageWidget(
            imageUrl: reply.user.profileImage ?? '',
            width: 35,
            height: 35,
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
                    Text(
                      reply.user.realName,
                      style: k16semiBold,
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
                Text(
                  reply.content,
                  style: k16semiBold.copyWith(
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Obx(
                  () => Row(
                    children: [
                      Text(
                        '좋아요 ${reply.likecount.value}개',
                        style: k16Normal.copyWith(
                          color: maingray,
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

  void tapLike() {
    if (reply.isLiked.value == 0) {
      likeController.isliked(1);
      reply.likecount += 1;
    } else {
      likeController.isliked(0);
      reply.likecount -= 1;
    }
  }
}
