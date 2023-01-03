import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/class_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/member_list_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CareerWidget extends StatelessWidget {
  CareerWidget({Key? key, required this.career}) : super(key: key);

  Project career;

  @override
  Widget build(BuildContext context) {
    return Hero(
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        final Widget toHero = toHeroContext.widget;
        return FadeTransition(
          opacity: animation.drive(
            Tween<double>(begin: 0.25, end: 0.25),
          ),
          child: toHero,
        );
      },
      tag: career.id.toString(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            color: career.thumbnail == "" ? AppColors.cardGray : null,
            borderRadius: BorderRadius.circular(8),
            image: career.thumbnail == ""
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider(career.thumbnail),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        const Color(0x00000000).withOpacity(0.4),
                        BlendMode.srcOver))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.careerName,
              style: MyTextTheme.mainbold(context).copyWith(
                  color: career.thumbnail == ""
                      ? AppColors.mainblack
                      : AppColors.mainWhite),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                career.isPublic
                    ? SvgPicture.asset('assets/icons/group_career.svg',
                        color: career.thumbnail == ""
                            ? AppColors.mainblack
                            : AppColors.mainWhite)
                    : SvgPicture.asset('assets/icons/single_career.svg',
                        color: career.thumbnail == ""
                            ? AppColors.mainblack
                            : AppColors.mainWhite),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  career.isPublic ? "그룹 커리어" : "개인 커리어",
                  style: MyTextTheme.main(context).copyWith(
                      color: career.thumbnail == ""
                          ? AppColors.mainblack
                          : AppColors.mainWhite),
                ),
                const SizedBox(
                  width: 8,
                ),
                CareerMemberListWidget(
                  members: career.members,
                  textColor: career.thumbnail == ""
                      ? AppColors.mainblack
                      : AppColors.mainWhite,
                  membersCount: career.members.length,
                ),
                const Spacer(),
                career.updateDate != null
                    ? Text(
                        "${lastPostCalculateDate(career.updateDate!)} 포스트",
                        style: MyTextTheme.main(context).copyWith(
                            color: career.thumbnail == ""
                                ? AppColors.mainblack
                                : AppColors.mainWhite),
                      )
                    : Container(
                        color: AppColors.mainblack,
                        height: 2,
                        width: 6,
                      ),
                // const Spacer(),
                // Row(
                //   children: [
                //     career.isPublic
                //         ? SvgPicture.asset('assets/icons/group.svg')
                //         : SvgPicture.asset('assets/icons/personal_career.svg'),
                //     const SizedBox(
                //       width: 7,
                //     ),
                //     Text(
                //       career.isPublic ? "그룹 커리어" : "개인 커리어",
                //       style: MyTextTheme.mainbold(context).copyWith(
                //           color: career.thumbnail == "" ? AppColors.mainblack : AppColors.mainWhite),
                //     ),
                //   ],
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SchoolClassWidget extends StatelessWidget {
  SchoolClassWidget({Key? key, required this.schoolClass}) : super(key: key);

  SchoolClass schoolClass;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 5,
            )
          ],
          color: AppColors.mainWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schoolClass.className,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.mainbold(context)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        schoolClass.classType,
                        style: MyTextTheme.main(context)
                            .copyWith(color: AppColors.maingray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CareerMemberListWidget(
                      members: schoolClass.member,
                      textColor: schoolClass.career.thumbnail == ""
                          ? AppColors.mainblack
                          : AppColors.mainWhite,
                      membersCount: schoolClass.memberCount,
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: schoolClass.career.thumbnail == ""
                      ? AppColors.cardGray
                      : null,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  image: schoolClass.career.thumbnail == ""
                      ? null
                      : DecorationImage(
                          image: CachedNetworkImageProvider(
                              schoolClass.career.thumbnail),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              const Color(0x00000000).withOpacity(0.4),
                              BlendMode.srcOver))),
              child: Center(
                  child: Text(
                "+${schoolClass.career.post_count!.value}개 최근 포스트",
                style: MyTextTheme.mainbold(context).copyWith(
                    color: schoolClass.career.thumbnail == ""
                        ? AppColors.mainblack
                        : AppColors.mainWhite),
              )),
            ),
          )
        ],
      ),
    );
  }
}

class NewCareerImage extends StatelessWidget {
  NewCareerImage({Key? key, required this.ispublic}) : super(key: key);

  bool ispublic;
  final List<Color> _colors = [
    const Color(0xFFB02020),
    AppColors.mainblue,
    const Color(0xFF21B677),
    const Color(0xFF881DBA),
    const Color(0xFFEBC12F),
    const Color(0xFFE08F31)
  ];

  int radIndex = Random().nextInt(6);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: _colors[radIndex]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/new_career_image${(radIndex + 1).toString()}.png",
            height: 32,
          ),
          const SizedBox(height: 4),
          Text(
            "새로운 ${ispublic ? "그룹" : "개인"} 커리어를 등록했어요",
            style:
                MyTextTheme.main(context).copyWith(color: AppColors.mainWhite),
          )
        ],
      ),
    );
  }
}
