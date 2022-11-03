import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/user_image_widget.dart';

class HotUserWidget extends StatelessWidget {
  HotUserWidget({Key? key, required this.person}) : super(key: key);

  Person person;
  List<Color> gradientColors = <Color>[
    const Color(0xFF2695FF),
    const Color(0xFF0CB3FA),
    const Color(0xFFFAC519),
    const Color(0xFFD0C53C),
    const Color(0xFFFF8652)
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(
                user: person, userid: person.userId, realname: person.name),
            preventDuplicates: false);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: LinearGradient(colors: gradientColors),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserImageWidget(
                    imageUrl: person.profileImage,
                    width: 36,
                    height: 36,
                    userType: UserType.student),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  person.name,
                  style: kmain,
                )
              ],
            ),
            const SizedBox(
              width: 24,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: "${person.univName}\n", style: kmainheight),
                  TextSpan(text: "${person.department}\n", style: kmainheight),
                  TextSpan(
                      text: "최근 포스트 ",
                      style: kmainheight.copyWith(color: maingray)),
                  TextSpan(
                      text: "${person.resentPostCount}개", style: kmainheight),
                ]))
          ],
        ),
      ),
    );
  }
}
