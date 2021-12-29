import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

class SelectedTagWidget extends StatelessWidget {
  SelectedTagWidget({Key? key, required this.text, this.id}) : super(key: key);
  TagController tagController = Get.find();

  String text;
  int? id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        height: 32,
        decoration: BoxDecoration(
          color: mainlightgrey,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () {
                  tagController.selectedtaglist
                      .removeWhere((element) => element.id == id);
                  tagController.gettagsearch();
                },
                child: SvgPicture.asset(
                  "assets/icons/Close_blue.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
