import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
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
    return GestureDetector(
      onTap: () {
        if (selecttagtype == SelectTagtype.interesting) {
          tagController.selectedtaglist
              .removeWhere((element) => element.text == text);
          tagController.tagSearchFunction();
        } else {
          ProjectAddController.to.selectedpersontaglist
              .removeWhere((element) => element.id == id);
          ProjectAddController.to.looppersonlist
              .where((element) => element.user.userId == id)
              .first
              .isselected(false);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: AppColors.mainWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 0.5, color: AppColors.dividegray)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: MyTextTheme.main(context),
            ),
            const SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              "assets/icons/widget_delete.svg",
              width: 8,
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
