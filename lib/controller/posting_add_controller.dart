import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/posting_add_content_widget.dart';
import 'package:loopus/widget/posting_add_fileimage_widget.dart';
import 'package:loopus/widget/posting_add_title_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();

  TextEditingController titlecontroller = TextEditingController();
  QuillController postcontroller = QuillController.basic();
  List<File> images = [];
  Rx<File> thumbnail = File("").obs;

  void onInit() {
    super.onInit();
  }
}
