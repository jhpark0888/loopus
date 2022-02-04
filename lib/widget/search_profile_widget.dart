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
  User user;
  SearchProfileWidget({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // profileController.isProfileLoading(true);

          Get.to(() => OtherProfileScreen(
                userid: user.userid,
                isuser: user.isuser!,
                realname: user.realName,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              (user.profileImage == null)
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
                        imageUrl: user.profileImage!,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: const Color(0xffe7e7e7),
                          child: Container(),
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
                      '${user.realName}',
                      style: kSubTitle2Style,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${user.department}',
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
