// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/screen/posting_add_image_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/editortoolbar.dart';
import 'package:loopus/widget/smarttextfield.dart';

class PostingAddContentScreen extends StatelessWidget {
  PostingAddContentScreen({Key? key, required this.project_id})
      : super(key: key);
  PostingAddController postingAddController = Get.find();
  // EditorController editorController = Get.put(EditorController());
  int project_id;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            bottomBorder: false,
            actions: [
              TextButton(
                onPressed: () {
                  // postingAddController.editorController
                  //     .nodeAt(postingAddController.editorController.focus)
                  //     .unfocus();
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
                    if (postingAddController.editorController.types.last ==
                        SmartTextType.IMAGE) {
                      postingAddController.editorController.insert(
                          index: postingAddController
                              .editorController.types.length);
                      postingAddController.editorController
                          .setFocus(SmartTextType.T);
                    } else {
                      postingAddController.editorController.nodes.last
                          .requestFocus();
                    }
                  },
                  child: ListView(
                    children: postingAddController
                        .editorController.smarttextfieldlist,
                  ),
                )),
              ),
              Obx(
                () => EditorToolbar(
                    selectedType: postingAddController
                        .editorController.selectedType.value,
                    onSelected: postingAddController.editorController.setType),
              )
            ],
          ),
        ),
      ],
    );
  }
}
