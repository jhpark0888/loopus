import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class ModalController extends GetxController {
  static ModalController get to => Get.find();

  void showModalIOS(
    BuildContext context, {
    required VoidCallback func1,
    required VoidCallback func2,
    required String value1,
    required String value2,
    required bool isValue1Red,
    required bool isValue2Red,
    required bool isOne,
  }) {
    showCupertinoModalPopup(
      barrierColor: mainblack.withOpacity(
        0.3,
      ),
      context: context,
      builder: (context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            '닫기',
            style: TextStyle(
              color: mainblack,
              fontFamily: 'Nanum',
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          isDefaultAction: true,
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              value1,
              style: TextStyle(
                color: isValue1Red ? mainpink : mainblack,
                fontFamily: 'Nanum',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: func1,
          ),
          if (isOne == false)
            CupertinoActionSheetAction(
                child: Text(
                  value2,
                  style: TextStyle(
                    color: isValue2Red ? mainpink : mainblack,
                    fontFamily: 'Nanum',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                onPressed: func2)
        ],
      ),
    );
  }

  void showCustomDialog(String title, int duration) {
    Get.dialog(
      AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          14,
        ),
        backgroundColor: Colors.white,
        content: Text(
          title,
          style: kSubTitle4Style,
          textAlign: TextAlign.center,
        ),
      ),
      barrierDismissible: false,
      barrierColor: mainblack.withOpacity(0.3),
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 300),
    );
    Future.delayed(Duration(seconds: duration), () {
      Get.back();
    });
  }
}
