import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class CheckBoxPersonWidget extends StatelessWidget {
  // ProjectAddPersonController projectaddpersoncontroller = Get.find();
  ProjectAddController projectMakeController = Get.find();

  CheckBoxPersonWidget({
    Key? key,
    required this.name,
    required this.department,
    required this.id,
    this.image,
  }) : super(key: key);

  String name;
  String department;
  String? image;
  int id;
  RxBool isselected = false.obs;

  @override
  Widget build(BuildContext context) {
    if (projectMakeController.selectedpersontaglist
        .where((element) => element.id == id)
        .isNotEmpty) {
      projectMakeController.selectedpersontaglist.contains(
        projectMakeController.selectedpersontaglist
            .where((element) => element.id == id)
            .first,
      )
          ? isselected(true)
          : isselected(false);
    }
    return ListTile(
        leading: ClipOval(
            child: CachedNetworkImage(
          height: 56,
          width: 56,
          imageUrl: image ?? "https://i.stack.imgur.com/l60Hf.png",
          placeholder: (context, url) => const CircleAvatar(
            child: Center(child: CircularProgressIndicator()),
          ),
          fit: BoxFit.fill,
        )),
        title: Text(
          '$name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$department',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        trailing: Obx(
          () => IconButton(
            onPressed: () {
              if (isselected.value) {
                isselected(false);
                projectMakeController.selectedpersontaglist
                    .removeWhere((element) => element.id == id);
              } else {
                isselected(true);
                projectMakeController.selectedpersontaglist.add(
                  SelectedPersonTagWidget(
                    text: name,
                    id: id,
                  ),
                );
              }
            },
            icon: isselected.value
                ? SvgPicture.asset(
                    "assets/icons/Check_Active_blue.svg",
                    width: 24,
                    height: 24,
                  )
                : SvgPicture.asset(
                    "assets/icons/Check_Inactive_blue.svg",
                    width: 24,
                    height: 24,
                  ),
          ),
        ));
  }
}
