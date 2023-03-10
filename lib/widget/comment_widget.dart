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
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: tapProfile,
                        child: Text(
                          comment.user.name,
                          style: MyTextTheme.mainbold(context),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: comment.user.userId ==
                                  HomeController.to.myProfile.value.userId
                              ? () {
                                  showBottomdialog(context, func1: () {
                                    showButtonDialog(
                                        leftText: '??????',
                                        rightText: '??????',
                                        title: '????????? ??????????????????????',
                                        startContent: '????????? ????????? ????????? ??? ?????????',
                                        leftFunction: () => Get.back(),
                                        rightFunction: () async {
                                          dialogBack(modalIOS: true);

                                          await commentDelete(comment.id,
                                                  contentType.comment)
                                              .then((value) {
                                            if (value.isError == false) {
                                              postController.post.value.comments
                                                  .removeWhere((element) =>
                                                      element.id == comment.id);
                                            } else {
                                              showCustomDialog(
                                                  "?????? ????????? ?????????????????????", 1000);
                                            }
                                          });
                                        });
                                  },
                                      func2: () {},
                                      value1: '?????? ????????????',
                                      value2: '',
                                      isOne: true,
                                      buttonColor1: AppColors.mainWhite,
                                      textColor1: AppColors.mainblack);
                                }
                              : () {
                                  showBottomdialog(context, func1: () {
                                    TextEditingController reportController =
                                        TextEditingController();

                                    showTextFieldDialog(
                                        title: '?????? ????????????',
                                        hintText:
                                            '?????? ????????? ??????????????????. ????????? ?????? ?????? ?????? ????????? ?????? ???????????????.',
                                        rightText: '????????????',
                                        rightBoxColor: AppColors.rankred,
                                        textEditingController: reportController,
                                        leftFunction: () {
                                          Get.back();
                                        },
                                        rightFunction: () {
                                          contentreport(comment.id,
                                                  contentType.comment)
                                              .then((value) {
                                            if (value.isError == false) {
                                              getbacks(2);
                                              showCustomDialog(
                                                  "????????? ?????????????????????", 1000);
                                            } else {
                                              errorSituation(value);
                                            }
                                          });
                                        });
                                  },
                                      func2: () {},
                                      value1: '?????? ????????????',
                                      value2: '',
                                      isOne: true,
                                      buttonColor1: AppColors.rankred);
                                },
                          // behavior: HitTestBehavior.translucent,
                          icon: SvgPicture.asset(
                            'assets/icons/comment_option_icon.svg',
                            color: AppColors.maingray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: MyTextTheme.mainheight(context),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          '${commentCalculateDate(comment.date)} ???',
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.maingray),
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
                            '????????? ${comment.likecount.value}???',
                            style: MyTextTheme.main(context).copyWith(
                              color: AppColors.maingray,
                            ),
                          ),
                          //  comment.likecount.value > 0
                          //     ? Text(
                          //         '????????? ${comment.likecount.value}???',
                          //         style: MyTextTheme.main(context).copyWith(
                          //           fontSize: 12,
                          //           color: AppColors.maingray,
                          //         ),
                          //       )
                          //     : Text(
                          //         '?????????',
                          //         style: MyTextTheme.main(context).copyWith(
                          //           fontSize: 12,
                          //           color: AppColors.maingray,
                          //         ),
                          //       )
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: tapLike,
                            icon: comment.isLiked.value == 0
                                ? SvgPicture.asset(
                                    "assets/icons/unlike.svg",
                                    width: 16,
                                    height: 16,
                                    color: AppColors.maingray,
                                  )
                                : SvgPicture.asset("assets/icons/like.svg",
                                    width: 16, height: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
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
                            icon: SvgPicture.asset("assets/icons/reply.svg",
                                width: 16, height: 16),
                          ),
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
    if (comment.user.userType == UserType.student) {
      Get.to(
          () => OtherProfileScreen(
              user: comment.user as Person,
              userid: comment.user.userId,
              realname: comment.user.name),
          preventDuplicates: false);
    } else {
      Get.to(
          () => OtherCompanyScreen(
              company: comment.user as Company,
              companyId: comment.user.userId,
              companyName: comment.user.name),
          preventDuplicates: false);
    }
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
                      padding: const EdgeInsets.fromLTRB(60, 23, 16, 0),
                      child: GestureDetector(
                        onTap: () async {
                          await replyListLoad();
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 0.5,
                                color: AppColors.maingray,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                                "${comment.replycount.value - comment.replyList.length}??? ?????? ?????????",
                                style: MyTextTheme.mainbold(context)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Divider(
                                height: 0.5,
                                color: AppColors.maingray,
                              ),
                            )
                          ],
                        ),
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
