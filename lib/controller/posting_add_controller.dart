import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/screen/upload_share_image_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});
  ScrollController scrollController = ScrollController();
  RichTextController textcontroller = RichTextController(patternMatchMap: {
    CheckValidate.urlRegExp:
        MyTextTheme.main(Get.context!).copyWith(color: AppColors.mainblue),
  }, onMatch: (match) {});

  TextEditingController tagcontroller = TextEditingController();
  TextEditingController linkcontroller = TextEditingController();
  KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  RxBool isPostingUploading = false.obs;
  RxBool isAddLink = false.obs;
  RxBool isAddImage = false.obs;
  RxList<File> images = <File>[].obs;
  RxList<LinkWidget> scrapList = <LinkWidget>[].obs;
  RxList<File> files = <File>[].obs;
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
  List<File> selectedShareImageList = [];
  List<GlobalKey<CustomCropState>> selectedCropKeyList = [];
  List<Widget> selectedCropWidgetList = [];

  KeyController keyController = Get.put(KeyController(isTextField: false.obs));
  @override
  void onInit() {
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

    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      if (Get.isRegistered<ShareIntentController>()) {
        if (ShareIntentController.to.shareText != "") {
          String text = ShareIntentController.to.shareText;

          if (CheckValidate.urlRegExp.hasMatch(text)) {
            //받아온 텍스트가 url일 때
            scrapList.add(LinkWidget(
                url: changeUrl(ShareIntentController.to.shareText),
                widgetType: "add"));
            isAddLink(true);
          } else {
            //받아온 텍스트가 단순한 문자열일 때
            textcontroller.text = text;
          }
        } else if (ShareIntentController.to.sharedFiles.isNotEmpty) {
          if (ShareIntentController.to.sharedFiles.first.type ==
              SharedMediaType.IMAGE) {
            //     MultiImageController _imageController =
            // Get.put((MultiImageController()));
            //받아온 데이터가 이미지일 때

            ShareIntentController.to.shareImages = ShareIntentController
                .to.sharedFiles
                .map((image) => File(image.path))
                .toList();
            ShareIntentController.to.imagesInit();
            Get.to(() => ShareImageUploadScreen());
          } else {
            //받아온 데이터가 파일일 때
            List<File> tempFiles = ShareIntentController.to.sharedFiles
                .map((file) => File(file.path))
                .toList();

            fileSizeCheck(tempFiles);
          }
        }
      }
    });

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

  void fileSizeCheck(List<File> tempFiles) {
    int filesSize = tempFiles
        .map((file) => file.lengthSync())
        .reduce((total, bytes) => total + bytes);

    double filesSizeToMB =
        double.parse((filesSize / pow(1024, 2)).toStringAsFixed(2));

    print("fileSize: $filesSizeToMB MB");

    if (filesSizeToMB <= 30) {
      files.addAll(tempFiles);
    } else {
      showPopUpDialog(
        "최대 업로드 용량 초과",
        "파일은 총 합 30MB의 크기를 넘을 수 없어요",
      );
    }
  }
}
