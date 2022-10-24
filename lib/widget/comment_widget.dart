import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
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

  final Debouncer _debouncer = Debouncer();

  late int lastIsLiked;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () => tapLike(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: tapProfile,
              child: UserImageWidget(
                imageUrl: comment.user.profileImage,
                width: 36,
                height: 36,
                userType: comment.user.userType,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: tapProfile,
                        child: Text(
                          comment.user.name,
                          style: kmainbold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: comment.user.userId ==
                                HomeController.to.myProfile.value.userId
                            ? () {
                                showModalIOS(
                                  context,
                                  func1: () {
                                    showButtonDialog(
                                        leftText: '취소',
                                        rightText: '삭제',
                                        title: '댓글을 삭제하시겠어요?',
                                        startContent: '삭제한 댓글은 복구할 수 없어요',
                                        leftFunction: () => Get.back(),
                                        rightFunction: () async {
                                          dialogBack(modalIOS: true);

                                          await commentDelete(comment.id,
                                                  contentType.comment)
                                              .then((value) {
                                            if (value.isError == false) {
                                              postController
                                                  .post!.value.comments
                                                  .removeWhere((element) =>
                                                      element.id == comment.id);
                                            } else {
                                              showCustomDialog(
                                                  "댓글 삭제에 실패하였습니다", 1000);
                                            }
                                          });
                                        });
                                  },
                                  func2: () {},
                                  value1: '댓글 삭제하기',
                                  value2: '',
                                  isValue1Red: true,
                                  isValue2Red: false,
                                  isOne: true,
                                );
                              }
                            : () {
                                showModalIOS(
                                  context,
                                  func1: () {
                                    showButtonDialog(
                                        leftText: '취소',
                                        rightText: '신고',
                                        title: '정말 댓글을 신고하시겠어요?',
                                        startContent: '관리자가 검토 절차를 거칩니다',
                                        leftFunction: () => Get.back(),
                                        rightFunction: () {
                                          contentreport(comment.id,
                                                  contentType.comment)
                                              .then((value) {
                                            if (value.isError == false) {
                                              getbacks(2);
                                              showCustomDialog(
                                                  "신고가 접수되었습니다", 1000);
                                            } else {
                                              errorSituation(value);
                                            }
                                          });
                                        });
                                  },
                                  func2: () {},
                                  value1: '이 댓글 신고하기',
                                  value2: '',
                                  isValue1Red: true,
                                  isValue2Red: false,
                                  isOne: true,
                                );
                              },
                        behavior: HitTestBehavior.translucent,
                        child: SizedBox(
                            height: 16,
                            child: SvgPicture.asset(
                                'assets/icons/more_option.svg')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comment.content,
                    style: kmainheight,
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          commentCalculateDate(comment.date),
                          style: kmain.copyWith(color: maingray),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => LikePeopleScreen(
                                  id: comment.id,
                                  likeType: contentType.comment,
                                ));
                          },
                          child: Text(
                            '좋아요 ${comment.likecount.value}개',
                            style: kmain.copyWith(
                              color: maingray,
                            ),
                          ),
                          //  comment.likecount.value > 0
                          //     ? Text(
                          //         '좋아요 ${comment.likecount.value}개',
                          //         style: kmain.copyWith(
                          //           fontSize: 12,
                          //           color: maingray,
                          //         ),
                          //       )
                          //     : Text(
                          //         '좋아요',
                          //         style: kmain.copyWith(
                          //           fontSize: 12,
                          //           color: maingray,
                          //         ),
                          //       )
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: tapLike,
                          child: comment.isLiked.value == 0
                              ? SvgPicture.asset(
                                  "assets/icons/unlike.svg",
                                  width: 16,
                                  height: 16,
                                  color: maingray,
                                )
                              : SvgPicture.asset("assets/icons/like.svg",
                                  width: 16, height: 16),
                        ),
                        const SizedBox(
                          width: 10,
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
                          child: SvgPicture.asset("assets/icons/reply.svg",
                              width: 16, height: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: comment.user,
            userid: comment.user.userId,
            realname: comment.user.name),
        preventDuplicates: false);
  }

  void tapLike() {
    if (num == 0) {
      lastIsLiked = comment.isLiked.value;
    }
    if (comment.isLiked.value == 0) {
      comment.isLiked(1);
      comment.likecount += 1;
    } else {
      comment.isLiked(0);
      comment.likecount -= 1;
    }
    num += 1;

    _debouncer.run(() {
      if (lastIsLiked != comment.isLiked.value) {
        likepost(comment.id, contentType.comment);
        lastIsLiked = comment.isLiked.value;
        num = 0;
      }
    });
  }
}

class PostCommentWidget extends StatelessWidget {
  PostCommentWidget({Key? key, required this.comment, required this.postid})
      : super(key: key);

  Comment comment;
  int postid;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CommentWidget(comment: comment, postid: postid),
      Obx(
        () => comment.replyList.isNotEmpty
            ? Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ReplyWidget(
                            reply: comment.replyList[index], postid: postid);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 16,
                          ),
                      itemCount: comment.replyList.length),
                  if (comment.replycount.value - comment.replyList.length > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 94, 0),
                      child: GestureDetector(
                        onTap: () async {
                          await replyListLoad();
                        },
                        child: Text(
                            " - 이후 ${comment.replycount.value - comment.replyList.length}개 답글 보기",
                            style:
                                kmain.copyWith(color: maingray, fontSize: 14)),
                      ),
                    )
                ],
              )
            : Container(),
      )
    ]);
  }

  Future replyListLoad() async {
    await commentListGet(
            comment.id, contentType.cocomment, comment.replyList.last.id)
        .then((value) {
      if (value.isError == false) {
        List<Reply> replyList = List.from(value.data)
            .map((reply) => Reply.fromJson(reply, comment.id))
            .toList();

        comment.replyList.addAll(replyList);
        comment.replycount.value -= replyList.length;
      } else {
        errorSituation(value);
      }
    });
  }
}
