import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:palette_generator/palette_generator.dart';

class CompanyListWidget extends StatelessWidget {
  CompanyListWidget(
      {Key? key,
      required this.contact,
      required this.user,
      required this.isFollow})
      : super(key: key);

  Contact contact;
  User user;
  bool isFollow;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(contact.category, style: MyTextTheme.mainbold(context)),
        SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: <Widget>[
                  Container(height: 167.5, width: 335, color: Colors.grey),
                  const SizedBox(height: 14),
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(width: 27),
                      UserImageWidget(
                        imageUrl: contact.companyImage,
                        width: 40,
                        height: 40,
                        userType: UserType.company,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          children: [
                            Text(contact.companyProfile.companyName,
                                style: MyTextTheme.main(context)),
                            SizedBox(height: 7),
                            Text(
                              contact.category,
                              style: MyTextTheme.mainheight(context)
                                  .copyWith(color: AppColors.maingray),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          user.followed.value = user.followed.value ==
                                  FollowState.normal
                              ? FollowState.following
                              : user.followed.value == FollowState.follower
                                  ? FollowState.wefollow
                                  : user.followed.value == FollowState.following
                                      ? FollowState.normal
                                      : FollowState.follower;
                        },
                        child: Container(
                          width: 64,
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                              color:
                                  user.followed.value == FollowState.normal ||
                                          user.followed.value ==
                                              FollowState.follower
                                      ? AppColors.mainblue
                                      : AppColors.cardGray,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              user.followed.value == FollowState.normal ||
                                      user.followed.value ==
                                          FollowState.follower
                                  ? "팔로우"
                                  : "팔로잉",
                              style: MyTextTheme.main(context).copyWith(
                                  color: user.followed.value ==
                                              FollowState.normal ||
                                          user.followed.value ==
                                              FollowState.follower
                                      ? AppColors.mainWhite
                                      : AppColors.mainblack),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
