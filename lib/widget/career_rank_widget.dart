import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/realtime_rank_screen.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class CareerRankWidget extends StatelessWidget {
  CareerRankWidget(
      {Key? key,
      required this.isUniversity,
      required this.ranker,
      required this.currentField})
      : super(key: key);
  bool isUniversity;
  List<User> ranker;
  MapEntry<String, String> currentField;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: lightcardgray),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(isUniversity ? '교내' : '전국',
                  style: kmain),
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
          const SizedBox(height: 18.33),
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
                      height: 18.33,
                    ),
                itemCount: ranker.length > 3 ? 3 : ranker.length)
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

  User user;
  bool isUniversity;
  bool isFollow;

  @override
  Widget build(BuildContext context) {
    print(user.schoolRank);
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(
                user: user, userid: user.userid, realname: user.realName),
            preventDuplicates: false);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(children: [
        Column(
          children: [
            PersonImageWidget(user: user, width: 52),
            const SizedBox(height: 7),
            Text(
              user.realName,
              style: kmain,
            )
          ],
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            isUniversity ? user.schoolRank.toString() : user.rank.toString(),
            style: kmainbold.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          rate(
              rank: isUniversity ? user.schoolRank : user.rank,
              lastRank: isUniversity ? user.schoolLastRank : user.lastRank)
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.univ != "" ? user.univ : '땡땡대',
                style: kmain,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              Text(
                user.department,
                style: kmain,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: '최근 포스트 ',
                      style: kmain.copyWith(color: maingray.withOpacity(0.5))),
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
        if (isFollow && user.userid != HomeController.to.myProfile.value.userid)
          Obx(
            () => Row(children: [
              const SizedBox(
                width: 14,
              ),
              GestureDetector(
                onTap: () {
                  user.looped.value = user.looped.value == FollowState.normal
                      ? FollowState.following
                      : user.looped.value == FollowState.follower
                          ? FollowState.wefollow
                          : user.looped.value == FollowState.following
                              ? FollowState.normal
                              : FollowState.follower;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                      color: user.looped.value == FollowState.normal ||
                              user.looped.value == FollowState.follower
                          ? mainblue
                          : cardGray,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      user.looped.value == FollowState.normal ||
                              user.looped.value == FollowState.follower
                          ? "팔로우"
                          : "팔로잉",
                      style: kmain.copyWith(
                          color: user.looped.value == FollowState.normal ||
                                  user.looped.value == FollowState.follower
                              ? mainWhite
                              : mainblack),
                    ),
                  ),
                ),
              )
            ]),
          )
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
