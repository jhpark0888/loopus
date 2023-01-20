import 'dart:async';

import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

// void showContentModal(BuildContext context) {
//   final LocalDataController _localDataController =
//       Get.put(LocalDataController());
//   final NotificationController _notificationController =
//       Get.put(NotificationController());
//   RxBool isModalNextBtnClicked = false.obs;
//   RxBool isCheckOne = false.obs;
//   RxBool isCheckTwo = false.obs;
//   RxBool isCheckThree = false.obs;
//   RxBool isCheckFour = false.obs;
//   showModalBottomSheet(
//     enableDrag: false,
//     context: context,
//     builder: (context) => Obx(
//       () => Padding(
//         padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (isCheckOne.value == true &&
//                     isCheckTwo.value == true &&
//                     isCheckThree.value == true &&
//                     isCheckFour.value == true) {
//                   isCheckOne.value = false;
//                   isCheckTwo.value = false;
//                   isCheckThree.value = false;
//                   isCheckFour.value = false;
//                 } else {
//                   isCheckOne.value = true;
//                   isCheckTwo.value = true;
//                   isCheckThree.value = true;
//                   isCheckFour.value = true;
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: (isCheckOne.value == true &&
//                             isCheckTwo.value == true &&
//                             isCheckThree.value == true &&
//                             isCheckFour.value == true)
//                         ? AppColors.mainblue
//                         : AppColors.mainblack.withOpacity(0.6),
//                     width: 1.2,
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Row(
//                   children: [
//                     (isCheckOne.value == true &&
//                             isCheckTwo.value == true &&
//                             isCheckThree.value == true &&
//                             isCheckFour.value == true)
//                         ? SvgPicture.asset(
//                             'assets/icons/Check_Active_blue.svg',
//                           )
//                         : SvgPicture.asset('assets/icons/Uncheck_rect.svg'),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     Text(
//                       '모두 동의합니다',
//                       style: (isCheckOne.value == true &&
//                               isCheckTwo.value == true &&
//                               isCheckThree.value == true &&
//                               isCheckFour.value == true)
//                           ? MyTextTheme.tempfont(context).copyWith(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.mainblue,
//                             )
//                           : MyTextTheme.tempfont(context).copyWith(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.mainblack.withOpacity(0.6),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {
//                     isCheckOne.value = !isCheckOne.value;
//                   },
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         (isCheckOne.value == true)
//                             ? 'assets/icons/Uncheck_norect_blue.svg'
//                             : 'assets/icons/Uncheck_norect.svg',
//                         color: isCheckOne.value == true
//                             ? AppColors.mainblue
//                             : AppColors.mainblack.withOpacity(0.6),
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         '(필수)',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckOne.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         '서비스 이용약관',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckOne.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                     onTap: () {
//                       Get.to(() => WebViewScreen(url: kTermsOfService));
//                     },
//                     // child: SvgPicture.asset('assets/icons/Arrow_right.svg'),
//                     child: SizedBox.shrink()),
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {
//                     isCheckTwo.value = !isCheckTwo.value;
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         (isCheckTwo.value == true)
//                             ? 'assets/icons/Uncheck_norect_blue.svg'
//                             : 'assets/icons/Uncheck_norect.svg',
//                         color: isCheckTwo.value == true
//                             ? AppColors.mainblue
//                             : AppColors.mainblack.withOpacity(0.6),
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         '(필수)',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckTwo.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         '개인정보 처리방침',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckTwo.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Get.to(() => WebViewScreen(url: kPrivacyPolicy));
//                   },
//                   child: SvgPicture.asset('assets/icons/arrow_right.svg'),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {
//                     isCheckFour.value = !isCheckFour.value;
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         (isCheckFour.value == true)
//                             ? 'assets/icons/Uncheck_norect_blue.svg'
//                             : 'assets/icons/Uncheck_norect.svg',
//                         color: isCheckFour.value == true
//                             ? AppColors.mainblue
//                             : AppColors.mainblack.withOpacity(0.6),
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Text(
//                         '(필수)',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckFour.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         '개인정보 수집동의',
//                         style: MyTextTheme.tempfont(context).copyWith(
//                           color: isCheckFour.value == true
//                               ? AppColors.mainblue
//                               : AppColors.mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Get.to(() =>
//                         WebViewScreen(url: kPersonalInfoCollectionAgreement));
//                   },
//                   child: SvgPicture.asset('assets/icons/arrow_right.svg'),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () {
//                 isCheckThree.value = !isCheckThree.value;
//               },
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     (isCheckThree.value == true)
//                         ? 'assets/icons/Uncheck_norect_blue.svg'
//                         : 'assets/icons/Uncheck_norect.svg',
//                     color: isCheckThree.value == true
//                         ? AppColors.mainblue
//                         : AppColors.mainblack.withOpacity(0.6),
//                   ),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   Text(
//                     '(선택)',
//                     style: MyTextTheme.tempfont(context).copyWith(
//                       color: isCheckThree.value == true
//                           ? AppColors.mainblue
//                           : AppColors.mainblack.withOpacity(0.6),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
//                   Text(
//                     '루프어스 프로모션 알림 수신 동의',
//                     style: MyTextTheme.tempfont(context).copyWith(
//                       color: isCheckThree.value == true
//                           ? AppColors.mainblue
//                           : AppColors.mainblack.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             GestureDetector(
//               onTap: (isCheckOne.value == true &&
//                       isCheckTwo.value == true &&
//                       isModalNextBtnClicked.value == false)
//                   ? () {
//                       isModalNextBtnClicked.value = true;
//                       Get.to(
//                         () => SignupTypeScreen(),
//                         preventDuplicates: false,
//                       );

//                       _localDataController.agreeProNoti(isCheckThree.value);
//                       _notificationController.changePromotionAlarmState(
//                           _localDataController.isUserAgreeProNoti);
//                       if (isCheckThree.value == true) {
//                         SchedulerBinding.instance!.addPostFrameCallback((_) {
//                           showCustomDialog(
//                               '프로모션 알림 수신에 동의하셨습니다\n' +
//                                   '(${DateFormat('yy.MM.dd').format(DateTime.now())})',
//                               1000);
//                         });
//                       }
//                     }
//                   : () {},
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: (isCheckOne.value == true &&
//                           isCheckTwo.value == true &&
//                           isCheckFour.value == true)
//                       ? AppColors.mainblue
//                       : Color(0xffe7e7e7),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '다음',
//                     style: MyTextTheme.tempfont(context).copyWith(
//                       color: (isCheckOne.value == true &&
//                               isCheckTwo.value == true &&
//                               isCheckFour.value == true)
//                           ? AppColors.mainWhite
//                           : AppColors.mainblack.withOpacity(0.38),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//     barrierColor: AppColors.mainblack.withOpacity(0.3),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(16),
//         topRight: Radius.circular(16),
//       ),
//     ),
//   );
// }

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
    barrierColor: AppColors.popupGray,
    context: context,
    builder: (context) => CupertinoActionSheet(
      cancelButton: cancleButton
          ? GetBack != null
              ? CupertinoActionSheetAction(
                  child: Text(
                    "닫기",
                    style: MyTextTheme.main(context),
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
                    color: AppColors.rankred,
                  ),
                  child: CupertinoActionSheetAction(
                      child: const Text(
                        "계정 신고하기",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: AppColors.mainWhite,
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
            color: isValue1Red ? AppColors.rankred : AppColors.mainWhite,
          ),
          child: CupertinoActionSheetAction(
            child: Text(
              value1,
              style: MyTextTheme.main(context).copyWith(
                color: isValue1Red ? AppColors.mainWhite : AppColors.mainblack,
              ),
            ),
            onPressed: func1,
          ),
        ),
        if (isOne == false)
          CupertinoActionSheetAction(
              child: Text(
                value2,
                style: MyTextTheme.main(context).copyWith(
                  color: isValue2Red ? AppColors.rankred : AppColors.mainWhite,
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
    barrierColor: AppColors.mainblack.withOpacity(
      0.3,
    ),
    context: context,
    builder: (context) => CupertinoActionSheet(
      cancelButton: Column(children: []),
      actions: [
        Container(
          color: AppColors.rankred,
          child: CupertinoActionSheetAction(
            child: Text(
              value1,
              style: MyTextTheme.main(context).copyWith(
                color: isValue1Red ? AppColors.rankred : AppColors.mainblack,
              ),
            ),
            onPressed: func1,
          ),
        ),
        if (isOne == false)
          Container(
            color: AppColors.mainWhite,
            child: CupertinoActionSheetAction(
                child: Text(
                  value2,
                  style: MyTextTheme.main(context).copyWith(
                    color:
                        isValue2Red ? AppColors.rankred : AppColors.mainblack,
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
    barrierColor: bareerColor ?? AppColors.popupGray,
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
                      TextSpan(
                          text: title ?? "",
                          style: MyTextTheme.mainheight(context)),
                      TextSpan(
                          text: accentTitle ?? "",
                          style: MyTextTheme.mainheight(context)
                              .copyWith(color: AppColors.mainblue))
                    ]))),
            GestureDetector(
              onTap: func1,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: buttonColor1 ?? AppColors.mainblue),
                child: Center(
                  child: Text(
                    value1,
                    style: MyTextTheme.main(context).copyWith(
                      color: textColor1 ?? AppColors.mainWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (isOne == false)
              SafeArea(
                child: GestureDetector(
                  onTap: func2,
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: buttonColor2 ?? AppColors.maingray),
                    child: Center(
                      child: Text(
                        value2,
                        style: MyTextTheme.main(context).copyWith(
                          color: textColor2 ?? AppColors.mainWhite,
                        ),
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

void showButtonDialog(
    {required String title,
    required String startContent,
    String? highlightContent,
    String? endContent,
    required Function() leftFunction,
    required Function() rightFunction,
    required String rightText,
    required String leftText,
    Color? highlightColor,
    Color? rightColor}) {
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
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: MyTextTheme.mainbold(Get.context!),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: MyTextTheme.mainheight(Get.context!),
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: MyTextTheme.mainheight(Get.context!).copyWith(
                            color: highlightColor ?? AppColors.mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: MyTextTheme.mainheight(Get.context!),
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
                            textColor: rightColor ?? AppColors.mainWhite,
                            boxColor: AppColors.rankred,
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
    barrierColor: AppColors.popupGray,
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
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: MyTextTheme.mainbold(Get.context!),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: MyTextTheme.mainheight(Get.context!),
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: MyTextTheme.mainheight(Get.context!).copyWith(
                            color: highlightColor ?? AppColors.mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: MyTextTheme.mainheight(Get.context!),
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
                            boxColor: AppColors.mainblue,
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
                            boxColor: AppColors.maingray,
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
    barrierColor: AppColors.popupGray,
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
  Color? btnColor,
  Color? btnTextColor,
}) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: MyTextTheme.mainbold(Get.context!),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: MyTextTheme.mainheight(Get.context!),
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: MyTextTheme.mainheight(Get.context!).copyWith(
                            color: highlightColor ?? AppColors.mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: MyTextTheme.mainheight(Get.context!),
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
                          child: SizedBox(
                        height: 42,
                        child: CustomExpandedButton(
                          onTap: buttonFunction,
                          isBlue: true,
                          title: buttonText,
                          isBig: true,
                          boxColor: btnColor,
                          textColor: btnTextColor,
                        ),
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
    barrierColor: AppColors.popupGray,
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
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.mainWhite),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    style: MyTextTheme.main(Get.context!),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: startContent,
                        style: MyTextTheme.mainheight(Get.context!),
                      ),
                      TextSpan(
                        text: highlightContent ?? "",
                        style: MyTextTheme.mainheight(Get.context!).copyWith(
                            color: highlightColor ?? AppColors.mainblue),
                      ),
                      TextSpan(
                        text: endContent,
                        style: MyTextTheme.mainheight(Get.context!),
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
    barrierColor: AppColors.popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showTextFieldDialog({
  required String title,
  required String hintText,
  String? leftText,
  required String rightText,
  required TextEditingController textEditingController,
  required Function() leftFunction,
  required Function() rightFunction,
  Color? leftBoxColor,
  Color? rightBoxColor,
  Color? leftTextColor,
  Color? rightTextColor,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.mainWhite,
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
        style: MyTextTheme.mainbold(Get.context!),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: textEditingController,
        maxLines: 3,
        style: MyTextTheme.mainheight(Get.context!),
        autofocus: true,
        cursorColor: AppColors.mainblack,
        cursorWidth: 1.2,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cardGray,
          hintText: hintText,
          hintStyle: MyTextTheme.mainheight(Get.context!)
              .copyWith(color: AppColors.maingray),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: const OutlineInputBorder(
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
                child: SizedBox(
              height: 42,
              child: CustomExpandedButton(
                onTap: leftFunction,
                isBlue: false,
                title: leftText ?? "취소",
                isBig: true,
                boxColor: leftBoxColor ?? AppColors.maingray,
                textColor: leftTextColor,
              ),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: SizedBox(
              height: 42,
              child: CustomExpandedButton(
                  onTap: rightFunction,
                  isBlue: true,
                  title: rightText,
                  textColor: rightTextColor,
                  boxColor: rightBoxColor,
                  isBig: true),
            )),
          ],
        ),
      ],
    ),
    barrierDismissible: false,
    barrierColor: AppColors.popupGray,
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
                  child: Center(
                    child: Text('취소', style: MyTextTheme.main(Get.context!)),
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
                      style: MyTextTheme.main(Get.context!).copyWith(
                        color: isWithdrawal
                            ? AppColors.rankred
                            : AppColors.mainblue,
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
        style: MyTextTheme.mainheight(Get.context!),
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
    barrierColor: AppColors.mainblack.withOpacity(0.3),
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showCustomBottomSheet() {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 48),
      decoration: const BoxDecoration(
        color: AppColors.mainWhite,
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
              Text(
                '작성 및 추가',
                style: MyTextTheme.navigationTitle(Get.context!),
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
                    color: AppColors.lightcardgray,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    '포스트 작성하기',
                    style: MyTextTheme.main(Get.context!),
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
                    color: AppColors.lightcardgray,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    '새로운 커리어 추가하기',
                    style: MyTextTheme.main(Get.context!),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    barrierColor: AppColors.mainblack.withOpacity(0.3),
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
      style: MyTextTheme.mainbold(Get.context!),
    ),
    messageText: Text(
      body,
      style: MyTextTheme.main(Get.context!),
    ),
    onTap: ontap,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 4),
    forwardAnimationCurve: kAnimationCurve,
    reverseAnimationCurve: kAnimationCurve,
    barBlur: 40,
    isDismissible: true,
    borderRadius: 8,
    backgroundColor: AppColors.mainWhite,
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
      style: MyTextTheme.mainheight(Get.context!)
          .copyWith(color: AppColors.mainWhite),
    ),
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.mainblue,
    padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                    child: Text('닫기', style: MyTextTheme.main(Get.context!)),
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
        style: MyTextTheme.mainbold(Get.context!),
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: MyTextTheme.main(Get.context!),
        textAlign: TextAlign.center,
      ),
    ),
    barrierDismissible: false,
    barrierColor: AppColors.mainblack.withOpacity(0.3),
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}

void showPopUpDialog(String title, String content) {
  Get.dialog(
    AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: Text(
        title,
        style: MyTextTheme.mainbold(Get.context!),
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: MyTextTheme.mainheight(Get.context!),
        textAlign: TextAlign.center,
      ),
    ),
    barrierColor: AppColors.mainblack.withOpacity(0.3),
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
      // title: Text(title,
      //   style: MyTextTheme.mainheight(context),
      //   textAlign: TextAlign.center,),
      contentPadding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        14,
      ),
      backgroundColor: Colors.white,
      content: Text(
        title,
        style: MyTextTheme.mainheight(Get.context!),
        textAlign: TextAlign.center,
      ),
    ),
    barrierDismissible: false,
    barrierColor: AppColors.mainblack.withOpacity(0.3),
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
      headerColor: AppColors.mainWhite,
      backgroundColor: AppColors.mainWhite,
      cancelStyle: MyTextTheme.main(context).copyWith(
        color: AppColors.mainblack.withOpacity(0.6),
      ),
      itemStyle: MyTextTheme.main(context),
      doneStyle: MyTextTheme.main(context).copyWith(
        color: AppColors.mainblue,
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
        color: AppColors.mainWhite,
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

void showSignUpEmailHint() {
  Get.dialog(
    AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      content: Image.asset("assets/illustrations/emailhint_image.png"),
    ),
    barrierColor: AppColors.popupGray,
    transitionCurve: kAnimationCurve,
    transitionDuration: kAnimationDuration,
  );
}
