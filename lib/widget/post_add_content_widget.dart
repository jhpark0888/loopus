import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/widget/smarttextfield.dart';

class PostAddContentWidget extends StatelessWidget {
  PostAddContentWidget({Key? key, required this.index}) : super(key: key);

  EditorController editorController = Get.find();
  int index;

  @override
  Widget build(BuildContext context) {
    if (editorController.types[index] == SmartTextType.IMAGE) {
      return Align(
        alignment: editorController.types[index].imageAlign,
        child: Padding(
          padding: editorController.types[index].padding,
          child: Image.file(editorController.imageindex[index]!),
        ),
      );
    } else {
      return Container(
        padding: editorController.types[index].padding,
        width: Get.width,
        child: Text(
          '${editorController.types[index].prefix ?? ''}${editorController.textcontrollers[index].text}',
          textAlign: editorController.types[index].align,
          style: editorController.types[index].textStyle,
        ),
      );
    }
  }
}
