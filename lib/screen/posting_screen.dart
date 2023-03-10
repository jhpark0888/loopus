import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/post_update_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/comment_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/reply_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostingScreen extends StatelessWidget {
  PostingScreen({
    Key? key,
    this.post,
    this.autofocus = false,
    required this.postid,
  }) : super(key: key);
  late PostingDetailController controller = Get.put(
      PostingDetailController(
          postid: postid,
          post: post != null ? post!.obs : Post.defaultPost().obs,
          autoFocus: autofocus),
      tag: postid.toString());

  Post? post;
  int postid;
  bool autofocus;
  PageController pageController = PageController();
  RefreshController refreshController = RefreshController();

  void _commentSubmitted(String text) async {
    if (controller.isCommentLoading.value == false) {
      if (text.trim() == "" || text.trim() == "\u200B") {
        // showCustomDialog('????????? ??????????????????', 1400);
      } else {
        controller.isCommentLoading(true);
        if (controller.selectedCommentId.value == 0) {
          commentPost(postid, contentType.comment,
                  controller.commentController.text, null)
              .then((value) {
            if (value.isError == false) {
              controller.commentController.clear();
              controller.commentFocus.unfocus();
              Comment comment = Comment.fromJson(value.data);
              controller.post.value.comments.insert(0, comment);
              // controller.commentToList();
            } else {
              showCustomDialog('?????? ????????? ?????????????????????', 1400);
            }
            controller.isCommentLoading(false);
          });
        } else {
          commentPost(
                  controller.selectedCommentId.value,
                  contentType.cocomment,
                  controller.commentController.text,
                  controller.tagUser.value.userId)
              .then((value) {
            if (value.isError == false) {
              int commentId = controller.selectedCommentId.value;
              controller.commentController.clear();
              controller.commentFocus.unfocus();
              Reply reply = Reply.fromJson(value.data, commentId);
              controller.post.value.comments
                  .where((comment) => comment.id == commentId)
                  .first
                  .replyList
                  .add(reply);

              // controller.commentToList();
              controller.tagdelete();
            } else {
              showCustomDialog('????????? ????????? ?????????????????????', 1400);
            }
            controller.isCommentLoading(false);
          });
        }
      }
    }
  }

  Widget _buildTextComposer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: AppColors.dividegray, width: 1))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => controller.selectedCommentId.value != 0
                ? Container(
                    padding: const EdgeInsets.fromLTRB(24, 6.5, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '@${controller.tagUser.value.name}',
                              style: MyTextTheme.mainbold(context)
                                  .copyWith(color: AppColors.maingray)),
                          TextSpan(
                              text: '????????? ????????? ????????????',
                              style: MyTextTheme.main(context)
                                  .copyWith(color: AppColors.maingray))
                        ])),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: 9,
                            height: 9,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/reply_exit_icon.svg'),
                              onPressed: () {
                                controller.tagdelete();
                              },
                              padding: EdgeInsets.zero,
                            ))
                      ],
                    ))
                : Container(),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainWhite,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 7,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    cursorWidth: 1.2,
                    style: MyTextTheme.main(context)
                        .copyWith(decoration: TextDecoration.none),
                    cursorColor: AppColors.mainblack,
                    controller: controller.commentController,
                    focusNode: controller.commentFocus,
                    autofocus: autofocus,
                    onFieldSubmitted: _commentSubmitted,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (a) {
                      // print(a);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: "?????? ??????",
                      hintStyle: MyTextTheme.main(context)
                          .copyWith(color: AppColors.maingray),
                      fillColor: AppColors.lightcardgray,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Obx(
                  () => controller.isCommentLoading.value
                      ? const LoadingWidget()
                      : GestureDetector(
                          onTap: () => _commentSubmitted(
                              controller.commentController.text),
                          child: SvgPicture.asset(
                            "assets/icons/enter.svg",
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future commentListLoad() async {
    if (controller.post.value.comments.isNotEmpty) {
      await commentListGet(postid, contentType.comment,
              controller.post.value.comments.last.id)
          .then((value) {
        if (value.isError == false) {
          List<Comment> commentList = List.from(value.data)
              .map((comment) => Comment.fromJson(comment))
              .toList();

          controller.post.value.comments.addAll(commentList);

          if (commentList.length < 10) {
            refreshController.loadNoData();
            return;
          }
          refreshController.loadComplete();
        } else {
          errorSituation(value);
          refreshController.loadComplete();
        }
      });
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.commentFocus.unfocus();
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBarWidget(
            bottomBorder: false,
            leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/icons/appbar_back.svg'),
            ),
            title: '?????????',
            actions: [
              Obx(
                () => controller.postscreenstate.value == ScreenState.success
                    ? GestureDetector(
                        onTap: controller.post.value.isuser == 1
                            ? () {
                                showBottomdialog(context, func1: () {
                                  Get.to(() => PostUpdateScreen(
                                        post: controller.post.value,
                                      ));
                                }, func2: () {
                                  Get.back();
                                  showButtonDialog(
                                      leftText: '??????',
                                      rightText: '??????',
                                      title: '????????? ????????????',
                                      startContent:
                                          '?????? ???????????? ??????????????????????\n?????? ????????? ??? ?????????.',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () async {
                                        dialogBack(modalIOS: true);
                                        loading();
                                        // await Future.delayed(
                                        //         Duration(milliseconds: 1000))
                                        //     .then((value) {
                                        //   getbacks(2);
                                        //   showCustomDialog("???????????? ?????????????????????", 1400);
                                        // });
                                        deleteposting(
                                                controller.post.value.id,
                                                controller
                                                    .post.value.project!.id)
                                            .then((value) {
                                          Get.back();
                                          if (value.isError == false) {
                                            Get.back();
                                            if (Get.isRegistered<
                                                CareerDetailController>()) {
                                              Post tempPost =
                                                  CareerDetailController
                                                      .to.postList
                                                      .where((p0) =>
                                                          p0.id == postid)
                                                      .first;
                                              CareerDetailController.to.postList
                                                  .remove(tempPost);
                                              CareerDetailController.to.postList
                                                  .refresh();
                                            } else if (Get.isRegistered<
                                                ProfileController>()) {
                                              Project project =
                                                  ProfileController
                                                      .to.myProjectList
                                                      .where((career) =>
                                                          career.id ==
                                                          controller.post.value
                                                              .project!.id)
                                                      .first;
                                              project.posts.removeWhere(
                                                  (post) =>
                                                      post.id ==
                                                      controller.post.value.id);
                                              project.post_count!.value -= 1;
                                              if (project.post_count!.value ==
                                                  0) {
                                                project.thumbnail = '';
                                              } else {
                                                // project.thumbnail = project.thumbnail.
                                              }
                                            }
                                            HomeController.to.postingRemove(
                                                controller.post.value.id);

                                            showCustomDialog(
                                                "???????????? ?????????????????????", 1400);
                                          } else {
                                            errorSituation(value);
                                          }

                                          // HomeController.to.recommandpostingResult.value.postingitems
                                          //     .removeWhere((post) => post.id == postid);
                                          // HomeController.to.latestpostingResult.value.postingitems
                                          //     .removeWhere((post) => post.id == postid);
                                        });
                                      });
                                },
                                    value1: '????????? ????????????',
                                    value2: '????????? ????????????',
                                    isOne: false,
                                    buttonColor1: AppColors.mainWhite,
                                    buttonColor2: AppColors.rankred,
                                    textColor1: AppColors.mainblack);
                              }
                            : () {
                                showBottomdialog(context, func1: () {
                                  TextEditingController reportController =
                                      TextEditingController();

                                  showTextFieldDialog(
                                      title: '????????? ????????????',
                                      hintText:
                                          '?????? ????????? ??????????????????. ????????? ?????? ?????? ?????? ????????? ?????? ???????????????.',
                                      rightText: '????????????',
                                      rightBoxColor: AppColors.rankred,
                                      leftBoxColor: AppColors.maingray,
                                      textEditingController: reportController,
                                      leftFunction: () {
                                        Get.back();
                                      },
                                      rightFunction: () {
                                        contentreport(controller.post.value.id,
                                                contentType.post)
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
                                    value1: '????????? ????????????',
                                    value2: '',
                                    isOne: true,
                                    buttonColor1: AppColors.rankred);
                              },
                        child: SvgPicture.asset(
                            'assets/icons/appbar_more_option.svg'),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          // bottomNavigationBar: Transform.translate(
          //   offset:
          //       Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
          //   child: BottomAppBar(
          //     elevation: 0,
          //     child: _buildTextComposer(),
          //   ),
          // ),
          body: SafeArea(
            child: Obx(
              () => controller.postscreenstate.value == ScreenState.loading
                  ? const Center(child: LoadingWidget())
                  : controller.postscreenstate.value == ScreenState.normal
                      ? Container()
                      : controller.postscreenstate.value ==
                              ScreenState.disconnect
                          ? DisconnectReloadWidget(reload: () {
                              controller.postingLoad();
                            })
                          : controller.postscreenstate.value ==
                                  ScreenState.error
                              ? ErrorReloadWidget(reload: () {
                                  controller.postingLoad();
                                })
                              : Column(
                                  children: [
                                    Expanded(
                                      child: SmartRefresher(
                                        controller: refreshController,
                                        enablePullUp: true,
                                        enablePullDown: false,
                                        footer: const MyCustomFooter(),
                                        onLoading: commentListLoad,
                                        child: SingleChildScrollView(
                                          child: Column(children: [
                                            Obx(
                                              () => PostingWidget(
                                                item: controller.post.value,
                                                type: PostingWidgetType.detail,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Obx(
                                              () => ListView.separated(
                                                // key: controller.commentListKey,
                                                primary: false,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return PostCommentWidget(
                                                    comment: controller.post
                                                        .value.comments[index],
                                                    postid: postid,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 16,
                                                  );
                                                },
                                                itemCount: controller
                                                    .post.value.comments.length,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ]),
                                        ),
                                      ),
                                    ),
                                    _buildTextComposer(context)
                                  ],
                                ),
            ),
          )),
    );
  }

  void tapProfile() {
    if (controller.post.value.user.userType == UserType.student) {
      Get.to(
          () => OtherProfileScreen(
              user: (controller.post.value.user as Person),
              userid: controller.post.value.user.userId,
              realname: controller.post.value.user.name),
          preventDuplicates: false);
    } else {
      Get.to(
          () => OtherCompanyScreen(
                companyId: controller.post.value.user.userId,
                companyName: controller.post.value.user.name,
                company: (controller.post.value.user as Company),
              ),
          preventDuplicates: false);
    }
  }
}
