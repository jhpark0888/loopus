import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find();
  TextEditingController contentcontroller = TextEditingController();
  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  TextEditingController tagsearch = TextEditingController();

  var personselected = false.obs;
}
