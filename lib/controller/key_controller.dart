import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/websocet_screen.dart';

class KeyController extends GetxController {
  GlobalKey viewKey = GlobalKey();
  GlobalKey linkKey = GlobalKey();
  KeyController(
      {this.tag,
      required this.isTextField,
      this.isfollow = false,
      this.ismessage = false,
      this.isMessageBox = false});
  Tagtype? tag;
  RxBool isTextField;
  bool isfollow;
  bool ismessage;
  bool isMessageBox;
  late RenderBox viewBox;
  RxBool isComplete = false.obs;
  // static KeyController get to => Get.put(KeyController());
  @override
  void onInit() {
    if (tag == Tagtype.Posting) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        getSize();
      });
    }
    if (isfollow == true) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        viewBox = viewKey.currentContext!.findRenderObject() as RenderBox;
        print(viewBox.size.height);
        print(Get.height);
        isComplete.value = true;
      });
    }
    if (ismessage == true) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        if (viewKey.currentContext != null) {
          viewBox = viewKey.currentContext!.findRenderObject() as RenderBox;
          Get.find<WebsoketController>().messageHeight.value +=
              viewBox.size.height;
        }
      });
    }
    if (isMessageBox == true) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        viewBox = viewKey.currentContext!.findRenderObject() as RenderBox;
        Get.find<WebsoketController>().messagesBoxPositionHeight.value =
            viewBox.size.height;
        print(Get.find<WebsoketController>().messagesBoxPositionHeight.value);
      });
    }
    super.onInit();
  }

  void getSize() {
    RenderBox? viewBox =
        viewKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = viewBox.localToGlobal(Offset.zero);
    // print(offset.dy);
    // print(Get.find<TagController>(tag: tag.toString()).textfieldOffset.value);
    // Get.find<TagController>(tag: tag.toString()).offsetDy.value = offset.dy;
    if (isTextField.value == true) {
      if (Get.find<TagController>(tag: tag.toString()).textfieldOffset.value ==
          0.0) {
        Get.find<TagController>(tag: tag.toString()).textfieldOffset.value =
            offset.dy;
      } else {
        Get.find<TagController>(tag: tag.toString()).textfieldOffset.value =
            offset.dy -
                Get.find<TagController>(tag: tag.toString())
                    .textfieldOffset
                    .value;
        print(offset.dy -
            Get.find<TagController>(tag: tag.toString()).textfieldOffset.value);
        print('ㅇㄴㅇㄴ');
      }
      print(Get.find<TagController>(tag: tag.toString()).textfieldOffset.value);
      Get.find<TagController>(tag: tag.toString()).keyController.value = true;
    } else {}
  }
}
