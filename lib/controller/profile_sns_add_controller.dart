import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/model/user_model.dart';
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
            snsController.text.startsWith("https://")) {
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
          ProfileController.to.myUserInfo.value.copywith(value.data);
          snsList.value = ProfileController.to.myUserInfo.value.snsList;
          // SNS? tempSNS = ProfileController.to.myUserInfo.value.snsList
          //     .firstWhereOrNull((element) => element.snsType == sns.snsType);

          // if (tempSNS != null) {
          //   tempSNS.url = sns.url;
          // } else {
          //   ProfileController.to.myUserInfo.value.snsList.add(sns);
          // }
        }

        if (Get.isRegistered<OtherProfileController>(
            tag: HomeController.to.myId)) {
          OtherProfileController otherProfileController =
              Get.find<OtherProfileController>(tag: HomeController.to.myId);
          otherProfileController.otherUser.value.copywith(value.data);
          snsList.value = otherProfileController.otherUser.value.snsList;
          // SNS? tempSNS = otherProfileController.otherUser.value.snsList
          //     .firstWhereOrNull((element) => element.snsType == sns.snsType);

          // if (tempSNS != null) {
          //   tempSNS.url = sns.url;
          // } else {
          //   otherProfileController.otherUser.value.snsList.add(sns);
          // }
        }
        snsController.clear();
        getbacks(2);
      } else {
        Get.back();
        errorSituation(value);
      }
    });
  }

  void snsDelete(SNS sns) async {
    loading();
    await deleteSNS(sns.id).then((value) {
      if (value.isError == false) {
        snsList.remove(sns);
        Get.back();
      } else {
        Get.back();
        errorSituation(value);
      }
    });
  }

  String? validateUrl(String value) {
    if (currentSNSType.snsInputType == "URL") {
      // ??????, ?????????

      // ??????
      if (value.isEmpty) {
        return 'URL??? ???????????????';
      } else {
        if (!value.startsWith("https://")) {
          return "https:// ??? ???????????? ????????? URL ????????? ??????????????????.";
        } else {
          return null;
        }
      }
    } else {
      // ?????????, ?????????, ?????????

      // ??????
      if (value.isEmpty) {
        return '???????????? ???????????????';
      } else {
        return null;
      }
    }
  }
}
