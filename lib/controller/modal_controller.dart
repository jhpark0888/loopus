import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';

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

  void showButtonDialog(
      String title, Function() yesfunction, Function() nofunction) {
    Get.dialog(
      AlertDialog(
        actions: [
          TextButton(
            onPressed: yesfunction,
            child: Center(child: Text('네')),
          ),
          TextButton(
            onPressed: nofunction,
            child: Center(child: Text('아니오')),
          ),
        ],
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
      barrierDismissible: true,
      barrierColor: mainblack.withOpacity(0.3),
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  void showContentModal(BuildContext context) {
    showModalBottomSheet(
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
