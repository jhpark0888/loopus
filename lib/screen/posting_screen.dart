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

// class PostingScreen extends StatelessWidget {
//   PostingScreen({
//     Key? key,
//     required this.userid,
//     required this.isuser,
//     required this.postid,
//     required this.title,
//     required this.realName,
//     required this.department,
//     required this.postDate,
//     required this.profileImage,
//     required this.thumbNail,
//     required this.likecount,
//     required this.isLiked,
//     required this.isMarked,
//   }) : super(key: key);
//   late PostingDetailController controller =
//       Get.put(PostingDetailController(postid), tag: postid.toString());
//   late final LikeController likeController = Get.put(
//       LikeController(isliked: isLiked, id: postid, lastisliked: isLiked.value),
//       tag: postid.toString());

//   final ScrollController _controller = ScrollController();
//   // final TransitionAnimationController _transitionAnimationController =
//   // Get.put(TransitionAnimationController());

//   int userid;
//   int isuser;
//   int postid;
//   String title;
//   String realName;
//   dynamic profileImage;
//   DateTime postDate;
//   String department;
//   dynamic thumbNail;
//   RxInt likecount;
//   RxInt isLiked;
//   RxInt isMarked;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Stack(children: [
//         Scaffold(
//           bottomNavigationBar: BottomAppBar(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               height: kBottomNavigationBarHeight,
//               decoration: const BoxDecoration(
//                 color: mainWhite,
//                 border: Border(
//                   top: BorderSide(
//                     width: 1,
//                     color: Color(0xffe7e7e7),
//                   ),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Obx(() => InkWell(
//                       onTap: () {
//                         if (isLiked.value == 0) {
//                           likeController.isliked(1);
//                           likecount += 1;

//                           HomeController.to.tapLike(postid, likecount.value);
//                           isLiked(1);
//                         } else {
//                           likeController.isliked(0);
//                           likecount -= 1;
//                           HomeController.to.tapunLike(postid, likecount.value);

