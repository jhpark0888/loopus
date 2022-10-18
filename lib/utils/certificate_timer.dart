import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';

class CertificateTimer {
  CertificateTimer({this.timer, this.emailcertification});

  Timer? timer;
  RxInt sec = 0.obs;
  Rx<Emailcertification>? emailcertification;

  void timerOn(int time) async {
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }
    sec(time);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value != 0) {
        sec.value -= 1;
      } else {
        timerClose(closeFunction: () {
          emailcertification!(Emailcertification.fail);
          dialogOn();
          certificateClose(const FlutterSecureStorage());
        });
      }
    });
  }

  void timerClose({
    Function()? closeFunction,
  }) {
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }
    // if (validChecktimer != null) {
    //   if (validChecktimer!.isActive) {
    //     validChecktimer!.cancel();
    //   }
    // }
    if (closeFunction != null) {
      closeFunction();
    }
    sec(0);
  }

  void certificateClose(FlutterSecureStorage secureStorage) async {
    String? email = await secureStorage.read(key: 'temp_email');
    FirebaseMessaging.instance.unsubscribeFromTopic(email!);
    secureStorage.delete(key: 'temp_email');
  }

  void dialogOn() {
    Get.closeCurrentSnackbar();
    showBottomSnackbar("시간이 만료되어 인증이 취소되었어요\n다시 시도해주세요");
  }

  Widget timerDisplay() {
    return Obx(
      () => Text(
        '인증까지 남은 시간 ${sec.value ~/ 60}:${NumberFormat('00', "ko").format(sec.value % 60)}',
        style: kmain,
      ),
    );
  }

  // Widget timerDisplay() {
  //   return Obx(
  //     () => Text(
  //       '0${sec.value ~/ 60}:${NumberFormat('00', "ko").format(sec.value % 60)}',
  //       style: kmainbold.copyWith(color: mainblack),
  //     ),
  //   );
  // }

}
