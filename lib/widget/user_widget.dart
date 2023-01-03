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
      // splashColor: AppColors.kSplashColor,
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
                    style: MyTextTheme.mainbold(context)
                        .copyWith(color: isDark ? AppColors.mainWhite : null)),
                const SizedBox(height: 4),
                user.userType == UserType.student
                    ? Text(
                        '${(user as Person).univName} · ${(user as Person).department}',
                        style: MyTextTheme.main(context).copyWith(
                            color: isDark ? AppColors.mainWhite : null))
                    : Text(
                        "${fieldList[(user as Company).fieldId]} · ${(user as Company).address}",
                        style: MyTextTheme.main(context).copyWith(
                            color: isDark ? AppColors.mainWhite : null),
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

class UserVerticalWidget extends StatelessWidget {
  UserVerticalWidget({
    Key? key,
    required this.user,
    this.imageWidth,
    this.imageHeight,
    this.emptyHeight,
    this.isDark = false,
    this.isTap = false,
  }) : super(key: key);

  User user;
  double? imageWidth;
  double? imageHeight;
  double? emptyHeight;
  bool isDark;
  bool isTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.userType == UserType.student) {
          Get.to(
            () => OtherProfileScreen(
              user: user as Person,
              userid: user.userId,
              realname: user.name,
            ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserImageWidget(
              width: imageWidth,
              height: imageHeight,
              imageUrl: user.profileImage,
              userType: user.userType),
          SizedBox(
            height: emptyHeight ?? 7,
          ),
          Text(
            user.name,
            style: MyTextTheme.main(context)
                .copyWith(color: isDark ? AppColors.mainWhite : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
