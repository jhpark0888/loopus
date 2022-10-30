import 'dart:async';

import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/select_project_screen.dart';
import 'package:loopus/screen/signup_type_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../api/profile_api.dart';
import '../constant.dart';

// class ModalController extends GetxController with GetTickerProviderStateMixin {
//   static ModalController get to => Get.find();
//   late final AnimationController _animationController;

//   @override
//   void onInit() {
//     _animationController = BottomSheet.createAnimationController(this);
//     _animationController.duration = Duration(milliseconds: 300);
//     _animationController.reverseDuration = Duration(milliseconds: 200);
//     _animationController.drive(CurveTween(curve: Curves.easeInOut));
//     super.onInit();
//   }
// }

void showContentModal(BuildContext context) {
  final LocalDataController _localDataController =
      Get.put(LocalDataController());
  final NotificationController _notificationController =
      Get.put(NotificationController());
  RxBool isModalNextBtnClicked = false.obs;
  RxBool isCheckOne = false.obs;
  RxBool isCheckTwo = false.obs;
  RxBool isCheckThree = false.obs;
  RxBool isCheckFour = false.obs;
  showModalBottomSheet(
    enableDrag: false,
    context: context,
    builder: (context) => Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                if (isCheckOne.value == true &&
                    isCheckTwo.value == true &&
                    isCheckThree.value == true &&
                    isCheckFour.value == true) {
                  isCheckOne.value = false;
                  isCheckTwo.value = false;
                  isCheckThree.value = false;
                  isCheckFour.value = false;
                } else {
                  isCheckOne.value = true;
                  isCheckTwo.value = true;
                  isCheckThree.value = true;
                  isCheckFour.value = true;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (isCheckOne.value == true &&
                            isCheckTwo.value == true &&
                            isCheckThree.value == true &&
                            isCheckFour.value == true)
                        ? mainblue
                        : mainblack.withOpacity(0.6),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    (isCheckOne.value == true &&
                            isCheckTwo.value == true &&
                            isCheckThree.value == true &&
                            isCheckFour.value == true)
                        ? SvgPicture.asset(
                            'assets/icons/Check_Active_blue.svg',
                          )
                        : SvgPicture.asset('assets/icons/Uncheck_rect.svg'),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '모두 동의합니다',
                      style: (isCheckOne.value == true &&
                              isCheckTwo.value == true &&
                              isCheckThree.value == true &&
                              isCheckFour.value == true)
                          ? ktempFont.copyWith(
                              fontWeight: FontWeight.w400,
                              color: mainblue,
                            )
                          : ktempFont.copyWith(
                              fontWeight: FontWeight.w400,
                              color: mainblack.withOpacity(0.6),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    isCheckOne.value = !isCheckOne.value;
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        (isCheckOne.value == true)
                            ? 'assets/icons/Uncheck_norect_blue.svg'
                            : 'assets/icons/Uncheck_norect.svg',
                        color: isCheckOne.value == true
                            ? mainblue
                            : mainblack.withOpacity(0.6),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '(필수)',
                        style: ktempFont.copyWith(
                          color: isCheckOne.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '서비스 이용약관',
                        style: ktempFont.copyWith(
                          color: isCheckOne.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(() => WebViewScreen(url: kTermsOfService));
                    },
                    // child: SvgPicture.asset('assets/icons/Arrow_right.svg'),
                    child: SizedBox.shrink()),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    isCheckTwo.value = !isCheckTwo.value;
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        (isCheckTwo.value == true)
                            ? 'assets/icons/Uncheck_norect_blue.svg'
                            : 'assets/icons/Uncheck_norect.svg',
                        color: isCheckTwo.value == true
                            ? mainblue
                            : mainblack.withOpacity(0.6),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '(필수)',
                        style: ktempFont.copyWith(
                          color: isCheckTwo.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '개인정보 처리방침',
                        style: ktempFont.copyWith(
                          color: isCheckTwo.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => WebViewScreen(url: kPrivacyPolicy));
                  },
                  child: SvgPicture.asset('assets/icons/arrow_right.svg'),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    isCheckFour.value = !isCheckFour.value;
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        (isCheckFour.value == true)
                            ? 'assets/icons/Uncheck_norect_blue.svg'
                            : 'assets/icons/Uncheck_norect.svg',
                        color: isCheckFour.value == true
                            ? mainblue
                            : mainblack.withOpacity(0.6),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '(필수)',
                        style: ktempFont.copyWith(
                          color: isCheckFour.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '개인정보 수집동의',
                        style: ktempFont.copyWith(
                          color: isCheckFour.value == true
                              ? mainblue
                              : mainblack.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        WebViewScreen(url: kPersonalInfoCollectionAgreement));
                  },
                  child: SvgPicture.asset('assets/icons/arrow_right.svg'),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                isCheckThree.value = !isCheckThree.value;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    (isCheckThree.value == true)
                        ? 'assets/icons/Uncheck_norect_blue.svg'
                        : 'assets/icons/Uncheck_norect.svg',
                    color: isCheckThree.value == true
                        ? mainblue
                        : mainblack.withOpacity(0.6),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '(선택)',
                    style: ktempFont.copyWith(
                      color: isCheckThree.value == true
                          ? mainblue
                          : mainblack.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '루프어스 프로모션 알림 수신 동의',
                    style: ktempFont.copyWith(
                      color: isCheckThree.value == true
                          ? mainblue
                          : mainblack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: (isCheckOne.value == true &&
                      isCheckTwo.value == true &&
                      isModalNextBtnClicked.value == false)
                  ? () {
                      isModalNextBtnClicked.value = true;
                      Get.to(
                        () => SignupTypeScreen(),
                        preventDuplicates: false,
                      );

                      _localDataController.agreeProNoti(isCheckThree.value);
                      _notificationController.changePromotionAlarmState(
                          _localDataController.isUserAgreeProNoti);
                      if (isCheckThree.value == true) {
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          showCustomDialog(
                              '프로모션 알림 수신에 동의하셨습니다\n' +
                                  '(${DateFormat('yy.MM.dd').format(DateTime.now())})',
                              1000);
                        });
                      }
                    }
                  : () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: (isCheckOne.value == true &&
                          isCheckTwo.value == true &&
                          isCheckFour.value == true)
                      ? mainblue
                      : Color(0xffe7e7e7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '다음',
                    style: ktempFont.copyWith(
                      color: (isCheckOne.value == true &&
                              isCheckTwo.value == true &&
                              isCheckFour.value == true)
                          ? mainWhite
                          : mainblack.withOpacity(0.38),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    barrierColor: mainblack.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
  );
}

void showModalIOS(
  BuildContext context, {
  required VoidCallback func1,
  VoidCallback? func2,
  required String value1,
  required String value2,
  required bool isValue1Red,
  required bool isValue2Red,
  required bool isOne,
  bool? GetBack,
  required bool cancleButton,
  VoidCallback? func3,
  Color? boxColor,
}) {
  showCupertinoModalPopup(
    barrierColor: popupGray,
    context: context,
    builder: (context) => CupertinoActionSheet(
      cancelButton: cancleButton
          ? GetBack != null
              ? CupertinoActionSheetAction(
                  child: const Text(
                    "닫기",
                    style: kmainbold,
                  ),
                  isDefaultAction: true,
                  onPressed: () {
                    Get.back();
                  },
                )
              :
              // CustomExpandedButton(onTap: func3 != null ? func3 : () {}, isBlue: isBlue, title: 계, isBig: isBig)
              Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: rankred,
                  ),
                  child: CupertinoActionSheetAction(
                      child: const Text(
                        "계정 신고하기",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: mainWhite,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                      isDefaultAction: true,
                      onPressed: func3 != null ? func3 : () {}),
                )
          : null,
      actions: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isValue1Red ? rankred : mainWhite,
          ),
          child: CupertinoActionSheetAction(
            child: Text(
              value1,
              style: kmainbold.copyWith(
                color: isValue1Red ? mainWhite : mainblack,
              ),
            ),
            onPressed: func1,
          ),
        ),
        if (isOne == false)
          CupertinoActionSheetAction(
              child: Text(
                value2,
                style: kmainbold.copyWith(
                  color: isValue2Red ? rankred : mainWhite,
                ),
              ),
              onPressed: func2 != null ? func2 : () {})
      ],
    ),
  );
}

