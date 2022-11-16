import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopus/constant.dart';

class EmptyPostWidget extends StatelessWidget {
  EmptyPostWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset('assets/icons/career_post_add.svg'),
      const SizedBox(width: 7),
      Text(
        '지금 바로 새로운 포스트를 작성해보세요',
        style:
            MyTextTheme.mainbold(context).copyWith(color: AppColors.mainblue),
      )
    ]);
  }
}
