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
    Key? key,
    required this.user,
  }) : super(key: key);

  ProfileController profileController = Get.put(ProfileController());
  User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await getProfile(user.user).then((user) async {
          profileController.otherUser(user);
          profileController.isProfileLoading.value = false;
        });
        await getProjectlist(user.user).then((projectlist) {
          profileController.otherProjectList(projectlist
              .map((project) => ProjectWidget(
                    project: project.obs,
                  ))
              .toList());
        });

        AppController.to.ismyprofile.value = false;
        print(AppController.to.ismyprofile.value);
        Get.to(() => OtherProfileScreen());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
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
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        fit: BoxFit.fill,
                      )),
            SizedBox(
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
