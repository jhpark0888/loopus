import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/follow_button_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class UserTileWidget extends StatelessWidget {
  UserTileWidget(
      {Key? key,
      required this.user,
      this.isFollowButton = false,
      this.isDark = false})
      : super(key: key);

  User user;
  bool isFollowButton;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.userType == UserType.student) {
          Get.to(
            () => OtherProfileScreen(
                user: user as Person, userid: user.userId, realname: user.name),
            preventDuplicates: false,
          );
        } else {
          if (user.userId != 0) {
            Get.to(
                () => OtherCompanyScreen(
                      company: user as Company,
                      companyId: user.userId,
                      companyName: user.name,
                    ),
                preventDuplicates: false);
          }
        }
      },
      behavior: HitTestBehavior.translucent,
      // splashColor: kSplashColor,
      child: Row(
        children: [
          UserImageWidget(
            imageUrl: user.profileImage,
            width: 36,
            height: 36,
            userType: user.userType,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style:
                        kmainbold.copyWith(color: isDark ? mainWhite : null)),
                const SizedBox(height: 4),
                user.userType == UserType.student
                    ? Text(
                        '${(user as Person).univName} · ${(user as Person).department}',
                        style: kmain.copyWith(color: isDark ? mainWhite : null))
                    : Text(
                        "${fieldList[(user as Company).fieldId]} · ${(user as Company).address}",
                        style: kmain.copyWith(color: isDark ? mainWhite : null),
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
          if (isFollowButton) FollowButtonWidget(user: user)
        ],
      ),
    );
  }
}
