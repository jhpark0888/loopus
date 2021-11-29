import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/posting_add_content_widget.dart';
import 'package:loopus/widget/posting_add_fileimage_widget.dart';
import 'package:loopus/widget/posting_add_title_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();

  TextEditingController titlecontroller = TextEditingController();
  var postinglist = <Widget>[].obs;
  Rx<File> image = File("").obs;
  Rx<File> thumbnail = File("").obs;

  void onInit() {
    super.onInit();
  }

  List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;

  // void onReorder(int oldIndex, int newIndex) {
  //   Widget row = postinglist.removeAt(oldIndex);
  //   if (newIndex >= postinglist.length) {
  //     postinglist.add(row);
  //   } else {
  //     postinglist.insert(newIndex, row);
  //   }
  // }

  void choiceAction(String choice) async {
    if (choice == Constants.FirstItem) {
      postinglist.add(PostingAdd_TitleWidget(
        key: UniqueKey(),
        title: '',
      ));
    } else if (choice == Constants.SecondItem) {
      postinglist.add(ProstingAdd_ContentWidget(
        key: UniqueKey(),
        content: '',
      ));
    } else if (choice == Constants.ThirdItem) {
      image(await getcropImage("posting"));
      print(image);
      if (image.value.path != '') {
        postinglist.add(PostingAdd_FileImageWidget(
          key: UniqueKey(),
          image: image.value,
        ));
      }
    } else if (choice == Constants.FourthItem) {}
  }
}

class Constants {
  static const String FirstItem = 'Title';
  static const String SecondItem = 'Content';
  static const String ThirdItem = 'Image';
  static const String FourthItem = 'Feed';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    FourthItem,
  ];
}
