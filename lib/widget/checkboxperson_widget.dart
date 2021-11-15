import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class CheckBoxPersonWidget extends StatelessWidget {
  // ProjectAddPersonController projectaddpersoncontroller = Get.find();
  ProjectMakeController projectMakeController = Get.find();

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
    return Obx(
      () => Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.black,
        ),
        child: CheckboxListTile(
          activeColor: Colors.black,
          checkColor: Colors.white,
          value: isselected.value,
          onChanged: (bool? value) {
            isselected(value);
            if (value == true) {
              projectMakeController.selectedpersontaglist.add(
                SelectedPersonTagWidget(
                  key: UniqueKey(),
                  text: name,
                  id: id,
                ),
              );
            } else {
              projectMakeController.selectedpersontaglist
                  .removeWhere((element) => element.id == id);
            }
          },
          secondary: ClipOval(
              child: CachedNetworkImage(
            height: 56,
            width: 56,
            imageUrl: image ?? "https://i.stack.imgur.com/l60Hf.png",
            placeholder: (context, url) => const CircleAvatar(
              child: Center(child: CircularProgressIndicator()),
            ),
            fit: BoxFit.fill,
          )),
          controlAffinity: ListTileControlAffinity.trailing,
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
        ),
      ),
    );
  }
}
