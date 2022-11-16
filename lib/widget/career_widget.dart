import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/duration_calculate.dart';
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
                memberList(context),
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

  Widget memberImage(Person user, int index) {
    return Container(
        width: 24,
        height: 24,
        margin: EdgeInsets.only(left: (17 * index).toDouble()),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.dividegray),
            shape: BoxShape.circle),
        child: UserImageWidget(
          imageUrl: user.profileImage,
          width: 24,
          height: 24,
          userType: user.userType,
        ));
  }

  Widget memberList(BuildContext context) {
    List<Person> memberList = career.members.length > 3
        ? career.members.sublist(0, 3)
        : career.members;

    return career.members.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: memberList
                    .asMap()
                    .entries
                    .map((entry) => memberImage(entry.value, entry.key))
                    .toList(),
              ),
              const SizedBox(
                width: 7,
              ),
              if (career.members.length > 3)
                Text(
                  "+${career.members.length - 3}",
                  style: MyTextTheme.main(context).copyWith(
                      color: career.thumbnail == ""
                          ? AppColors.mainblack
                          : AppColors.mainWhite),
                )
            ],
          )
        : Container();
  }
}