//                           isLiked(0);
//                         }
//                       },
//                       child: isLiked.value == 0
//                           ? SvgPicture.asset(
//                               "assets/icons/Favorite_Inactive.svg")
//                           : SvgPicture.asset(
//                               "assets/icons/Favorite_Active.svg"))),
//                   const SizedBox(
//                     width: 4,
//                   ),
//                   Obx(
//                     () => GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () {
//                         Get.to(() => LikePeopleScreen(
//                               postid: postid,
//                             ));
//                       },
//                       child: Text(
//                         likecount != 0 ? "${likecount}     \u200B" : ' \u200B',
//                         style: kButtonStyle,
//                       ),
//                     ),
//                   ),
//                   Obx(
//                     () => SizedBox(
//                       width: likecount != 0 ? 4 : 8,
//                     ),
//                   ),
//                   Obx(() => InkWell(
//                       onTap: () {
//                         if (isMarked.value == 0) {
//                           HomeController.to.tapBookmark(postid);
//                           isMarked(1);
//                         } else {
//                           HomeController.to.tapunBookmark(postid);
//                           isMarked(0);
//                         }
//                       },
//                       child: isMarked.value == 0
//                           ? SvgPicture.asset("assets/icons/Mark_Default.svg")
//                           : SvgPicture.asset("assets/icons/Mark_Saved.svg")))
//                 ],
//               ),
//             ),
//           ),
//           body: GestureDetector(
//             onTap: () {},
//             // },
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               controller: _controller,
//               slivers: [
//                 SliverAppBar(
//                   stretch: true,
//                   bottom: PreferredSize(
//                       child: Container(
//                         color: const Color(0xffe7e7e7),
//                         height: 1,
//                       ),
//                       preferredSize: const Size.fromHeight(4.0)),
//                   automaticallyImplyLeading: false,
//                   elevation: 0,
//                   backgroundColor: Colors.white,
//                   leading: IconButton(
//                     onPressed: () => Get.back(),
//                     icon: SvgPicture.asset('assets/icons/Arrow.svg'),
//                   ),
//                   actions: [
//                     isuser == 1
//                         ? IconButton(
//                             onPressed: () {
//                               // Get.to(
//                               //   () => PostingModifyScreen(
//                               //     postid: controller.postid,
//                               //   ),
//                               // );
//                             },
//                             icon: SvgPicture.asset('assets/icons/Edit.svg'),
//                           )
//                         : Container(),
//                     IconButton(
//                       onPressed: isuser == 1
//                           ? () {
//                               showModalIOS(
//                                 context,
//                                 func1: () {
//                                   showButtonDialog(
//                                       leftText: '취소',
//                                       rightText: '삭제',
//                                       title:
//                                           '<${controller.post.value.content}> 포스팅을 삭제하시겠어요?',
//                                       content: '삭제한 포스팅은 복구할 수 없어요',
//                                       leftFunction: () => Get.back(),
//                                       rightFunction: () async {
//                                         controller.isPostDeleteLoading(true);
//                                         getbacks(2);
//                                         await deleteposting(
//                                                 controller.post.value.id,
//                                                 controller
//                                                     .post.value.project!.id)
//                                             .then((value) {
//                                           controller.isPostDeleteLoading(false);
//                                         });
//                                       });
//                                 },
//                                 func2: () {},
//                                 value1: '이 포스팅 삭제하기',
//                                 value2: '',
//                                 isValue1Red: true,
//                                 isValue2Red: false,
//                                 isOne: true,
//                               );
//                             }
//                           : () {
//                               showModalIOS(
//                                 context,
//                                 func1: () {
//                                   showButtonDialog(
//                                       leftText: '취소',
//                                       rightText: '신고',
//                                       title:
//                                           '정말 <${controller.post.value.content}> 포스팅을 신고하시겠어요?',
//                                       content: '관리자가 검토 절차를 거칩니다',
//                                       leftFunction: () => Get.back(),
//                                       rightFunction: () {
//                                         postingreport(controller.post.value.id);
//                                       });
//                                 },
//                                 func2: () {},
//                                 value1: '이 포스팅 신고하기',
//                                 value2: '',
//                                 isValue1Red: true,
//                                 isValue2Red: false,
//                                 isOne: true,
//                               );
//                             },
//                       icon: SvgPicture.asset(
//                         'assets/icons/More.svg',
//                       ),
//                     ),
//                   ],
//                   pinned: true,
//                   flexibleSpace: Obx(
//                     () => controller.post.value.id == 0
//                         ? _MyAppSpace(
//                             id: postid,
//                             title: title,
//                             realname: realName,
//                             profileImage: profileImage,
//                             postDate: postDate,
//                             department: department,
//                             thumbnail: thumbNail,
//                             isuser: isuser,
//                             userid: userid,
//                           )
//                         : _MyAppSpace(
//                             id: controller.post.value.id,
//                             title: controller.post.value.content,
//                             realname: realName,
//                             profileImage: profileImage,
//                             postDate: controller.post.value.date,
//                             department: department,
//                             thumbnail: controller.post.value.images[0],
//                             isuser: isuser,
//                             userid: userid,
//                           ),
//                   ),
//                   expandedHeight: Get.width / 3 * 2,
//                 ),
//                 SliverToBoxAdapter(
//                   child: Obx(() => (controller.postscreenstate.value ==
//                           ScreenState.loading)
//                       ? Image.asset(
//                           'assets/icons/loading.gif',
//                           scale: 9,
//                         )
//                       : controller.postscreenstate.value ==
//                               ScreenState.disconnect
//                           ? Column(
//                               children: [
//                                 SizedBox(
//                                   height: 24,
//                                 ),
//                                 DisconnectReloadWidget(reload: () {
//                                   getposting(controller.postid);
//                                 }),
//                               ],
//                             )
//                           : controller.postscreenstate.value ==
//                                   ScreenState.error
//                               ? ErrorReloadWidget(reload: () {
//                                   getposting(controller.postid);
//                                 })
//                               : Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                       // Obx(
//                                       //   () => Padding(
//                                       //       padding: const EdgeInsets.symmetric(
//                                       //         vertical: 24,
//                                       //       ),
//                                       //       child: Column(
//                                       //         children: controller
//                                       //             .postcontentlist.value,
//                                       //       )),
//                                       // ),
//                                       TextButton(
//                                         onPressed: tapOtherPosting,
//                                         child: Text(
//                                           '이 활동의 다른 포스팅 읽기',
//                                           style: kButtonStyle.copyWith(
//                                               color: mainblue),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 8,
//                                         color: Color(0xffF2F3F5),
//                                       ),
//                                       const Padding(
//                                         padding:
//                                             EdgeInsets.fromLTRB(16, 20, 16, 8),
//                                         child: Text(
//                                           '관련 포스팅',
//                                           style: kSubTitle2Style,
//                                         ),
//                                       ),
//                                       Column(
//                                         children: controller
//                                                 .recommendposts.isNotEmpty
//                                             ? controller.recommendposts
//                                             : [
//                                                 SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Text(
//                                                   '관련된 포스팅이 없어요',
//                                                   style:
//                                                       kSubTitle3Style.copyWith(
//                                                     color: mainblack
//                                                         .withOpacity(0.38),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 40,
//                                                 ),
//                                               ],
//                                       ),
//                                     ])),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (controller.isPostDeleteLoading.value == true)
//           Container(
//             height: Get.height,
//             width: Get.width,
//             color: mainblack.withOpacity(0.3),
//             child: Image.asset(
//               'assets/icons/loading.gif',
//               scale: 6,
//             ),
//           ),
//       ]),
//     );
//   }

