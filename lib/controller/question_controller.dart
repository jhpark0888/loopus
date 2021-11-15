import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find();

  TextEditingController contentcontroller = TextEditingController();

  List<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[
    SelectedTagWidget(
      text: '컴공',
    )
  ].obs;
  List<SelectedTagWidget> selectedpersonlist = <SelectedTagWidget>[
    SelectedTagWidget(
      text: '박지환',
    )
  ].obs;

  var personselected = false.obs;
}
