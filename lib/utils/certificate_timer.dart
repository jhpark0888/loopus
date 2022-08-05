import 'dart:async';

import 'package:flutter/material.dart';
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
    sec(time);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value != 0) {
        sec.value -= 1;
      } else {
        timerClose();
      }
    });
  }

  void timerClose({bool dialogOn = true, bool stateChange = true}) {
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
    if (stateChange) {
      if (emailcertification != null) {
        emailcertification!(Emailcertification.fail);
      }
    }

    if (dialogOn) {
      Get.closeCurrentSnackbar();
      showBottomSnackbar("시간이 만료되어 인증이 취소되었어요\n다시 시도해주세요");
    }
    sec(0);
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
