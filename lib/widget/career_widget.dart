import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/project_model.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
            color: career.thumbnail == "" ? cardGray : null,
            borderRadius: BorderRadius.circular(8),
            image: career.thumbnail == ""
                ? null
                : DecorationImage(
                    image: NetworkImage(career.thumbnail),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        const Color(0x00000000).withOpacity(0.4),
                        BlendMode.srcOver))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.careerName,
              style: kmainbold.copyWith(
                  color: career.thumbnail == "" ? mainblack : mainWhite),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text(
                  "최근 포스트 ${DateFormat('yyyy.MM.dd.').format(career.updateDate!)}",
                  style: kmain.copyWith(
                      color: career.thumbnail == "" ? mainblack : mainWhite),
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
                //       style: kmainbold.copyWith(
                //           color: career.thumbnail == "" ? mainblack : mainWhite),
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
}
