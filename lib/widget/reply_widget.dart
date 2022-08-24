import 'package:flutter/gestures.dart';
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
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
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
      padding: const EdgeInsets.only(left: 58, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: tapProfile,
            child: UserImageWidget(
              imageUrl: reply.user.profileImage ?? '',
              width: 29,
              height: 29,
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
                    // const Spacer(),
                    // RichText(
                    //     text: TextSpan(children: [
                    //   TextSpan(
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         Get.to(
                    //             () => OtherProfileScreen(
                    //                 user: reply.taggedUser,
                    //                 userid: reply.taggedUser.userid,
                    //                 realname: reply.taggedUser.realName),
                    //             preventDuplicates: false);
                    //       },
                    //     text: ' @${reply.taggedUser.realName}',
                    //     style: kmainbold.copyWith(
                    //         height: 1.5,
                    //         color: mainblue,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    //   TextSpan(
                    //     text: reply.content,
                    //     style: kmainheight,
                    //   )
                    // ])),
                    const Spacer(),
                    Text(
                      commentCalculateDate(reply.date),
                      style: kmain.copyWith(color: maingray),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: reply.user.userid ==
                              HomeController.to.myProfile.value.userid
                          ? () {
                              showModalIOS(
                                context,
                                func1: () {
                                  showButtonDialog(
                                      leftText: '취소',
                                      rightText: '삭제',
                                      title: '답글을 삭제하시겠어요?',
                                      content: '삭제한 답글은 복구할 수 없어요',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () async {
                                        dialogBack(modalIOS: true);

                                        await commentDelete(
                                                reply.id, contentType.cocomment)
                                            .then((value) {
                                          if (value.isError == false) {
                                            Comment? comment = postController
                                                .post!.value.comments
                                                .firstWhereOrNull((element) =>
                                                    element.id ==
                                                    reply.commentId);
                                            if (comment != null) {
                                              comment.replyList.removeWhere(
                                                  (element) =>
                                                      element.id == reply.id);
                                              comment.replycount.value -= 1;
                                            }
                                          } else {
                                            showCustomDialog(
                                                "답글 삭제에 실패하였습니다", 1000);
                                          }
                                        });
                                      });
                                },
                                func2: () {},
                                value1: '답글 삭제하기',
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
                                      title: '정말 답글을 신고하시겠어요?',
                                      content: '관리자가 검토 절차를 거칩니다',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () {
                                        contentreport(
                                                reply.id, contentType.cocomment)
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
                                value1: '이 답글 신고하기',
                                value2: '',
                                isValue1Red: true,
                                isValue2Red: false,
                                isOne: true,
                              );
                            },
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                          height: 16,
                          child:
                              SvgPicture.asset('assets/icons/more_option.svg')),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
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
                    text: '@${reply.taggedUser.realName}',
                    style: kmainbold.copyWith(
                        height: 1.5,
                        color: Color.fromARGB(255, 71, 155, 224),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: reply.content,
                    style: kmainheight,
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
                                likeType: contentType.cocomment,
                              ));
                        },
                        child: Text(
                          '좋아요 ${reply.likecount.value}개',
                          style: kmain.copyWith(
                            color: maingray,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      InkWell(
                        onTap: tapLike,
                        child: reply.isLiked.value == 0
                            ? SvgPicture.asset("assets/icons/unlike.svg",
                                width: 11, height: 11)
                            : SvgPicture.asset("assets/icons/like.svg",
                                width: 11, height: 11),
                      ),
                      const SizedBox(
                        width: 14,
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
                        child: SvgPicture.asset("assets/icons/reply.svg",
                            height: 11, width: 11),
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
        likepost(reply.id, contentType.cocomment);
        lastIsLiked = reply.isLiked.value;
        num = 0;
      }
    });
  }
}
