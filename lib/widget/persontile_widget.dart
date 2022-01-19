import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        profileController.isProfileLoading(true);
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
                    ? Image.asset(
                        "assets/illustrations/default_profile.png",
                        width: 56,
                        height: 56,
                      )
                    : CachedNetworkImage(
                        height: 56,
                        width: 56,
                        imageUrl: user.profileImage!,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: const Color(0xffe7e7e7),
                          child: Container(),
                        ),
                        fit: BoxFit.cover,
                      )),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.realName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  user.department,
                  style: TextStyle(
                    fontSize: 16,
                    color: mainblack.withOpacity(0.6),
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
