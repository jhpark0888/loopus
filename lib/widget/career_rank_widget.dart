import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class CareerRankWidget extends StatelessWidget {
  CareerRankWidget({Key? key, required this.isUniversity, required this.ranker})
      : super(key: key);
  bool isUniversity;
  List<User> ranker;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 340,
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
                  style: k15normal.copyWith(fontWeight: FontWeight.w600)),
              GestureDetector(
                  onTap: () {},
                  child:
                      Text('전체보기', style: k15normal.copyWith(color: mainblue)))
            ],
          ),
          const SizedBox(height: 20),
          if (ranker.isNotEmpty)
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    personRankWidget(ranker[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
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
          // personRankWidget(ranker[0]),
          // const SizedBox(height: 20),
          // personRankWidget(ranker[1]),
          // const SizedBox(height: 20),
          // personRankWidget(ranker[2])
        ],
      ),
    );
  }

  Widget personRankWidget(User user) {
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
            PersonImageWidget(user: user),
            const SizedBox(height: 7),
            Text(
              user.realName,
              style: k15normal,
            )
          ],
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            user.rank.toString(),
            style: k15normal.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          rate(user.trend)
        ]),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.univ != "" ? user.univ : '땡땡대', style: k15normal),
            const SizedBox(height: 7),
            Text(user.department, style: k15normal),
            const SizedBox(height: 7),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '최근 포스트 ',
                    style:
                        k15normal.copyWith(color: maingray.withOpacity(0.5))),
                TextSpan(
                    text: '${user.resentPostCount.toString()}개',
                    style: k15normal)
              ]),
              textAlign: TextAlign.start,
            )
          ],
        )
      ]),
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      const SizedBox(width: 4),
      arrowDirection(variance),
      const SizedBox(width: 2),
      if (variance != 0)
        Text('${variance.abs()}',
            style:
                kcaption.copyWith(color: variance >= 1 ? rankred : rankblue)),
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/down_arrow.svg');
    }
  }
}