void showModalIOSText(
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
      cancelButton: Column(children: []),
      actions: [
        Container(
          color: rankred,
          child: CupertinoActionSheetAction(
            child: Text(
              value1,
              style: kmain.copyWith(
                color: isValue1Red ? rankred : mainblack,
              ),
            ),
            onPressed: func1,
          ),
        ),
        if (isOne == false)
          Container(
            color: mainWhite,
            child: CupertinoActionSheetAction(
                child: Text(
                  value2,
                  style: kmain.copyWith(
                    color: isValue2Red ? rankred : mainblack,
                  ),
                ),
                onPressed: func2),
          )
      ],
    ),
  );
}

void showBottomdialog(
  BuildContext context, {
  required VoidCallback func1,
  required VoidCallback func2,
  required String value1,
  required String value2,
  required bool isOne,
  Color? buttonColor1,
  Color? buttonColor2,
  Color? textColor1,
  Color? textColor2,
  Color? bareerColor,
  String? title,
  String? accentTitle,
}) {
  showModalBottomSheet(
    barrierColor: bareerColor ?? popupGray,
    enableDrag: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => GestureDetector(
      onTap: () => Get.back(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(text: title ?? "", style: kmainheight),
                      TextSpan(
                          text: accentTitle ?? "",
                          style: kmainheight.copyWith(color: mainblue))
                    ]))),
            GestureDetector(
              onTap: func1,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: buttonColor1 ?? mainblue),
                child: Center(
                  child: Text(
                    value1,
                    style: kmainbold.copyWith(
                      color: textColor1 ?? mainWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (isOne == false)
              GestureDetector(
                onTap: func2,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: buttonColor2 ?? maingray),
                  child: Center(
                    child: Text(
                      value2,
                      style: kmainbold.copyWith(
                        color: textColor2 ?? mainWhite,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

void showButtonDialog({
  required String title,
  required String startContent,
  String? highlightContent,
  String? endContent,
  required Function() leftFunction,
  required Function() rightFunction,
  required String rightText,
  required String leftText,
  Color? highlightColor,
  Color? rightColor
}) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: kmainbold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: kmainheight,
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: kmainheight.copyWith(
                            color: highlightColor ?? mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: kmainheight,
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 42,
                        child: CustomExpandedButton(
                            onTap: leftFunction,
                            isBlue: false,
                            title: leftText,
                            isBig: true),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Container(
                        height: 42,
                        child: CustomExpandedButton(
                            onTap: rightFunction,
                            isBlue: true,
                            title: rightText,
                            textColor: rightColor ?? mainWhite,
                            boxColor: rankred,
                            isBig: true),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showButtonDialog2({
  required String title,
  required String startContent,
  String? highlightContent,
  String? endContent,
  required Function() leftFunction,
  required Function() rightFunction,
  required String rightText,
  required String leftText,
  Color? highlightColor,
}) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: kmainbold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: kmainheight,
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: kmainheight.copyWith(
                            color: highlightColor ?? mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: kmainheight,
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 42,
                        child: CustomExpandedButton(
                            onTap: leftFunction,
                            isBlue: false,
                            title: leftText,
                            boxColor: mainblue,
                            isBig: true),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Container(
                        height: 42,
                        child: CustomExpandedButton(
                            onTap: rightFunction,
                            isBlue: true,
                            title: rightText,
                            textColor: highlightColor,
                            boxColor: maingray,
                            isBig: true),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showOneButtonDialog({
  required String title,
  required String startContent,
  String? highlightContent,
  String? endContent,
  required Function() buttonFunction,
  required String buttonText,
  Color? highlightColor,
}) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: kmainbold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: kmainheight,
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: kmainheight.copyWith(
                            color: highlightColor ?? mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: kmainheight,
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomExpandedButton(
                              onTap: buttonFunction,
                              isBlue: true,
                              title: buttonText,
                              isBig: true)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showCustomDialogline2({
  required String title,
  required String startContent,
  String? highlightContent,
  String? endContent,
  Color? highlightColor,
}) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: kmainbold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: kmainheight,
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: kmainheight.copyWith(
                            color: highlightColor ?? mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: kmainheight,
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: CustomExpandedButton(
                  //             onTap: buttonFunction,
                  //             isBlue: true,
                  //             title: buttonText,
                  //             isBig: true)),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showTextFieldDialog({
  required String title,
  required String hintText,
  required String completeText,
  Color? highlightColor,
  required TextEditingController textEditingController,
  required Function() leftFunction,
  required Function() rightFunction,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: mainWhite,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      buttonPadding: const EdgeInsets.all(16),
      title: Text(
        title,
        style: kmainbold,
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: textEditingController,
        maxLines: 3,
        style: kmainheight,
        autofocus: true,
        cursorColor: mainblack,
        cursorWidth: 1.2,
        decoration: InputDecoration(
          filled: true,
          fillColor: cardGray,
          hintText: hintText,
          hintStyle: kmainheight.copyWith(color: maingray),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(8)
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 42,
              child: CustomExpandedButton(
                  onTap: leftFunction, isBlue: false, title: "취소", isBig: true),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Container(
              height: 42,
              child: CustomExpandedButton(
                  onTap: rightFunction,
                  isBlue: true,
                  title: completeText,
                  textColor: highlightColor,
                  boxColor: rankred,
                  isBig: true),
            )),
          ],
        ),
      ],
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showTextFieldDialog2({
  required String title,
  required String hintText,
  required String completeText,
  Color? highlightColor,
  required TextEditingController textEditingController,
  required Function() leftFunction,
  required Function() rightFunction,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: mainWhite,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      buttonPadding: const EdgeInsets.all(16),
      title: Text(
        title,
        style: kmainbold,
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: textEditingController,
        maxLines: 3,
        style: kmainheight,
        autofocus: true,
        cursorColor: mainblack,
        cursorWidth: 1.2,
        decoration: InputDecoration(
          filled: true,
          fillColor: cardGray,
          hintText: hintText,
          hintStyle: kmainheight.copyWith(color: maingray),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(8)
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 42,
              child: CustomExpandedButton(
                  onTap: leftFunction,
                  isBlue: false,
                  title: "취소",
                  isBig: true,
                  boxColor: mainblue),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Container(
              height: 42,
              child: CustomExpandedButton(
                  onTap: rightFunction,
                  isBlue: true,
                  title: completeText,
                  textColor: highlightColor,
                  boxColor: maingray,
                  isBig: true),
            )),
          ],
        ),
      ],
    ),
    barrierDismissible: false,
    barrierColor: popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showWithDrawalDialog({
  required String title,
  required String hintText,
  required TextEditingController textEditingController,
  required bool obscureText,
  required String? Function(String?)? validator,
  required Function() leftFunction,
  required Function() rightFunction,
  required bool isWithdrawal,
}) {
  Get.dialog(
    AlertDialog(
      buttonPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: leftFunction,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                      top: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                    ),
                  ),
                  height: 48,
                  child: const Center(
                    child: Text('취소', style: kmain),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: rightFunction,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                    ),
                  ),
                  height: 48,
                  child: Center(
                    child: Text(
                      isWithdrawal ? '탈퇴' : '확인',
                      style: kmain.copyWith(
                        color: isWithdrawal ? rankred : mainblue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: kmainheight,
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomTextField(
          counterText: null,
          maxLength: null,
          hintText: hintText,
          textController: textEditingController,
          obscureText: obscureText,
          validator: validator,
          maxLines: 1,
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: mainblack.withOpacity(0.3),
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showCustomBottomSheet() {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 48),
      decoration: const BoxDecoration(
        color: mainWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '작성 및 추가',
                style: kNavigationTitle,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: SvgPicture.asset('assets/icons/appbar_exit.svg'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(Get.context!).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SelectProjectScreen(),
                ),
              );
              // Get.to(() => SelectProjectScreen());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/Edit.svg',
                    width: 24,
                  ),
                  decoration: BoxDecoration(
                    color: lightcardgray,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Expanded(
                  child: Text(
                    '포스트 작성하기',
                    style: kmain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(Get.context!).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ProjectAddTitleScreen(screenType: Screentype.add),
                ),
              );
              // Get.to(() => ProjectAddTitleScreen(screenType: Screentype.add));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/Add.svg',
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
                    color: lightcardgray,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Expanded(
                  child: Text(
                    '새로운 커리어 추가하기',
                    style: kmain,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    barrierColor: mainblack.withOpacity(0.3),
    enterBottomSheetDuration: const Duration(milliseconds: 150),
    exitBottomSheetDuration: const Duration(milliseconds: 150),
  );
}

void showCustomSnackbar(
    String? title, String? body, void Function(GetSnackBar)? ontap) {
  Get.snackbar(
    title!,
    body!,
    titleText: Text(
      title,
      style: kmainbold,
    ),
    messageText: Text(
      body,
      style: kmain,
    ),
    onTap: ontap,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 4),
    forwardAnimationCurve: kAnimationCurve,
    reverseAnimationCurve: kAnimationCurve,
    barBlur: 40,
    isDismissible: true,
    borderRadius: 8,
    backgroundColor: mainWhite,
    boxShadows: [
      BoxShadow(
        blurRadius: 3,
        offset: const Offset(0.0, 1.0),
        color: Colors.black.withOpacity(0.1),
      ),
      BoxShadow(
        blurRadius: 2,
        offset: const Offset(0.0, 1.0),
        color: Colors.black.withOpacity(0.06),
      ),
    ],
  );
}

void showBottomSnackbar(String message) {
  Get.closeCurrentSnackbar();
  Get.snackbar(
    '',
    '',
    titleText: Container(),
    messageText: Text(
      message,
      textAlign: TextAlign.center,
      style: kmainheight.copyWith(color: mainWhite),
    ),
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: mainblue,
    padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    borderRadius: 8,
  );
}

void showdisconnectdialog() {
  showCustomDialog("네트워크 연결을 확인해주세요", 1000);
}

void showErrorDialog({
  required String title,
  required String content,
  required Function() leftFunction,
}) {
  Get.dialog(
    AlertDialog(
      buttonPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: leftFunction,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                      top: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                    ),
                  ),
                  height: 48,
                  child: Center(
                    child: Text('닫기', style: kmain),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: kmainbold,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: kmain,
        textAlign: TextAlign.center,
      ),
    ),
    barrierDismissible: false,
    barrierColor: mainblack.withOpacity(0.3),
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showCustomDialog(String title, int duration) {
  Timer _timer = Timer(Duration(milliseconds: duration), () {
    Get.back();
  });
  Get.dialog(
    AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        14,
      ),
      backgroundColor: Colors.white,
      content: Text(
        title,
        style: kmainheight,
        textAlign: TextAlign.center,
      ),
    ),
    barrierDismissible: false,
    barrierColor: mainblack.withOpacity(0.3),
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  ).then((value) {
    if (_timer.isActive) {
      _timer.cancel();
    }
  });
}

void showCustomDatePicker(BuildContext context, SelectDateType selectDateType) {
  DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: DateTime(2000, 1, 1),
    maxTime: DateTime.now(),
    theme: DatePickerTheme(
      headerColor: mainWhite,
      backgroundColor: mainWhite,
      cancelStyle: kmain.copyWith(
        color: mainblack.withOpacity(0.6),
      ),
      itemStyle: kmain,
      doneStyle: kmain.copyWith(
        color: mainblue,
        fontWeight: FontWeight.w500,
      ),
    ),
    onChanged: (date) {
      ProjectAddController.to.isDateChange.value = true;
      print('isdatechange : ${ProjectAddController.to.isDateChange.value}');
    },
    onConfirm: (date) {
      if (selectDateType == SelectDateType.start) {
        ProjectAddController.to.selectedStartDateTime.value = date.toString();
        ProjectAddController.to.validateDate();
        ProjectAddController.to.isDateChange.value = true;

        print('start ${ProjectAddController.to.selectedStartDateTime.value}');
      } else {
        ProjectAddController.to.selectedEndDateTime.value = date.toString();
        ProjectAddController.to.validateDate();
        ProjectAddController.to.isDateChange.value = true;

        print('end ${ProjectAddController.to.selectedEndDateTime.value}');
      }
    },
    currentTime: DateTime.now(),
    locale: LocaleType.ko,
  );
}

void showCustomYearPicker(
    {required int childCount,
    required Widget? Function(BuildContext, int) builder,
    required Function(int)? onItemTapCallback,
    required Function(int)? onSelectedItemChanged}) {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  Get.bottomSheet(
    Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: 250,
        color: mainWhite,
        child: ClickableListWheelScrollView(
          scrollController: scrollController,
          itemCount: childCount,
          itemHeight: 50,
          onItemTapCallback: onItemTapCallback,
          child: ListWheelScrollView.useDelegate(
            controller: scrollController,
            itemExtent: childCount.toDouble(),
            diameterRatio: 3,
            perspective: 0.01,
            magnification: 1.3,
            onSelectedItemChanged: onSelectedItemChanged,
            overAndUnderCenterOpacity: 0.5,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
                builder: builder, childCount: childCount),
          ),
        )),
  );
}
