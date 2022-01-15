import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
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
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      decoration: BoxDecoration(
        color: mainlightgrey,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            width: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InkWell(
              onTap: () {
                tagController.selectedtaglist
                    .removeWhere((element) => element.id == id);
                gettagsearch();
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
    );
  }
}
