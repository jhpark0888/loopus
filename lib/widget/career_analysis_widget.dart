import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopus/constant.dart';

class CareerAnalysisWidget extends StatelessWidget {
  CareerAnalysisWidget({
    Key? key,
    required this.field,
    required this.groupRatio,
    // required this.schoolRatio,
    this.lastgroupRatio = 0.0,
    // this.lastschoolRatio = 0.0
  }) : super(key: key);

  String field;
  double groupRatio;
  double lastgroupRatio;
  // double schoolRatio;
  // double lastschoolRatio;

  @override
  Widget build(BuildContext context) {
    return
        // Row(
        //   children: [
        // Expanded(
        //   child: RichText(
        //       text: TextSpan(children: [
        //     TextSpan(text: field, style: MyTextTheme.main(context).copyWith(color: AppColors.mainblue)),
        //     const TextSpan(text: ' 분야', style: MyTextTheme.main(context))
        //   ])),
        // ),
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('상위 ${(groupRatio * 100).toInt()}%',
            style: MyTextTheme.main(context)),
        const SizedBox(width: 8),
        rate(context, ((groupRatio) * 100).toInt(),
            ((lastgroupRatio) * 100).toInt()),
      ],
    );
    // Expanded(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text('교내 ${(schoolRatio * 100).toInt()}%', style: MyTextTheme.main(context)),
    //       rate(((schoolRatio - lastschoolRatio) * 100).toInt()),
    //     ],
    //   ),
    // )
    //   ],
    // );
  }

  Widget rate(BuildContext context, int _groupRatio, int variance) {
    if (variance != 0) {
      return Row(children: [
        arrowDirection(variance),
        const SizedBox(width: 3),
        Text(
            '${variance == 100 ? variance.abs() - _groupRatio.abs() : variance.abs()}%',
            style: MyTextTheme.caption(context).copyWith(
                color: variance >= 1 ? AppColors.rankred : AppColors.rankblue)),
        const SizedBox(width: 8)
      ]);
    } else {
      return const SizedBox.shrink();
    }
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
