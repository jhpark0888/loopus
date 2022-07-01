import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: lightcardgray),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(isUniversity ? '교내' : '전국',
                  style: k15normal.copyWith(fontWeight: FontWeight.w600)),
                // Flexible(child: const Spacer()),  
                // const Spacer(),
              // Text('전체보기', style: k15normal.copyWith(color: mainblue))
            ],
          ),
          const SizedBox(height: 20),
          personRankWidget(User(
              userid: 3,
              realName: '김원우',
              type: 1,
              department: '산업경영공',
              loopcount: 0.obs,
              totalposting: 1,
              isuser: 0,
              profileImage:
                  'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202203/23/d58e7390-afda-42cd-9374-ca327df1cad8.jpg',
              profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
              looped: FollowState.follower.obs,
              banned: BanState.normal.obs,
              field: '노멀')),
              const SizedBox(height: 20),
          personRankWidget(User(
              userid: 3,
              realName: '한근형',
              type: 1,
              department: '융합특성화자유전공학부',
              loopcount: 0.obs,
              totalposting: 1,
              isuser: 0,
              profileImage:
                  'http://www.footballist.co.kr/news/photo/201405/9983_15159_0541.jpg',
              profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
              looped: FollowState.follower.obs,
              banned: BanState.normal.obs,
              field: '노멀')),
              const SizedBox(height: 20),
          personRankWidget(User(
              userid: 3,
              realName: '박지성',
              type: 1,
              department: '산업경영공',
              loopcount: 0.obs,
              totalposting: 1,
              isuser: 0,
              profileImage:
                  'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202110/04/b9651a63-1ba7-4ee3-bbe8-3c83fbc1f71f.jpg',
              profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
              looped: FollowState.follower.obs,
              banned: BanState.normal.obs,
              field: '노멀'))
        ],
      ),
    );
  }

  Widget personRankWidget(User user) {
    return Row(children: [
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
          '1',
          style: k15normal.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3),
        rate(2)
      ]),
      const SizedBox(width: 14),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인천대 ${user.department}', style: k15normal),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '최근 포스트 ',
                  style: k15normal.copyWith(color: maingray.withOpacity(0.5))),
              TextSpan(
                  text: '${user.totalposting.toString()}개', style: k15normal)
            ]),
            textAlign: TextAlign.start,
          )
        ],
      )
    ]);
  }

  Widget rate(int variance) {
    return Row(children: [
      const SizedBox(width: 4),
      arrowDirection(variance),
      const SizedBox(width: 2),
      if (variance != 0)
        Text('${variance.abs()}',
            style:
                kcaption.copyWith(color: variance >= 1 ? rankred : mainblue)),
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
