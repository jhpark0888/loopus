import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/realtime_rank_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/widget/follow_button_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_widget.dart';

class CareerRankWidget extends StatelessWidget {
  CareerRankWidget(
      {Key? key,
      required this.isUniversity,
      required this.ranker,
      required this.currentField})
      : super(key: key);
  bool isUniversity;
  List<Person> ranker;
  MapEntry<String, String> currentField;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 302,
      // height: 340,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(color: AppColors.mainWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Text(isUniversity ? '교내' : '전국', style: MyTextTheme.mainbold(context)),
          //     GestureDetector(
          //         onTap: () {
          //           Get.to(() => RealTimeRankScreen(
          //                 currentField: currentField,
          //                 isUniversity: isUniversity,
          //               ));
          //         },
          //         child: Text('전체보기', style: MyTextTheme.main(context).copyWith(color: AppColors.mainblue)))
          //   ],
          // ),
          // const SizedBox(height: 24),
          if (ranker.isNotEmpty)
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => PersonRankWidget(
                      user: ranker[index],
                      isUniversity: isUniversity,
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 24,
                    ),
                itemCount: min(3, ranker.length))
          else
            Expanded(
              child: Center(
                child: Text(
                  "실시간 순위 변동이 없습니다",
                  style: MyTextTheme.main(context),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PersonRankWidget extends StatelessWidget {
  PersonRankWidget({Key? key, required this.isUniversity, required this.user})
      : super(key: key);
  Person user;
  bool isUniversity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(
                user: user, userid: user.userId, realname: user.name),
            preventDuplicates: false);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(children: [
        SizedBox(
          width: 40,
          height: 42,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              isUniversity ? user.schoolRank.toString() : user.rank.toString(),
              style: MyTextTheme.mainbold(context),
            ),
            const SizedBox(height: 8),
            rate(context,
                rank: isUniversity ? user.schoolRank : user.rank,
                lastRank: isUniversity ? user.schoolLastRank : user.lastRank)
          ]),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          height: 64,
          child: UserVerticalWidget(
            user: user,
            emptyHeight: 4,
            imageHeight: 36,
            imageWidth: 36,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.univName != "" ? user.univName : '대학교',
                style: MyTextTheme.main(context),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                user.department,
                style: MyTextTheme.main(context),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: '최근 포스트 ',
                      style: MyTextTheme.main(context)
                          .copyWith(color: AppColors.maingray)),
                  TextSpan(
                      text: '${user.resentPostCount.toString()}개',
                      style: MyTextTheme.main(context))
                ]),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
        // 나 일때는 팔로우 버튼 없어야 함
        //지금은 is_user를 안 주는 듯
        FollowButtonWidget(user: user)
      ]),
    );
  }

  Widget rate(BuildContext context,
      {required int rank, required int lastRank}) {
    int variance = rank - lastRank;
    if (variance != 0) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        arrowDirection(variance, lastRank),
        const SizedBox(width: 2),
        // 양수: 파랑, 음수: 빨강
        Text(lastRank != 0 ? '${variance.abs()}' : "NEW",
            style: MyTextTheme.caption(context).copyWith(
                color: lastRank == 0
                    ? AppColors.rankred
                    : variance > 0
                        ? AppColors.rankblue
                        : AppColors.rankred)),
      ]);
    } else {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          color: AppColors.mainblack,
          height: 2,
          width: 6,
        )
      ]);
    }
  }

  Widget arrowDirection(int variance, int lastRank) {
    if (lastRank == 0) {
      return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
    }
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance < 0) {
      // 음수
      return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
    } else {
      // 양수
      return SvgPicture.asset('assets/icons/rate_down_arrow.svg');
    }
  }
}
