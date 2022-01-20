import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';

import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';

import 'package:loopus/model/post_model.dart';

import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';

import 'package:loopus/widget/tag_widget.dart';

class PostingWidget extends StatelessWidget {
  // final int index;
  Post item;

  PostingWidget({required this.item, Key? key}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());
  // final HoverController _hoverController = Get.put(HoverController());
  // final PostingDetailController postingDetailController =
  //     Get.put(PostingDetailController());

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown: (details) => _hoverController.isHoverState(),
      // onTapCancel: () => _hoverController.isNonHoverState(),
      // onTapUp: (details) => _hoverController.isNonHoverState(),
      onTap: tapPosting,
      child: Column(
        children: [
          Container(
            decoration: kCardStyle,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: (item.thumbnail == null)
                      ? Image.asset(
                          "assets/illustrations/default_image.png",
                          height: Get.width / 2 * 1,
                          width: Get.width,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          height: Get.width / 2 * 1,
                          width: Get.width,
                          imageUrl: item.thumbnail,
                          placeholder: (context, url) => Container(
                            color: const Color(0xffe7e7e7),
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: Container(
                        color: mainWhite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${item.title}",
                                style: kHeaderH2Style,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "${item.project!.projectName}",
                                style: kSubTitle2Style.copyWith(
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              postingTag(),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: tapProfile,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              child: ClipOval(
                                                child: item.profileimage == null
                                                    ? Image.asset(
                                                        "assets/illustrations/default_profile.png")
                                                    : CachedNetworkImage(
                                                        height: 32,
                                                        width: 32,
                                                        imageUrl:
                                                            "${item.profileimage}",
                                                        placeholder:
                                                            (context, url) =>
                                                                CircleAvatar(
                                                          backgroundColor:
                                                              Color(0xffe7e7e7),
                                                          child: Container(),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text("${item.realname} · ",
                                                style: kButtonStyle),
                                          ],
                                        ),
                                      ),
                                      Text("${item.department}",
                                          style: kBody2Style),
                                    ],
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        InkWell(
                                          onTap: tapLike,
                                          child: item.isLiked.value == 0
                                              ? SvgPicture.asset(
                                                  "assets/icons/Favorite_Inactive.svg")
                                              : SvgPicture.asset(
                                                  "assets/icons/Favorite_Active.svg"),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "${item.likeCount.value}",
                                          style: kButtonStyle,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                          onTap: tapBookmark,
                                          child: (item.isMarked.value == 0)
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postingTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: item.project!.projectTag
          .map((tag) => Row(children: [
                Tagwidget(
                  tag: tag,
                  fontSize: 12,
                ),
                item.project!.projectTag.indexOf(tag) !=
                        item.project!.projectTag.length - 1
                    ? const SizedBox(
                        width: 4,
                      )
                    : Container()
              ]))
          .toList(),
    );
  }

  void tapPosting() {
    Get.to(
      () => PostingScreen(
          userid: item.userid,
          isuser: item.isuser,
          postid: item.id,
          title: item.title,
          realName: item.realname,
          department: item.department,
          postDate: item.date,
          profileImage: item.profileimage,
          thumbNail: item.thumbnail,
          likecount: item.likeCount,
          isLiked: item.isLiked,
          isMarked: item.isMarked),
    );
  }

  void tapBookmark() {
    if (item.isMarked.value == 0) {
      homeController.tapBookmark(item.id);
      ModalController.to.showCustomDialog('북마크 탭에 저장했어요', 1000);
    } else {
      homeController.tapunBookmark(item.id);
      ModalController.to.showCustomDialog('북마크 탭에서 삭제했어요', 1000);
    }
  }

  void tapLike() {
    if (item.isLiked.value == 0) {
      item.likeCount += 1;
      homeController.tapLike(item.id, item.likeCount.value);
    } else {
      item.likeCount -= 1;
      homeController.tapunLike(item.id, item.likeCount.value);
    }
  }

  void tapProfile() {
    Get.to(() => OtherProfileScreen(
          userid: item.userid,
          isuser: item.isuser,
          realname: item.realname,
        ));
  }
}
