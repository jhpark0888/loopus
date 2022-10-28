import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_company_screen.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/signup_text_widget.dart';

class SignupTypeScreen extends StatelessWidget {
  SignupTypeScreen({Key? key}) : super(key: key);
  NotificationController controller = Get.put(NotificationController());
  final SignupController _signupController = Get.put(SignupController());
  final GAController _gaController = Get.put(GAController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          color: mainWhite,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomExpandedButton(
                          onTap: () {
                            Get.back();
                          },
                          isBlue: false,
                          title: "이전",
                          isBig: true),
                    ),
                    // const SizedBox(
                    //   width: 14,
                    // ),
                    // Expanded(
                    //   child: CustomExpandedButton(
                    //       onTap: () async {
                    //         //TODO: 학교 선택 시 활성화되어야 함
                    //         if (_signupController.selectedType.value ==
                    //             UserType.student) {
                    //           Get.to(() => SignupUserInfoScreen());
                    //         } else if (_signupController.selectedType.value ==
                    //             UserType.company) {
                    //           // Get.to(() => SignupCompanyScreen());
                    //           showCustomDialog('추후 업데이트 될 예정입니다', 1000);
                    //         } else {
                    //           // Get.to(() => SignupCompanyScreen());
                    //           showCustomDialog('추후 업데이트 될 예정입니다', 1000);
                    //         }
                    //         await _gaController.logScreenView('signup_1');
                    //       },
                    //       isBlue: true,
                    //       title: "다음",
                    //       isBig: true),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    oneLinetext: "회원님의 루프어스", twoLinetext: "가입 유형을 선택해주세요"),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomExpandedButton(
                          onTap: () {
                            _signupController.selectedType(UserType.student);
                            Get.to(() => SignupUserInfoScreen());
                          },
                          isBlue: true,
                          title: "대학생 및 일반 회원",
                          isBig: true),

                      const SizedBox(
                        height: 8,
                      ),
                      CustomExpandedButton(
                          onTap: () {
                            _signupController.selectedType(UserType.company);
                            Get.to(() => SignupCompanyScreen());
                          },
                          isBlue: true,
                          title: "기업 회원",
                          isBig: true),

                      // const SizedBox(
                      //   height: 14,
                      // ),
                      // Obx(
                      //   () => CustomExpandedButton(
                      //       onTap: () {
                      //         _signupController.selectedType(UserType.school);
                      //         showCustomDialog('추후 업데이트 될 예정입니다', 1000);
                      //       },
                      //       isBlue: _signupController.selectedType.value ==
                      //               UserType.school
                      //           ? true
                      //           : false,
                      //       title: "대학 공식 계정",
                      //       isBig: true),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
