import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});
  ScrollController scrollController = ScrollController();
  TextEditingController textcontroller = TextEditingController();
  TextEditingController tagcontroller = TextEditingController();
  TextEditingController linkcontroller = TextEditingController();
  KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  RxBool isPostingUploading = false.obs;
  RxBool isAddLink = false.obs;
  RxBool isAddImage = false.obs;
  RxList<File> images = <File>[].obs;
  RxList<LinkWidget> scrapList = <LinkWidget>[].obs;
  RxInt lines = 0.obs;
  RxBool isPostingTitleEmpty = true.obs;
  RxBool isPostingContentEmpty = true.obs;
  RxBool isLinkTextEmpty = true.obs;
  RxBool isTagClick = false.obs;
  RxBool keyboardActive = false.obs;
  RxBool getTagList = false.obs;
  PostaddRoute route;

  RxDouble cropAspectRatio = 1.0.obs;
  List<double> selectedScaleList = [];
  List<Rect> selectedViewList = [];
  List<AssetEntity> selectedImageList = [];
  List<GlobalKey<CustomCropState>> selectedCropKeyList = [];
  List<Widget> selectedCropWidgetList = [];

  KeyController keyController = Get.put(KeyController(isTextField: false.obs));
  @override
  void onInit() {
    if (Get.isRegistered<ShareIntentController>()) {
      scrapList.add(LinkWidget(
          url: changeUrl(ShareIntentController.to.shareText),
          widgetType: "add"));
      isAddLink(true);
    }

    textcontroller.addListener(() {
      if (textcontroller.text.trim().isEmpty) {
        isPostingTitleEmpty.value = true;
      } else {
        isPostingTitleEmpty.value = false;
      }
    });
    linkcontroller.addListener(() {
      if (linkcontroller.text.trim().isEmpty) {
        isLinkTextEmpty.value = true;
      } else {
        isLinkTextEmpty.value = false;
      }
    });

    keyboardVisibilityController.onChange.listen(((event) async {
      keyboardActive.value = event;
    }));

    isTagClick.listen((p0) async {
      if (p0 == true) {
        if (getTagList.value) {
          await Future.delayed(const Duration(milliseconds: 300));
          if (keyboardActive.value) {
            Scrollable.ensureVisible(keyController.viewKey.currentContext!,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 200))
                .then((value) async {
              Future.delayed(const Duration(milliseconds: 100));
              isTagClick.value = false;
            });
          }
        }
      }
    });

    getTagList.listen(((p0) async {
      if (p0) {
        if (isTagClick.value && keyboardActive.value) {
          await Future.delayed(const Duration(microseconds: 100));
          Scrollable.ensureVisible(keyController.viewKey.currentContext!,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 200))
              .then((value) => isTagClick.value = false);
        }
      }
    }));

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    if (AppController.to.userType == UserType.company) {
      if (Get.isRegistered<ShareIntentController>()) {
        Get.delete<ShareIntentController>();
      }
    }
    super.onClose();
  }
}
