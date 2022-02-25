import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

class SelectedTagWidget extends StatelessWidget {
  SelectedTagWidget(
      {Key? key,
      required this.text,
      this.id,
      required this.selecttagtype,
      required this.tagtype})
      : super(key: key);
  late TagController tagController =
      Get.find<TagController>(tag: tagtype.toString());

  String text;
  int? id;
  SelectTagtype selecttagtype;
  Tagtype tagtype;

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
                if (selecttagtype == SelectTagtype.interesting) {
                  tagController.selectedtaglist
                      .removeWhere((element) => element.text == text);
                  gettagsearch(tagtype);
                } else {
                  ProjectAddController.to.selectedpersontaglist
                      .removeWhere((element) => element.id == id);
                  ProjectAddController.to.looppersonlist
                      .where((element) => element.user.userid == id)
                      .first
                      .isselected(false);
                }
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
