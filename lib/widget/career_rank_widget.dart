import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class CareerRankWidget extends StatelessWidget {
  CareerRankWidget({Key? key, required this.isUniversity}) : super(key: key);
  bool isUniversity;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: maingray.withOpacity(0.4)),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                isUniversity ? '교내' : '전국',
                style: k15normal.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text('전체보기', style: k15normal.copyWith(color: mainblue))
            ],
          ),
          const SizedBox(height: 20),
          PersonImageWidget(
            user: User(
                userid: 3,
                realName: '김원우',
                type: 1,
                department: '산경',
                loopcount: 0.obs,
                totalposting: 1,
                isuser: 0,
                field: "노멀",
                profileImage:
                    'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202203/23/d58e7390-afda-42cd-9374-ca327df1cad8.jpg',
                profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
                looped: FollowState.follower.obs,
                banned: BanState.normal.obs),
          )
        ],
      ),
    );
  }
}
