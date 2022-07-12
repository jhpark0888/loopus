import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/post_update_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/comment_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/reply_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class PostingScreen extends StatelessWidget {
  PostingScreen({
    Key? key,
    this.post,
    required this.postid,
  }) : super(key: key);
  late PostingDetailController controller = Get.put(
      PostingDetailController(
          postid: postid, post: post != null ? post.obs : null.obs),
      tag: postid.toString());
  // late final LikeController likeController = Get.put(
  //     LikeController(
  //         isLiked: isLiked,
  //         id: postid,
  //         lastisliked: isLiked.value,
  //         liketype: Liketype.post),
  //     tag: 'post$postid');

  Post? post;
  int postid;
  PageController pageController = PageController();

  final Debouncer _debouncer = Debouncer();

  void _commentSubmitted(String text) async {
    if (text.trim() == "") {
      showCustomDialog('내용을 입력해주세요', 1400);
    } else {
      if (controller.selectedCommentId.value == 0) {
        commentPost(postid, 'post', controller.commentController.text, null)
            .then((value) {
          if (value.isError == false) {
            controller.commentController.clear();
            Comment comment = Comment.fromJson(value.data);
            controller.post.value!.comments.insert(0, comment);
            controller.commentToList();
          } else {
            showCustomDialog('댓글 작성에 실패하였습니다', 1400);
          }
        });
      } else {
        commentPost(
                controller.selectedCommentId.value,
                'comment',
                controller.commentController.text,
                controller.tagUser.value.userid)
            .then((value) {
          if (value.isError == false) {
            Reply reply =
                Reply.fromJson(value.data, controller.selectedCommentId.value);
            controller.post.value!.comments
                .where((comment) =>
                    comment.id == controller.selectedCommentId.value)
                .first
                .replyList
                .add(reply);
            controller.commentController.clear();
            controller.commentToList();
            controller.tagdelete();
          } else {
            showCustomDialog('대댓글 작성에 실패하였습니다', 1400);
          }
        });
      }
    }
  }

  Widget _buildTextComposer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => controller.selectedCommentId.value != 0
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: dividegray,
                    width: 0.3,
                  ))),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  height: 44,
                  child: Text(
                    '${controller.tagUser.value.realName}님에게 답글을 남기는 중',
                    style: k16Normal.copyWith(color: maingray),
                  ))
              : Container(),
        ),
        Container(
          decoration: BoxDecoration(
            color: mainWhite,
            border: Border(
              top: BorderSide(
                width: 0.3,
                color: dividegray,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  cursorWidth: 1.2,
                  style: const TextStyle(decoration: TextDecoration.none),
                  cursorColor: mainblack,
                  controller: controller.commentController,
                  focusNode: controller.commentFocus,
                  onFieldSubmitted: _commentSubmitted,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    prefix: controller.tagUser.value.userid == 0
                        ? null
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            height: 22,
                            decoration: BoxDecoration(
                                color: mainWhite,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '@${controller.tagUser.value.realName}',
                              style: k16Normal,
                            ),
                          ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintText: "댓글 입력",
                    hintStyle: k16Normal.copyWith(color: maingray),
                    fillColor: lightcardgray,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              GestureDetector(
                onTap: () =>
                    _commentSubmitted(controller.commentController.text),
                child: SvgPicture.asset(
                  "assets/icons/Enter_Icon.svg",
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.postscreenstate.value == ScreenState.success
          ? Scaffold(
              // resizeToAvoidBottomInset: false,
              appBar: AppBarWidget(
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset('assets/icons/Close.svg'),
                ),
                title: '게시물',
                actions: [
                  IconButton(
                    onPressed: controller.post.value!.isuser == 1
                        ? () {
                            showModalIOS(
                              context,
                              func1: () {
                                showButtonDialog(
                                    leftText: '취소',
                                    rightText: '삭제',
                                    title: '포스팅을 삭제하시겠어요?',
                                    content: '삭제한 포스팅은 복구할 수 없어요',
                                    leftFunction: () => Get.back(),
                                    rightFunction: () async {
                                      dialogBack(modalIOS: true);
                                      loading();
                                      // await Future.delayed(
                                      //         Duration(milliseconds: 1000))
                                      //     .then((value) {
                                      //   getbacks(2);
                                      //   showCustomDialog("포스팅이 삭제되었습니다", 1400);
                                      // });
                                      deleteposting(
                                              controller.post.value!.id,
                                              controller
                                                  .post.value!.project!.id)
                                          .then((value) {
                                        Get.back();
                                        if (value.isError == false) {
                                          Get.back();
                                          Project project = ProfileController
                                              .to.myProjectList
                                              .where((career) =>
                                                  career.id ==
                                                  controller
                                                      .post.value!.project!.id)
                                              .first;
                                          project.posts.removeWhere((post) =>
                                              post.id ==
                                              controller.post.value!.id);
                                          showCustomDialog(
                                              "포스팅이 삭제되었습니다", 1400);
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
                              func2: () {
                                Get.to(() => PostUpdateScreen(
                                      post: controller.post.value!,
                                    ));
                              },
                              value1: '포스팅 삭제하기',
                              value2: '포스팅 수정하기',
                              isValue1Red: true,
                              isValue2Red: false,
                              isOne: false,
                            );
                          }
                        : () {
                            showModalIOS(
                              context,
                              func1: () {
                                showButtonDialog(
                                    leftText: '취소',
                                    rightText: '신고',
                                    title: '정말 포스팅을 신고하시겠어요?',
                                    content: '관리자가 검토 절차를 거칩니다',
                                    leftFunction: () => Get.back(),
                                    rightFunction: () {
                                      postingreport(controller.post.value!.id);
                                    });
                              },
                              func2: () {},
                              value1: '이 포스팅 신고하기',
                              value2: '',
                              isValue1Red: true,
                              isValue2Red: false,
                              isOne: true,
                            );
                          },
                    icon: SvgPicture.asset('assets/icons/More.svg'),
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
              body: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: ScrollNoneffectWidget(
                        child: SingleChildScrollView(
                          child: Obx(
                            () => Column(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 14, 20, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                  () => OtherProfileScreen(
                                                      user: controller
                                                          .post.value!.user,
                                                      userid: controller.post
                                                          .value!.user.userid,
                                                      realname: controller
                                                          .post
                                                          .value!
                                                          .user
                                                          .realName),
                                                  preventDuplicates: false);
                                            },
                                            child: Row(
                                              children: [
                                                UserImageWidget(
                                                  imageUrl: controller
                                                          .post
                                                          .value!
                                                          .user
                                                          .profileImage ??
                                                      '',
                                                  width: 35,
                                                  height: 35,
                                                ),
                                                const SizedBox(
                                                  width: 14,
                                                ),
                                                Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          controller.post.value!
                                                              .user.realName,
                                                          style: k16semiBold),
                                                      Text(
                                                          controller.post.value!
                                                              .user.department,
                                                          style:
                                                              kSubTitle3Style)
                                                    ])
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              controller.post.value!.project!
                                                  .careerName,
                                              style: k16semiBold.copyWith(
                                                  color: maingray),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  if (controller
                                          .post.value!.images.isNotEmpty ||
                                      controller.post.value!.links.isNotEmpty)
                                    Column(
                                      children: [
                                        Container(
                                            color: mainblack,
                                            constraints: BoxConstraints(
                                                maxWidth: 600,
                                                maxHeight: controller
                                                        .post
                                                        .value!
                                                        .images
                                                        .isNotEmpty
                                                    ? Get.width
                                                    : 300),
                                            child: PageView.builder(
                                              controller: pageController,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (controller.post.value!
                                                    .images.isNotEmpty) {
                                                  return CachedNetworkImage(
                                                      imageUrl: controller.post
                                                          .value!.images[index],
                                                      fit: BoxFit.contain);
                                                  // Image.network(item.images[index],
                                                  //     fit: BoxFit.fill);
                                                } else {
                                                  return KeepAlivePage(
                                                    child: LinkWidget(
                                                        url: controller
                                                            .post
                                                            .value!
                                                            .links[index],
                                                        widgetType: 'post'),
                                                  );
                                                }
                                              },
                                              itemCount: controller.post.value!
                                                      .images.isNotEmpty
                                                  ? controller
                                                      .post.value!.images.length
                                                  : controller
                                                      .post.value!.links.length,
                                            )),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        if (controller
                                                    .post.value!.images.length >
                                                1 ||
                                            controller
                                                    .post.value!.links.length >
                                                1)
                                          Column(
                                            children: [
                                              PageIndicator(
                                                size: 7,
                                                activeSize: 7,
                                                space: 7,
                                                color: maingray,
                                                activeColor: mainblue,
                                                count: controller.post.value!
                                                        .images.isNotEmpty
                                                    ? controller.post.value!
                                                        .images.length
                                                    : controller.post.value!
                                                        .links.length,
                                                controller: pageController,
                                                layout:
                                                    PageIndicatorLayout.SLIDE,
                                              ),
                                            ],
                                          ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                      ],
                                    ),
                                  // if (controller
                                  //         .post.value!.images.isNotEmpty ||
                                  //     controller.post.value!.links.isNotEmpty)
                                  //   SizedBox(
                                  //       height: Get.width,
                                  //       child: Swiper(
                                  //         loop: false,
                                  //         outer: true,
                                  //         itemCount: controller
                                  //                 .post.value!.images.isNotEmpty
                                  //             ? controller
                                  //                 .post.value!.images.length
                                  //             : controller
                                  //                 .post.value!.links.length,
                                  //         itemBuilder: (BuildContext context,
                                  //             int index) {
                                  //           if (controller.post.value!.images
                                  //               .isNotEmpty) {
                                  //             return CachedNetworkImage(
                                  //                 imageUrl: controller.post
                                  //                     .value!.images[index],
                                  //                 fit: BoxFit.fill);
                                  //           } else {
                                  //             return LinkWidget(
                                  //                 url: controller
                                  //                     .post.value!.links[index],
                                  //                 widgetType: 'post');
                                  //           }
                                  //         },
                                  //         pagination: SwiperPagination(
                                  //             margin: EdgeInsets.all(14),
                                  //             alignment: Alignment.bottomCenter,
                                  //             builder:
                                  //                 DotSwiperPaginationBuilder(
                                  //                     color: Color(0xFF5A5A5A)
                                  //                         .withOpacity(0.5),
                                  //                     activeColor: mainblue,
                                  //                     size: 7,
                                  //                     activeSize: 7)),
                                  //       )),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Obx(
                                          () => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  controller.post.value!.content
                                                      .value,
                                                  style: kSubTitle3Style
                                                      .copyWith(height: 1.5)),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Wrap(
                                                spacing: 7,
                                                runSpacing: 7,
                                                children:
                                                    controller.post.value!.tags
                                                        .map((tag) => Tagwidget(
                                                              tag: tag,
                                                            ))
                                                        .toList(),
                                              ),
                                              const SizedBox(height: 14),
                                              Obx(
                                                () => Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: tapLike,
                                                      child: controller
                                                                  .post
                                                                  .value!
                                                                  .isLiked
                                                                  .value ==
                                                              0
                                                          ? SvgPicture.asset(
                                                              "assets/icons/Favorite_Inactive.svg")
                                                          : SvgPicture.asset(
                                                              "assets/icons/Favorite_Active.svg"),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    // Obx(
                                                    //   () => SizedBox(
                                                    //     width: controller
                                                    //                 .post
                                                    //                 .value!
                                                    //                 .likeCount
                                                    //                 .value !=
                                                    //             0
                                                    //         ? 0
                                                    //         : 8,
                                                    //   ),
                                                    // ),
                                                    SvgPicture.asset(
                                                        "assets/icons/Comment.svg"),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: tapBookmark,
                                                      child: (controller
                                                                  .post
                                                                  .value!
                                                                  .isMarked
                                                                  .value ==
                                                              0)
                                                          ? SvgPicture.asset(
                                                              "assets/icons/Mark_Default.svg",
                                                              color: mainblack,
                                                            )
                                                          : SvgPicture.asset(
                                                              "assets/icons/Mark_Saved.svg"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // postingTag(),
                                              const SizedBox(
                                                height: 13,
                                              ),
                                              Row(children: [
                                                GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      Get.to(() =>
                                                          LikePeopleScreen(
                                                            postid: controller
                                                                .post.value!.id,
                                                          ));
                                                    },
                                                    child: Obx(
                                                      () => Text(
                                                        '좋아요 ${controller.post.value!.likeCount}개',
                                                        style: kSubTitle3Style,
                                                      ),
                                                    )),
                                                const Spacer(),
                                                Text(
                                                    calculateDate(controller
                                                        .post.value!.date),
                                                    style: kSubTitle3Style),
                                              ]),
                                              const SizedBox(height: 13),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // if (view != 'detail') const DivideWidget()
                                    ],
                                  ),
                                ],
                              ),
                              // PostingWidget(
                              //   controller.post.value!: controller.post.value!,
                              //   view: 'detail',
                              // ),
                              Obx(
                                () => ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (controller.postCommentList[index]
                                            .runtimeType ==
                                        Comment) {
                                      return CommentWidget(
                                        comment: controller
                                            .postCommentList[index] as Comment,
                                        postid: postid,
                                      );
                                    } else {
                                      return ReplyWidget(
                                          reply: controller
                                              .postCommentList[index] as Reply,
                                          postid: postid);
                                    }
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 14,
                                    );
                                  },
                                  itemCount: controller.postCommentList.length,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildTextComposer()
                ],
              ))
          : controller.postscreenstate.value == ScreenState.loading
              ? LoadingScreen()
              : Container(),
    );
  }

  void tapBookmark() {
    // if (item.isMarked.value == 0) {
    //   homeController.tapBookmark(item.id);
    // } else {
    //   homeController.tapunBookmark(item.id);
    // }
  }

  void tapLike() {
    if (controller.post.value!.isLiked.value == 0) {
      controller.post.value!.isLiked(1);
      // likepost(controller.post.value!.id, 'post');
      controller.post.value!.likeCount += 1;
      // homeController.tapLike(item.id, item.likeCount.value);
    } else {
      controller.post.value!.isLiked(0);
      // likepost(controller.post.value!.id, 'post');
      controller.post.value!.likeCount -= 1;
      // homeController.tapunLike(item.id, item.likeCount.value);
    }

    _debouncer.run(() {
      if (controller.lastIsLiked != controller.post.value!.isLiked.value) {
        likepost(controller.post.value!.id, 'post');
        controller.lastIsLiked = controller.post.value!.isLiked.value;
      }
    });
  }

  void tapProfile() {
    // Get.to(() => OtherProfileScreen(
    //       userid: item.userid,
    //       isuser: item.isuser,
    //       realname: item.user.realName,
    //     ));
  }
}
