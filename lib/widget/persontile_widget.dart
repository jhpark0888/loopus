import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';

import 'custom_expanded_button.dart';

class PersonTileWidget extends StatelessWidget {
  PersonTileWidget({
    required this.user,
  });

  final Person user;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: user.userId.toString());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: () async {
        Get.to(() => OtherProfileScreen(
              userid: user.userId,
              realname: user.name,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: user.profileImage == ""
                  ? Obx(() => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: Image.asset(
                          "assets/illustrations/default_profile.png",
                          width: 36,
                          height: 36,
                        ),
                      ))
                  : Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: user.profileImage,
                          placeholder: (context, url) => kProfilePlaceHolder(),
                          errorWidget: (context, string, widget) {
                            return Container(color: AppColors.maingray);
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    user.name,
                    style: MyTextTheme.main(context).copyWith(
                        color: _hoverController.isHover.value
                            ? AppColors.mainblack.withOpacity(0.6)
                            : AppColors.mainblack),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Obx(
                  () => Text(
                    "${user.univName} · ${user.department}",
                    style: MyTextTheme.main(context).copyWith(
                        // color: _hoverController.isHover.value
                        //     ? AppColors.mainblack.withOpacity(0.38)
                        //     : AppColors.mainblack.withOpacity(0.6),
                        ),
                  ),
                ),
                // CustomExpandedBoldButton(
                //           onTap: followMotion,
                //           isBlue: _controller.otherUser.value.followed.value ==
                //                       FollowState.follower ||
                //                   _controller.otherUser.value.followed.value ==
                //                       FollowState.normal ||
                //                   _controller.otherUser.value.banned ==
                //                       BanState.ban
                //               ? true
                //               : false,
                //           title: _controller.otherUser.value.banned ==
                //                   BanState.ban
                //               ? '차단 해제'
                //               : _controller.otherUser.value.followed.value ==
                //                       FollowState.normal
                //                   ? '팔로우'
                //                   : _controller
                //                               .otherUser.value.followed.value ==
                //                           FollowState.follower
                //                       ? '나도 팔로우하기'
                //                       : _controller.otherUser.value.followed
                //                                   .value ==
                //                               FollowState.following
                //                           ? '팔로우 중'
                //                           : '팔로우 중',
                //         ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
