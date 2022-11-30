import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentController extends GetxController {
  // SelectProjectController(this.projectid);
  static ShareIntentController get to => Get.find();

  List<SharedMediaFile> sharedFiles = [];
  String shareText = "";

  List<File> shareImages = [];
  RxList<File> selectedImages = <File>[].obs;
  List<GlobalKey<CustomCropState>> cropKeyList = <GlobalKey<CustomCropState>>[];
  RxList<Widget> cropWidgetList = <Widget>[].obs;
  RxInt selectedIndex = 0.obs;
  Rx<File> selectedImage = File("").obs;
  RxDouble cropAspectRatio = 1.0.obs;

  void imagesInit() {
    selectedImages.clear();
    cropKeyList.clear();
    cropWidgetList.clear();
    selectedIndex(0);
    cropAspectRatio(1);
    selectedImage(File(""));
  }

  int selectedImageIndex(File selectImage) {
    int index = selectedImages.indexWhere((image) => image == selectImage);
    return index;
  }

  void addImage(int index) async {
    GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();

    cropWidgetList.add(Obx(
      () => CustomCrop(
        image: FileImage(
          shareImages[index],
        ),
        key: cropKey,
        areaFixed: true,
        aspectRatio: cropAspectRatio.value,
      ),
    ));

    selectedImages.add(shareImages[index]);
    selectedImage.value = shareImages[index];
    cropKeyList.add(cropKey);

    selectedIndex(cropKeyList.length - 1);
  }

  void removeImage(int index) {
    cropWidgetList.removeAt(selectedImageIndex(selectedImage.value));
    cropKeyList.removeAt(selectedImageIndex(selectedImage.value));
    selectedImages.remove(shareImages[index]);
    selectedIndex(cropKeyList.length - 1);
  }

  Future<List<File>> cropImages() async {
    List<File> tempimages = <File>[];
    for (int i = 0; i < cropKeyList.length; i++) {
      GlobalKey<CustomCropState> cropKey = cropKeyList[i];
      // final scale = cropKey.currentState!.scale;
      final area = cropKey.currentState!.area;
      if (area == null) {
        // cannot crop, widget is  not setup
        print(null);
        return [];
      }

      final file = await ImageCrop.cropImage(
        file: selectedImages[i],
        area: area,
      );
      tempimages.add(file);
    }

    return tempimages;
  }
}
