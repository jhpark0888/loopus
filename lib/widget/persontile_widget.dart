import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';

class PersonTileWidget extends StatelessWidget {
  PersonTileWidget({
    required this.user,
  });

  final ProfileController profileController = Get.put(ProfileController());
  final User user;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: user.userid.toString());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: () async {
        Get.to(() => OtherProfileScreen(
              userid: user.userid,
              isuser: user.isuser!,
              realname: user.realName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: user.profileImage == null
                  ? Obx(() => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: Image.asset(
                          "assets/illustrations/default_profile.png",
                          width: 50,
                          height: 50,
                        ),
                      ))
                  : Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: user.profileImage!,
                          placeholder: (context, url) => kProfilePlaceHolder(),
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
                    user.realName,
                    style: kSubTitle2Style.copyWith(
                        color: _hoverController.isHover.value
                            ? mainblack.withOpacity(0.6)
                            : mainblack),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Obx(
                  () => Text(
                    user.department,
                    style: kSubTitle3Style.copyWith(
                      color: _hoverController.isHover.value
                          ? mainblack.withOpacity(0.38)
                          : mainblack.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
