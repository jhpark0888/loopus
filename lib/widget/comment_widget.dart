import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/reply_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({
    Key? key,
    required this.comment,
    required this.postid,
  }) : super(key: key);

  Comment comment;
  int postid;

  late final PostingDetailController postController =
      Get.find(tag: postid.toString());

  late final LikeController likeController = Get.put(
      LikeController(
          isliked: comment.isLiked,
          id: comment.id,
          lastisliked: comment.isLiked.value,
          liketype: Liketype.comment),
      tag: 'comment${comment.id}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserImageWidget(
                imageUrl: comment.user.profileImage ?? '',
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
                          comment.user.realName,
                          style: k16semiBold,
                        ),
                        const Spacer(),
                        Text(
                          calculateDate(comment.date),
                          style: k16Normal.copyWith(color: maingray),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      comment.content,
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
                            '좋아요 ${comment.likecount.value}개',
                            style: k16Normal.copyWith(
                              color: maingray,
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: tapLike,
                            child: comment.isLiked.value == 0
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
                              postController.selectedCommentId(comment.id);
                              postController.tagUser(comment.user);

                              await Future.delayed(
                                  const Duration(milliseconds: 600));
                              Scrollable.ensureVisible(context,
                                  alignment: 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                            child: SvgPicture.asset(
                                "assets/icons/Reply_Arrow.svg"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // if (comment.replyList.isNotEmpty)
        //   const SizedBox(
        //     height: 14,
        //   ),
        // Obx(
        //   () => ListView.separated(
        //     primary: false,
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       return ReplyWidget(
        //         postid: postid,
        //         reply: comment.replyList[index],
        //       );
        //     },
        //     separatorBuilder: (context, index) {
        //       return const SizedBox(
        //         height: 14,
        //       );
        //     },
        //     itemCount: comment.replyList.length,
        //   ),
        // )
      ],
    );
  }

  void tapLike() {
    if (comment.isLiked.value == 0) {
      likeController.isliked(1);
      comment.likecount += 1;
    } else {
      likeController.isliked(0);
      comment.likecount -= 1;
    }
  }
}
