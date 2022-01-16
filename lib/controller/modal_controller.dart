import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../constant.dart';

class ModalController extends GetxController with GetTickerProviderStateMixin {
  static ModalController get to => Get.find();
  late AnimationController _animationController;
  RxBool isModalNextBtnClicked = false.obs;
  RxBool isCheckOne = false.obs;
  RxBool isCheckTwo = false.obs;
  RxBool isCheckThree = false.obs;

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
                    decoration: BoxDecoration(
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
                        style: kBody2Style.copyWith(
                          color: mainpink,
                          fontWeight: FontWeight.bold,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        titlePadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
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
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  void showTextFieldDialog({
    required String title,
    required String hintText,
    required TextEditingController textEditingController,
    required bool obscureText,
    required String? Function(String?)? validator,
    required Function() yesfunction,
    required Function() nofunction,
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
                  onTap: yesfunction,
                  child: Container(
                    decoration: BoxDecoration(
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
                        '취소',
                        style: kBody2Style.copyWith(
                          color: mainblack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: nofunction,
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
                        style: kBody2Style.copyWith(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 24),
        titlePadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: kSubTitle4Style,
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomTextField(
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
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 300),
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
                      isCheckThree.value == true) {
                    isCheckOne.value = false;
                    isCheckTwo.value = false;
                    isCheckThree.value = false;
                  } else {
                    isCheckOne.value = true;
                    isCheckTwo.value = true;
                    isCheckThree.value = true;
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
                              isCheckThree.value == true)
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
                              isCheckThree.value == true)
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
                                isCheckThree.value == true)
                            ? kSubTitle2Style.copyWith(
                                fontWeight: FontWeight.normal,
                                color: mainblue,
                              )
                            : kSubTitle2Style.copyWith(
                                fontWeight: FontWeight.normal,
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
                    onTap: () {
                      isCheckOne.value = !isCheckOne.value;
                      print(isCheckOne);
                      print(isCheckTwo);
                      print(isCheckThree);
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
              GestureDetector(
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
                      '루퍼스 추천 정보 수신 동의',
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
                        Get.to(() => SignupCampusInfoScreen(),
                            preventDuplicates: false);
                        isModalNextBtnClicked.value = false;
                      }
                    : () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        (isCheckOne.value == true && isCheckTwo.value == true)
                            ? mainblue
                            : Color(0xffe7e7e7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '다음',
                      style: kButtonStyle.copyWith(
                        color: (isCheckOne.value == true &&
                                isCheckTwo.value == true)
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
}
