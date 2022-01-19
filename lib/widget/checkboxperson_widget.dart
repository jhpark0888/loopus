import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class CheckBoxPersonWidget extends StatelessWidget {
  // ProjectAddPersonController projectaddpersoncontroller = Get.find();
  ProjectAddController projectaddController = Get.find();

  CheckBoxPersonWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;
  // String name;
  // String department;
  // String? image;
  // int id;
  RxBool isselected = false.obs;

  @override
  Widget build(BuildContext context) {
    if (projectaddController.selectedpersontaglist
        .where((element) => element.id == user.userid)
        .isNotEmpty) {
      projectaddController.selectedpersontaglist.contains(
        projectaddController.selectedpersontaglist
            .where((element) => element.id == user.userid)
            .first,
      )
          ? isselected(true)
          : isselected(false);
    }
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 56,
                    width: 56,
                    imageUrl: user.profileImage ??
                        "https://i.stack.imgur.com/l60Hf.png",
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: const Color(0xffe7e7e7),
                      child: Container(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.realName,
                      style: kSubTitle2Style,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.department,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => InkWell(
              onTap: () {
                if (isselected.value) {
                  isselected(false);
                  projectaddController.selectedpersontaglist
                      .removeWhere((element) => element.id == user.userid);
                } else {
                  isselected(true);
                  projectaddController.selectedpersontaglist.add(
                    SelectedPersonTagWidget(
                      text: user.realName,
                      id: user.userid,
                    ),
                  );
                }
              },
              child: isselected.value
                  ? SvgPicture.asset(
                      "assets/icons/Check_Active_blue.svg",
                      width: 28,
                      height: 28,
                    )
                  : SvgPicture.asset(
                      "assets/icons/Check_Inactive_blue.svg",
                      width: 28,
                      height: 28,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
