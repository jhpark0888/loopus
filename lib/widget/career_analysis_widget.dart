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
    return Row(
      children: [
        Expanded(
          child: RichText(
              text: TextSpan(children: [
            TextSpan(text: field, style: kmain.copyWith(color: mainblue)),
            const TextSpan(text: ' 분야', style: kmain)
          ])),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('전국 ${(groupRatio * 100).toInt()}%', style: kmain),
              rate(((groupRatio - lastgroupRatio) * 100).toInt()),
            ],
          ),
        ),
        // Expanded(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text('교내 ${(schoolRatio * 100).toInt()}%', style: kmain),
        //       rate(((schoolRatio - lastschoolRatio) * 100).toInt()),
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      arrowDirection(variance),
      const SizedBox(width: 3),
      if (variance != 0)
        Text('${variance.abs()}%',
            style:
                kcaption.copyWith(color: variance >= 1 ? rankred : mainblue)),
      const SizedBox(width: 8)
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
