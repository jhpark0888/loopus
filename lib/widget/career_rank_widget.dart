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
      width: 302,
      // height: 340,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: mainWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(isUniversity ? '교내' : '전국', style: kmainbold),
              GestureDetector(
                  onTap: () {
                    Get.to(() => RealTimeRankScreen(
                          currentField: currentField,
                          isUniversity: isUniversity,
                        ));
                  },
                  child: Text('전체보기', style: kmain.copyWith(color: mainblue)))
            ],
          ),
          const SizedBox(height: 24),
          if (ranker.isNotEmpty)
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => PersonRankWidget(
                      user: ranker[index],
                      isUniversity: isUniversity,
                      isFollow: false,
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 24,
                    ),
                itemCount: min(3, ranker.length))
          else
            const Expanded(
              child: Center(
                child: Text(
                  "실시간 순위 변동이 없습니다",
                  style: kmain,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PersonRankWidget extends StatelessWidget {
  PersonRankWidget(
      {Key? key,
      required this.isUniversity,
      required this.user,
      required this.isFollow})
      : super(key: key);
  Person user;
  bool isUniversity;
  bool isFollow;

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
          width: 50,
          height: 58,
          child: Column(
            children: [
              UserImageWidget(
                imageUrl: user.profileImage,
                width: 36,
                height: 36,
                userType: user.userType,
              ),
              const SizedBox(height: 8),
              Text(
                user.name,
                style: kmain,
                maxLines: 1,
              )
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 30,
          height: 33,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              isUniversity ? user.schoolRank.toString() : user.rank.toString(),
              style: kmainbold,
            ),
            const SizedBox(height: 8),
            rate(
                rank: isUniversity ? user.schoolRank : user.rank,
                lastRank: isUniversity ? user.schoolLastRank : user.lastRank)
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.univName != "" ? user.univName : '대학교',
                style: kmain,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                user.department,
                style: kmain,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: '최근 포스트 ', style: kmain.copyWith(color: maingray)),
                  TextSpan(
                      text: '${user.resentPostCount.toString()}개', style: kmain)
                ]),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
        // 나 일때는 팔로우 버튼 없어야 함
        //지금은 is_user를 안 주는 듯
        if (isFollow) FollowButtonWidget(user: user)
      ]),
    );
  }

  Widget rate({required int rank, required int lastRank}) {
    int variance = rank - lastRank;
    return Row(children: [
      const SizedBox(width: 4),
      arrowDirection(variance),
      const SizedBox(width: 2),
      if (variance != 0)
        Text(lastRank != 0 ? '${variance.abs()}' : "NEW",
            style:
                kcaption.copyWith(color: variance >= 1 ? rankred : rankblue)),
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/rate_down_arrow.svg');
    }
  }
}