//   void tapOtherPosting() {
//     Get.to(() => ProjectScreen(
//         projectid: controller.post.value.project!.id,
//         isuser: controller.post.value.isuser));
//   }
// }

// class _MyAppSpace extends StatelessWidget {
//   _MyAppSpace({
//     Key? key,
//     required this.id,
//     required this.title,
//     required this.realname,
//     required this.profileImage,
//     required this.postDate,
//     required this.department,
//     required this.thumbnail,
//     required this.isuser,
//     required this.userid,
//   }) : super(key: key);

//   String title;
//   String realname;
//   var profileImage;
//   DateTime postDate;
//   String department;
//   var thumbnail;
//   int id;
//   int isuser;
//   int userid;

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     return LayoutBuilder(
//       builder: (context, c) {
//         var top = c.biggest.height;

//         final settings = context
//             .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
//         final deltaExtent = settings!.maxExtent - settings.minExtent;
//         final t =
//             (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
//                 .clamp(0.0, 1.0) as double;
//         final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
//         const fadeEnd = 1.0;
//         final opacity1 = 1.0 - Interval(0.0, 0.75).transform(t);
//         final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
//         return Stack(
//           children: [
//             SafeArea(
//               child: Center(
//                 child: Opacity(
//                   opacity: 1 - opacity2,
//                   child: getCollapseTitle(
//                     title,
//                   ),
//                 ),
//               ),
//             ),
//             Opacity(
//               opacity: opacity1,
//               child: Stack(
//                 alignment: Alignment.bottomLeft,
//                 children: [
//                   getImage(thumbnail, 'thumbnail$id'),
//                   SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 32,
//                         ),
//                         getExpendTitle(title, 'title$id'),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Get.to(() => OtherProfileScreen(
//                                         userid: userid,
//                                         isuser: isuser,
//                                         realname: realname,
//                                       ));
//                                 },
//                                 child: Row(
//                                   children: [
//                                     (profileImage != null)
//                                         ? ClipOval(
//                                             child: CachedNetworkImage(
//                                               height: 32,
//                                               width: 32,
//                                               imageUrl: profileImage,
//                                               placeholder: (context, url) =>
//                                                   kProfilePlaceHolder(),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           )
//                                         : ClipOval(
//                                             child: Image.asset(
//                                               "assets/illustrations/default_profile.png",
//                                               height: 32,
//                                               width: 32,
//                                             ),
//                                           ),
//                                     SizedBox(
//                                       width: 8,
//                                     ),
//                                     Material(
//                                       type: MaterialType.transparency,
//                                       child: Text(
//                                         "$realname · ",
//                                         style: kButtonStyle,
//                                       ),
//                                     ),
//                                     Hero(
//                                       tag: 'department$id',
//                                       child: Material(
//                                         type: MaterialType.transparency,
//                                         child: Text(
//                                           department,
//                                           style: kBody2Style,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(
//                                 '${postDate.year}.${postDate.month}.${postDate.day}',
//                                 style: kBody2Style.copyWith(
//                                   color: mainblack.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget getImage(String? image, String heroThumbnailTag) {
//     return Hero(
//       tag: heroThumbnailTag,
//       child: Container(
//         width: Get.width,
//         height: Get.height,
//         child: Opacity(
//           opacity: image != null ? 0.25 : 1,
//           child: (image != null)
//               ? CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: image,
//                 )
//               : Image.asset(
//                   "assets/illustrations/default_image.png",
//                   fit: BoxFit.cover,
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget getExpendTitle(String text, String heroTitleTag) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//       ),
//       child: Hero(
//         tag: heroTitleTag,
//         child: Material(
//           type: MaterialType.transparency,
//           child: Text(
//             text,
//             textAlign: TextAlign.start,
//             style: kHeaderH2Style,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget getCollapseTitle(String text) {
//     return Container(
//       padding: EdgeInsets.only(right: isuser == 1 ? 100 : 60, left: 60),
//       child: Text(text,
//           textAlign: TextAlign.center,
//           softWrap: false,
//           overflow: TextOverflow.ellipsis,
//           style: kBody2Style),
//     );
//   }
// }

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

  final Debouncer _debouncer = Debouncer(
    milliseconds: 500,
  );

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
                                      dialogBack();
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
                              func2: () {},
                              value1: '이 포스팅 삭제하기',
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
                                          Row(
                                            children: [
                                              UserImageWidget(
                                                imageUrl: controller.post.value!
                                                        .user.profileImage ??
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        controller.post.value!
                                                            .user.realName,
                                                        style: k16semiBold),
                                                    Text(
                                                        controller.post.value!
                                                            .user.department,
                                                        style: kSubTitle3Style)
                                                  ])
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: GestureDetector(
                                              onTap: tapProjectname,
                                              child: Text(
                                                controller.post.value!.project!
                                                    .careerName,
                                                style: k16semiBold.copyWith(
                                                    color: maingray),
                                              ),
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
                                    SizedBox(
                                        height: Get.width,
                                        child: Swiper(
                                          loop: false,
                                          outer: true,
                                          itemCount: controller
                                                  .post.value!.images.isNotEmpty
                                              ? controller
                                                  .post.value!.images.length
                                              : controller
                                                  .post.value!.links.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (controller.post.value!.images
                                                .isNotEmpty) {
                                              return CachedNetworkImage(
                                                  imageUrl: controller.post
                                                      .value!.images[index],
                                                  fit: BoxFit.fill);
                                            } else {
                                              return LinkWidget(
                                                  url: controller
                                                      .post.value!.links[index],
                                                  widgetType: 'post');
                                            }
                                          },
                                          pagination: SwiperPagination(
                                              margin: EdgeInsets.all(14),
                                              alignment: Alignment.bottomCenter,
                                              builder:
                                                  DotSwiperPaginationBuilder(
                                                      color: Color(0xFF5A5A5A)
                                                          .withOpacity(0.5),
                                                      activeColor: mainblue,
                                                      size: 7,
                                                      activeSize: 7)),
                                        )),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(controller.post.value!.content,
                                                style: kSubTitle3Style.copyWith(
                                                    height: 1.5)),
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
                                                        .toList()),
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
                                                    Get.to(
                                                        () => LikePeopleScreen(
                                                              postid: controller
                                                                  .post
                                                                  .value!
                                                                  .id,
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

  void tapProjectname() {
    // Get.to(() => ProjectScreen(
    //       projectid: item.project!.id,
    //       isuser: item.isuser,
    //     ));
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
