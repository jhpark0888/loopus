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
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () => tapLike(),
      child: Container(
        padding: const EdgeInsets.only(left: 60, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: tapProfile,
              child: UserImageWidget(
                imageUrl: reply.user.profileImage,
                width: 36,
                height: 36,
                userType: reply.user.userType,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: tapProfile,
                        child: Text(
                          reply.user.name,
                          style: MyTextTheme.mainbold(context),
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
                      //                 realname: reply.taggedUser.name),
                      //             preventDuplicates: false);
                      //       },
                      //     text: ' @${reply.taggedUser.name}',
                      //     style: MyTextTheme.mainbold(context).copyWith(
                      //         height: 1.5,
                      //         color: AppColors.mainblue,
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      //   TextSpan(
                      //     text: reply.content,
                      //     style: MyTextTheme.mainheight(context),
                      //   )
                      // ])),
                      const Spacer(),
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: reply.user.userId ==
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

                                          await commentDelete(reply.id,
                                                  contentType.cocomment)
                                              .then((value) {
                                            if (value.isError == false) {
                                              Comment? comment = postController
                                                  .post.value.comments
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
                                  // showModalIOS(
                                  //   context,
                                  //   cancleButton: false,
                                  //   func1: () {
                                  //     showButtonDialog(
                                  //         leftText: '??????',
                                  //         rightText: '??????',
                                  //         title: '????????? ??????????????????????',
                                  //         startContent: '????????? ????????? ????????? ??? ?????????',
                                  //         leftFunction: () => Get.back(),
                                  //         rightFunction: () async {
                                  //           dialogBack(modalIOS: true);

                                  //           await commentDelete(reply.id,
                                  //                   contentType.cocomment)
                                  //               .then((value) {
                                  //             if (value.isError == false) {
                                  //               Comment? comment = postController
                                  //                   .post!.value.comments
                                  //                   .firstWhereOrNull((element) =>
                                  //                       element.id ==
                                  //                       reply.commentId);
                                  //               if (comment != null) {
                                  //                 comment.replyList.removeWhere(
                                  //                     (element) =>
                                  //                         element.id == reply.id);
                                  //                 comment.replycount.value -= 1;
                                  //               }
                                  //             } else {
                                  //               showCustomDialog(
                                  //                   "?????? ????????? ?????????????????????", 1000);
                                  //             }
                                  //           });
                                  //         });
                                  //   },
                                  //   func2: () {},
                                  //   value1: '?????? ????????????',
                                  //   value2: '',
                                  //   isValue1Red: true,
                                  //   isValue2Red: false,
                                  //   isOne: true,
                                  // );
                                }
                              : () {
                                  showModalIOS(context, func1: () {
                                    showButtonDialog(
                                        leftText: '??????',
                                        rightText: '??????',
                                        title: '?????? ????????? ??????????????????????',
                                        startContent: '???????????? ?????? ????????? ????????????',
                                        leftFunction: () => Get.back(),
                                        rightFunction: () {
                                          contentreport(reply.id,
                                                  contentType.cocomment)
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
                                      isValue1Red: true,
                                      isValue2Red: false,
                                      isOne: true,
                                      cancleButton: false);
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
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  Text(reply.content, style: MyTextTheme.mainheight(context)),
                  // RichText(
                  //   textAlign: TextAlign.start,
                  //     text: TextSpan(children: [
                  //   // TextSpan(
                  //   //   recognizer: TapGestureRecognizer()
                  //   //     ..onTap = () {
                  //   //       Get.to(
                  //   //           () => OtherProfileScreen(
                  //   //               user: reply.taggedUser,
                  //   //               userid: reply.taggedUser.userId,
                  //   //               realname: reply.taggedUser.name),
                  //   //           preventDuplicates: false);
                  //   //     },
                  //   //   text: '@${reply.taggedUser.name}',
                  //   //   style: MyTextTheme.mainbold(context).copyWith(
                  //   //       height: 1.5,
                  //   //       color: Color.fromARGB(255, 71, 155, 224),
                  //   //       fontSize: 14,
                  //   //       fontWeight: FontWeight.w400),
                  //   // ),
                  //   TextSpan(
                  //     text: reply.content,
                  //     style: MyTextTheme.mainheight(context),
                  //   )
                  // ])),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${commentCalculateDate(reply.date)} ???',
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.maingray),
                        ),
                        const Spacer(),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(() => LikePeopleScreen(
                                    id: reply.id,
                                    likeType: contentType.cocomment,
                                  ));
                            },
                            child: Text(
                              '????????? ${reply.likecount.value}???',
                              style: MyTextTheme.main(context).copyWith(
                                color: AppColors.maingray,
                              ),
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: tapLike,
                          child: reply.isLiked.value == 0
                              ? SvgPicture.asset(
                                  "assets/icons/unlike.svg",
                                  width: 16,
                                  height: 16,
                                  color: AppColors.maingray,
                                )
                              : SvgPicture.asset(
                                  "assets/icons/like.svg",
                                  width: 16,
                                  height: 16,
                                ),
                        ),
                        const SizedBox(
                          width: 16,
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
                              height: 16, width: 16),
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
    );
  }

  void tapProfile() {
    if (reply.user.userType == UserType.student) {
      Get.to(
          () => OtherProfileScreen(
              user: reply.user as Person,
              userid: reply.user.userId,
              realname: reply.user.name),
          preventDuplicates: false);
    } else {
      Get.to(
          () => OtherCompanyScreen(
              company: reply.user as Company,
              companyId: reply.user.userId,
              companyName: reply.user.name),
          preventDuplicates: false);
    }
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
