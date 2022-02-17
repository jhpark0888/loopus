import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/select_project_screen.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/screen/signup_type_screen.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../constant.dart';

class ModalController extends GetxController with GetTickerProviderStateMixin {
  static ModalController get to => Get.find();
  late AnimationController _animationController;
  RxBool isModalNextBtnClicked = false.obs;
  RxBool isCheckOne = false.obs;
  RxBool isCheckTwo = false.obs;
  RxBool isCheckThree = false.obs;
  RxBool isCheckFour = false.obs;

  @override
  void onInit() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = Duration(milliseconds: 300);
    _animationController.reverseDuration = Duration(milliseconds: 200);
    _animationController.drive(CurveTween(curve: Curves.easeInOut));
    super.onInit();
  }

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
            style: kBody2Style,
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
              style: kButtonStyle.copyWith(
                color: isValue1Red ? mainpink : mainblack,
              ),
            ),
            onPressed: func1,
          ),
          if (isOne == false)
            CupertinoActionSheetAction(
                child: Text(
                  value2,
                  style: kButtonStyle.copyWith(
                    color: isValue2Red ? mainpink : mainblack,
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
          style: kSubTitle4Style,
          textAlign: TextAlign.center,
        ),
      ),
      barrierDismissible: false,
      barrierColor: mainblack.withOpacity(0.3),
      transitionCurve: kAnimationCurve,
      transitionDuration: kAnimationDuration,
    );
    Future.delayed(Duration(milliseconds: duration), () {
      Get.back();
    });
  }

  void showButtonDialog({
    required String title,
    required String content,
    required Function() leftFunction,
    required Function() rightFunction,
    required String rightText,
    required String leftText,
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
                      child: Text(
                        leftText,
                        style: kButtonStyle.copyWith(
                          color: mainpink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: rightFunction,
                  child: Container(
                    decoration: const BoxDecoration(
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
                        rightText,
                        style: kBody2Style,
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
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: kSubTitle4Style,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: kBody1Style,
          textAlign: TextAlign.center,
        ),
      ),
      barrierDismissible: false,
      barrierColor: mainblack.withOpacity(0.3),
      transitionCurve: kAnimationCurve,
      transitionDuration: kAnimationDuration,
    );
  }

  void showTextFieldDialog({
    required String title,
    required String hintText,
    required TextEditingController textEditingController,
    required bool obscureText,
    required String? Function(String?)? validator,
    required Function() leftFunction,
    required Function() rightFunction,
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
                      child: Text('취소', style: kBody2Style),
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
                        '확인',
                        style: kButtonStyle.copyWith(
                          color: mainblue,
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
          style: kSubTitle4Style,
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

  void showContentModal(BuildContext context) {
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
                            ? kSubTitle2Style.copyWith(
                                fontWeight: FontWeight.w400,
                                color: mainblue,
                              )
                            : kSubTitle2Style.copyWith(
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
                          style: kButtonStyle.copyWith(
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
                          style: kBody2Style.copyWith(
                            color: isCheckOne.value == true
                                ? mainblue
                                : mainblack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/Arrow_right.svg'),
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
                          style: kButtonStyle.copyWith(
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
                          style: kBody2Style.copyWith(
                            color: isCheckTwo.value == true
                                ? mainblue
                                : mainblack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/Arrow_right.svg'),
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
                          style: kButtonStyle.copyWith(
                            color: isCheckFour.value == true
                                ? mainblue
                                : mainblack.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '개인정보수집 동의',
                          style: kBody2Style.copyWith(
                            color: isCheckFour.value == true
                                ? mainblue
                                : mainblack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/Arrow_right.svg'),
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
                      style: kBody2Style.copyWith(
                        color: isCheckThree.value == true
                            ? mainblue
                            : mainblack.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '루프어스 프로모션 정보 수신 동의',
                      style: kBody2Style.copyWith(
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
                        Get.to(() => SignupTypeScreen(),
                            preventDuplicates: false);
                        isModalNextBtnClicked.value = false;
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
                      style: kButtonStyle.copyWith(
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
      transitionAnimationController: _animationController,
      barrierColor: mainblack.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }

  void showBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 12, 48),
        decoration: BoxDecoration(
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
                Text(
                  '작성 및 추가',
                  style: kHeaderH1Style,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: SvgPicture.asset('assets/icons/Close.svg'),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => SelectProjectScreen());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/icons/Edit.svg',
                      width: 24,
                    ),
                    decoration: BoxDecoration(
                      color: mainlightgrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      '포스팅 작성하기',
                      style: kSubTitle3Style,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => ProjectAddTitleScreen(screenType: Screentype.add));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/icons/Add.svg',
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      color: mainlightgrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      '새로운 활동 추가하기',
                      style: kSubTitle3Style,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      barrierColor: mainblack.withOpacity(0.3),
      enterBottomSheetDuration: Duration(milliseconds: 150),
      exitBottomSheetDuration: Duration(milliseconds: 150),
    );
  }

  void showDatePicker(BuildContext context, SelectDateType selectDateType) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime.now(),
      theme: DatePickerTheme(
        headerColor: mainWhite,
        backgroundColor: mainWhite,
        cancelStyle: kSubTitle3Style.copyWith(
          color: mainblack.withOpacity(0.6),
        ),
        itemStyle: kSubTitle3Style,
        doneStyle: kSubTitle3Style.copyWith(
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

  void showCustomSnackbar(String? title, String? body) {
    Get.snackbar(
      title!,
      body!,
      titleText: Text(
        title,
        style: kButtonStyle,
      ),
      messageText: Text(
        body,
        style: kBody2Style,
      ),
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
}
