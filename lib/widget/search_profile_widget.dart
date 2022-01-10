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

class SearchProfileWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  int id;
  String name;
  String department;
  var profileimage;
  SearchProfileWidget(
      {required this.name,
      required this.id,
      required this.department,
      required this.profileimage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await getProfile(id).then((response) {
          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          profileController.myUserInfo(User.fromJson(responseBody));

          List projectmaplist = responseBody['project'];
          profileController.projectlist(projectmaplist
              .map((project) => Project.fromJson(project))
              .map((project) => ProjectWidget(
                    project: project.obs,
                  ))
              .toList());
        });
        AppController.to.ismyprofile.value = false;
        print(AppController.to.ismyprofile.value);
        Get.to(() => OtherProfileScreen());
      },
      leading: profileimage == null
          ? ClipOval(
              child: Image.asset("assets/illustrations/default_profile.png"),
            )
          : ClipOval(
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: profileimage,
                placeholder: (context, url) => const CircleAvatar(
                  child: Center(child: CircularProgressIndicator()),
                ),
                fit: BoxFit.fill,
              ),
            ),
      title: Text(
        '$name',
        style: kSubTitle2Style,
      ),
      subtitle: Text(
        '$department',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: mainblack.withOpacity(0.6),
          fontFamily: 'Nanum',
        ),
      ),
    );
  }
}
