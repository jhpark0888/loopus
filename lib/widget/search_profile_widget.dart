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
  SearchProfileWidget({
    required this.name,
    required this.id,
    required this.department,
    required this.profileimage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // profileController.isProfileLoading(true);

          // Get.to(() => OtherProfileScreen(
          //       userid: id,
          //     ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              (profileimage == null)
                  ? ClipOval(
                      child: Image.asset(
                        "assets/illustrations/default_profile.png",
                        height: 50,
                        width: 50,
                      ),
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
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name',
                      style: kSubTitle2Style,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '$department',
                      style: kSubTitle3Style.copyWith(
                        color: mainblack.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
