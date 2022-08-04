import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/post_update_screen.dart';
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
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/reply_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostingScreen extends StatelessWidget {
  PostingScreen({
    Key? key,
    this.post,
    this.autofocus,
    required this.postid,
  }) : super(key: key);
  late PostingDetailController controller = Get.put(
      PostingDetailController(
          postid: postid, post: post != null ? post.obs : null.obs),
      tag: postid.toString());

  Post? post;
  int postid;
  bool? autofocus;
  PageController pageController = PageController();

  final Debouncer _debouncer = Debouncer();

  void _commentSubmitted(String text) async {
    if (text.trim() == "") {
      showCustomDialog('내용을 입력해주세요', 1400);
    } else {
      if (controller.selectedCommentId.value == 0) {
        commentPost(postid, 'comment', controller.commentController.text, null)
            .then((value) {
          if (value.isError == false) {
            controller.commentController.clear();
            Comment comment = Comment.fromJson(value.data);
            controller.post.value!.comments.insert(0, comment);
            // controller.commentToList();
          } else {
            showCustomDialog('댓글 작성에 실패하였습니다', 1400);
          }
        });
      } else {
        commentPost(
                controller.selectedCommentId.value,
                'cocomment',
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
            // controller.commentToList();
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
                  autofocus: autofocus ?? false,
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
      () => controller.postscreenstate.value == ScreenState.loading
          ? const LoadingScreen()
          : controller.postscreenstate.value == ScreenState.normal
              ? Container()
              : controller.postscreenstate.value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {})
                  : controller.postscreenstate.value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {})
                      : SafeArea(
                          child: Scaffold(
                              // resizeToAvoidBottomInset: false,
                              appBar: AppBarWidget(
                                leading: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/icons/Close.svg'),
                                ),
                                title: '게시물',
                                actions: [
                                  IconButton(
                                    onPressed: controller.post.value!.isuser ==
                                            1
                                        ? () {
                                            showModalIOS(
                                              context,
                                              func1: () {
                                                showButtonDialog(
                                                    leftText: '취소',
                                                    rightText: '삭제',
                                                    title: '포스팅을 삭제하시겠어요?',
                                                    content:
                                                        '삭제한 포스팅은 복구할 수 없어요',
                                                    leftFunction: () =>
                                                        Get.back(),
                                                    rightFunction: () async {
                                                      dialogBack(
                                                          modalIOS: true);
                                                      loading();
                                                      // await Future.delayed(
                                                      //         Duration(milliseconds: 1000))
                                                      //     .then((value) {
                                                      //   getbacks(2);
                                                      //   showCustomDialog("포스팅이 삭제되었습니다", 1400);
                                                      // });
                                                      deleteposting(
                                                              controller.post
                                                                  .value!.id,
                                                              controller
                                                                  .post
                                                                  .value!
                                                                  .project!
                                                                  .id)
                                                          .then((value) {
                                                        Get.back();
                                                        if (value.isError ==
                                                            false) {
                                                          Get.back();
                                                          Project project =
                                                              ProfileController
                                                                  .to
                                                                  .myProjectList
                                                                  .where((career) =>
                                                                      career
                                                                          .id ==
                                                                      controller
                                                                          .post
                                                                          .value!
                                                                          .project!
                                                                          .id)
                                                                  .first;
                                                          project.posts
                                                              .removeWhere(
                                                                  (post) =>
                                                                      post.id ==
                                                                      controller
                                                                          .post
                                                                          .value!
                                                                          .id);
                                                          showCustomDialog(
                                                              "포스팅이 삭제되었습니다",
                                                              1400);
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
                                                      post: controller
                                                          .post.value!,
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
                                                    leftFunction: () =>
                                                        Get.back(),
                                                    rightFunction: () {
                                                      postingreport(controller
                                                          .post.value!.id);
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
                                    icon: SvgPicture.asset(
                                        'assets/icons/More.svg'),
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
                                      child: SmartRefresher(
                                        controller:
                                            controller.refreshController,
                                        enablePullUp: true,
                                        enablePullDown: false,
                                        footer: const MyCustomFooter(),
                                        onLoading: controller.commentListLoad,
                                        child: SingleChildScrollView(
                                          child: Column(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 14, 20, 0),
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              tapProfile(),
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
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        controller
                                                                            .post
                                                                            .value!
                                                                            .user
                                                                            .realName,
                                                                        style:
                                                                            k16semiBold),
                                                                    Text(
                                                                        controller
                                                                            .post
                                                                            .value!
                                                                            .user
                                                                            .department,
                                                                        style:
                                                                            kSubTitle3Style)
                                                                  ])
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 14),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            controller
                                                                .post
                                                                .value!
                                                                .project!
                                                                .careerName,
                                                            style: k16semiBold
                                                                .copyWith(
                                                                    color:
                                                                        maingray),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 14),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                if (controller.post.value!
                                                        .images.isNotEmpty ||
                                                    controller.post.value!.links
                                                        .isNotEmpty)
                                                  SwiperWidget(
                                                    items: controller
                                                            .post
                                                            .value!
                                                            .images
                                                            .isNotEmpty
                                                        ? controller
                                                            .post.value!.images
                                                        : controller
                                                            .post.value!.links,
                                                    swiperType: controller
                                                            .post
                                                            .value!
                                                            .images
                                                            .isNotEmpty
                                                        ? SwiperType.image
                                                        : SwiperType.link,
                                                    aspectRatio: controller
                                                            .post
                                                            .value!
                                                            .images
                                                            .isNotEmpty
                                                        ? getAspectRatioinUrl(
                                                            controller
                                                                .post
                                                                .value!
                                                                .images[0])
                                                        : null,
                                                  ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                      ),
                                                      child: Obx(
                                                        () => Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                controller
                                                                    .post
                                                                    .value!
                                                                    .content
                                                                    .value,
                                                                style: kSubTitle3Style
                                                                    .copyWith(
                                                                        height:
                                                                            1.5)),
                                                            const SizedBox(
                                                              height: 14,
                                                            ),
                                                            Wrap(
                                                              spacing: 7,
                                                              runSpacing: 7,
                                                              children: controller
                                                                  .post
                                                                  .value!
                                                                  .tags
                                                                  .map((tag) =>
                                                                      Tagwidget(
                                                                        tag:
                                                                            tag,
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                            const SizedBox(
                                                                height: 14),
                                                            Obx(
                                                              () => Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        tapLike,
                                                                    child: controller.post.value!.isLiked.value ==
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
                                                                    onTap:
                                                                        tapBookmark,
                                                                    child: (controller.post.value!.isMarked.value ==
                                                                            0)
                                                                        ? SvgPicture
                                                                            .asset(
                                                                            "assets/icons/Mark_Default.svg",
                                                                            color:
                                                                                mainblack,
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
                                                                  behavior:
                                                                      HitTestBehavior
                                                                          .translucent,
                                                                  onTap: () {
                                                                    Get.to(
                                                                      () =>
                                                                          LikePeopleScreen(
                                                                        id: controller
                                                                            .post
                                                                            .value!
                                                                            .id,
                                                                        likeType:
                                                                            LikeType.post,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Obx(
                                                                    () => Text(
                                                                      '좋아요 ${controller.post.value!.likeCount}개',
                                                                      style:
                                                                          kSubTitle3Style,
                                                                    ),
                                                                  )),
                                                              const Spacer(),
                                                              Text(
                                                                  calculateDate(
                                                                      controller
                                                                          .post
                                                                          .value!
                                                                          .date),
                                                                  style:
                                                                      kSubTitle3Style),
                                                            ]),
                                                            const SizedBox(
                                                                height: 13),
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
                                                  return PostCommentWidget(
                                                    comment: controller.post
                                                        .value!.comments[index],
                                                    postid: postid,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 14,
                                                  );
                                                },
                                                itemCount: controller.post
                                                    .value!.comments.length,
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
                                  _buildTextComposer()
                                ],
                              )),
                        ),
    );
  }

  void tapBookmark() {
    if (controller.post.value!.isMarked.value == 0) {
      controller.post.value!.isMarked(1);
    } else {
      controller.post.value!.isMarked(0);
    }

    _debouncer.run(() {
      if (controller.lastIsMarked != controller.post.value!.isMarked.value) {
        bookmarkpost(controller.post.value!.id).then((value) {
          if (value.isError == false) {
            controller.lastIsMarked = controller.post.value!.isMarked.value;

            if (controller.post.value!.isMarked.value == 1) {
              HomeController.to.tapBookmark(controller.post.value!.id);
              showCustomDialog("북마크에 추가되었습니다", 1000);
            } else {
              HomeController.to.tapunBookmark(controller.post.value!.id);
            }
          } else {
            errorSituation(value);
            controller.post.value!.isMarked(controller.lastIsMarked);
          }
        });
      }
    });
  }

  void tapLike() {
    if (controller.post.value!.isLiked.value == 0) {
      controller.post.value!.isLiked(1);
      // likepost(controller.post.value!.id, 'post');
      controller.post.value!.likeCount += 1;
      HomeController.to.tapLike(
          controller.post.value!.id, controller.post.value!.likeCount.value);
    } else {
      controller.post.value!.isLiked(0);
      // likepost(controller.post.value!.id, 'post');
      controller.post.value!.likeCount -= 1;
      HomeController.to.tapunLike(
          controller.post.value!.id, controller.post.value!.likeCount.value);
    }

    _debouncer.run(() {
      if (controller.lastIsLiked != controller.post.value!.isLiked.value) {
        likepost(controller.post.value!.id, LikeType.post);
        controller.lastIsLiked = controller.post.value!.isLiked.value;
      }
    });
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: controller.post.value!.user,
            userid: controller.post.value!.user.userid,
            realname: controller.post.value!.user.realName),
        preventDuplicates: false);
  }
}
