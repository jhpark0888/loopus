// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/screen/posting_add_image_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/customlinkstylewidget.dart';
import 'package:loopus/widget/editortoolbar.dart';
import 'package:loopus/widget/smarttextfield.dart';

class PostingAddContentScreen extends StatelessWidget {
  PostingAddContentScreen({Key? key, required this.project_id})
      : super(key: key);
  // PostingAddController postingAddController = Get.find();
  EditorController editorController = Get.put(EditorController());
  int project_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          actions: [
            TextButton(
              onPressed: () {
                Get.to(() => PostingAddImageScreen(
                      project_id: project_id,
                    ));
              },
              child: Text(
                '다음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblue,
                ),
              ),
            ),
          ],
          title: '포스팅 내용',
        ),
        body: Column(
          children: [
            Obx(
              () => Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (editorController.types.last == SmartTextType.IMAGE) {
                    editorController.insert(
                        index: editorController.types.length);
                    editorController.setFocus(SmartTextType.T);
                  } else {
                    editorController.nodes.last.requestFocus();
                  }
                },
                child: ListView(
                  children: editorController.smarttextfieldlist,
                ),
              )),
            ),
            Obx(
              () => EditorToolbar(
                  selectedType: editorController.selectedType.value,
                  onSelected: editorController.setType),
            )
          ],
        ));
  }
}
