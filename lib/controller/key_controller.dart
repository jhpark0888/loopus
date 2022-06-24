import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/tag_controller.dart';

class KeyController extends GetxController {
  GlobalKey viewKey = GlobalKey();
  GlobalKey linkKey = GlobalKey();
  KeyController({this.tag, required this.isTextField});
  Tagtype? tag;
  RxBool isTextField;

  // static KeyController get to => Get.put(KeyController());
  @override
  void onInit() {
    if (tag == Tagtype.Posting) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        getSize();
      });
    }
    super.onInit();
  }

  void getSize() {
    RenderBox? viewBox =
        viewKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = viewBox.localToGlobal(Offset.zero);
    print(offset.dy);
    print(Get.find<TagController>(tag: tag.toString()).textfieldOffset.value);
    Get.find<TagController>(tag: tag.toString()).offsetDy.value = offset.dy;
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
                Get.find<TagController>(tag: tag.toString())
                    .textfieldOffset
                    .value);
                    print('ㅇㄴㅇㄴ');
      }
      print(Get.find<TagController>(tag: tag.toString()).textfieldOffset.value);
      Get.find<TagController>(tag: tag.toString()).keyController.value = true;
    }
    else{
      
    }
  }

  
}
