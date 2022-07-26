import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/screen/signup_pw_screen.dart';
import 'package:loopus/screen/univ_dept_search_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../utils/check_form_validate.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupUserInfoScreen extends StatelessWidget {
  SignupUserInfoScreen({Key? key}) : super(key: key);

  final SignupController _signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            color: mainWhite,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Obx(
                () => CustomExpandedButton(
                    onTap: () {
                      if (_signupController.isUserInfoFill.value) {
                        Get.to(() => SignupEmailcheckScreen());
                      }
                    },
                    isBlue: _signupController.isUserInfoFill.value,
                    title: "다음",
                    isBig: true),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    highlightText: "루프어스",
                    oneLinetext: "에 오신걸 환영해요!",
                    twoLinetext: "본인 정보를 입력해주세요"),
                LabelTextFieldWidget(
                    label: "이름",
                    hintText: "본인 이름을 입력하세요",
                    textController: _signupController.namecontroller),
                LabelTextFieldWidget(
                    ontap: () {
                      Get.to(() => UnivDeptSearchScreen(
                            searchType: UnivDeptSearchType.univ,
                          ));
                    },
                    label: "대학",
                    hintText: "출신 대학을 입력하세요",
                    readOnly: true,
                    textController: _signupController.univcontroller),
                LabelTextFieldWidget(
                    ontap: () {
                      if (_signupController.selectUniv.value.id == 0) {
                        showCustomDialog("출신 대학을 먼저 선택해주세요", 1000);
                      } else {
                        Get.to(() => UnivDeptSearchScreen(
                              searchType: UnivDeptSearchType.dept,
                            ));
                      }
                    },
                    label: "학과",
                    hintText: "출신 학과를 입력하세요",
                    readOnly: true,
                    textController: _signupController.departmentcontroller),
                LabelTextFieldWidget(
                    ontap: () {
                      int year = DateTime.now().year;

                      showCustomYearPicker(
                          childCount: 50,
                          builder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (year - (50 - (index + 1))).toString(),
                                  style: kmainbold,
                                ),
                              ),
                          onItemTapCallback: (index) {
                            _signupController.admissioncontroller.text =
                                (year - (50 - (index + 1))).toString();
                            Get.back();
                          });
                    },
                    label: "입학 연도",
                    hintText: "입학 연도를 입력하세요",
                    readOnly: true,
                    textController: _signupController.admissioncontroller),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "대학 인증을 위해 정확한 정보를 입력해주세요",
                  style: kmain.copyWith(color: maingray),
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
