import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/modal_controller.dart';

class ErrorController extends GetxController {
  static ErrorController get to => Get.put(ErrorController());

  RxBool isServerClosed = false.obs;

  @override
  void onInit() {
    debounce(
      isServerClosed,
      (_) {
        ModalController.to.showErrorDialog(
            title: '현재 서버가 점검 중이에요',
            content: '나중에 다시 접속해주세요',
            leftFunction: () {
              print('asd');
              if (Platform.isIOS) {
                exit(0);
              } else if (Platform.isAndroid) {
                SystemNavigator.pop();
              }
            });
      },
      time: Duration(seconds: 1),
    );
    super.onInit();
  }
}
