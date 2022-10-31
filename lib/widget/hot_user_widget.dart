import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/user_image_widget.dart';

class HotUserWidget extends StatelessWidget {
  HotUserWidget({Key? key, required this.person}) : super(key: key);

  Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [mainblue, Colors.yellow]),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8)),
      width: 211,
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
                height: 8,
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
    );
  }
}
