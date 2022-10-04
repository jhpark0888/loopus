import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/error_control.dart';

class ProfileSnsAddController extends GetxController {
  ProfileSnsAddController({required this.snsList});
  static ProfileSnsAddController get to => Get.find();

  final TextEditingController snsController = TextEditingController();

  RxList<SNS> snsList = <SNS>[].obs;
  late SNSType currentSNSType;
  RxBool isButtonActive = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    snsController.addListener(() {
      if (currentSNSType.snsInputType == "URL") {
        if (snsController.text.isNotEmpty &&
            snsController.text.startsWith("http://")) {
          isButtonActive(true);
        } else {
          isButtonActive(false);
        }
      } else {
        if (snsController.text.isNotEmpty) {
          isButtonActive(true);
        } else {
          isButtonActive(false);
        }
      }
    });
  }

  void snsAdd(SNS sns) async {
    loading();
    await updateProfile(sns: sns, updateType: ProfileUpdateType.sns)
        .then((value) {
      if (value.isError == false) {
        if (Get.isRegistered<ProfileController>()) {
          SNS? tempSNS = ProfileController.to.myUserInfo.value.snsList
              .firstWhereOrNull((element) => element.snsType == sns.snsType);

          if (tempSNS != null) {
            tempSNS.url = sns.url;
          } else {
            ProfileController.to.myUserInfo.value.snsList.add(sns);
          }
        }

        if (Get.isRegistered<OtherProfileController>(
            tag: HomeController.to.myId)) {
          OtherProfileController otherProfileController =
              Get.find<OtherProfileController>(tag: HomeController.to.myId);
          SNS? tempSNS = otherProfileController.otherUser.value.snsList
              .firstWhereOrNull((element) => element.snsType == sns.snsType);

          if (tempSNS != null) {
            tempSNS.url = sns.url;
          } else {
            otherProfileController.otherUser.value.snsList.add(sns);
          }
        }
        snsController.clear();
        getbacks(2);
      } else {
        Get.back();
        errorSituation(value);
      }
    });
  }

  String? validateUrl(String value) {
    if (currentSNSType.snsInputType == "URL") {
      if (value.isEmpty) {
        return 'URL을 입력하세요';
      } else {
        if (!value.startsWith("http://")) {
          return "https:// 로 시작하는 정확한 URL 주소를 입력해주세요.";
        } else {
          return null;
        }
      }
    } else {
      if (value.isEmpty) {
        return '아이디를 입력하세요';
      } else {
        return null;
      }
    }
  }
}
