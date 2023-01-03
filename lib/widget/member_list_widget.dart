import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CareerMemberListWidget extends StatelessWidget {
  CareerMemberListWidget(
      {Key? key,
      required this.members,
      required this.membersCount,
      this.textColor})
      : super(key: key);
  List<Person> members;
  int membersCount;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    List<Person> memberList =
        members.length > 3 ? members.sublist(0, 3) : members;

    return members.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: memberList
                    .asMap()
                    .entries
                    .map((entry) => memberImage(entry.value, entry.key))
                    .toList(),
              ),
              const SizedBox(
                width: 7,
              ),
              if (members.length > 3)
                Text(
                  "+${membersCount - 3}",
                  style: MyTextTheme.main(context).copyWith(color: textColor),
                )
            ],
          )
        : Container();
  }

  Widget memberImage(Person user, int index) {
    return Container(
        width: 24,
        height: 24,
        margin: EdgeInsets.only(left: (17 * index).toDouble()),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.dividegray),
            shape: BoxShape.circle),
        child: UserImageWidget(
          imageUrl: user.profileImage,
          width: 24,
          height: 24,
          userType: user.userType,
        ));
  }
}
