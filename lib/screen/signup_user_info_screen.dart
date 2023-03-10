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
import 'package:loopus/screen/signup_email_pw_screen.dart';
import 'package:loopus/screen/univ_dept_search_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../utils/check_form_validate.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupUserInfoScreen extends StatelessWidget {
  SignupUserInfoScreen(
      {Key? key, this.isReCertification = false, this.reCertPw})
      : super(key: key);

  late final SignupController _signupController = Get.put(SignupController(
      isReCertification: isReCertification, reCertPw: reCertPw));
  final bool isReCertification;
  String? reCertPw;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.mainWhite,
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
                          title: "??????",
                          isBig: true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => CustomExpandedButton(
                            onTap: () {
                              if (_signupController.isUserInfoCheck.value) {
                                Get.to(() => SignupEmailPwScreen());
                              }
                            },
                            isBlue: _signupController.isUserInfoCheck.value,
                            title: "??????",
                            isBig: true),
                      ),
                    ),
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
                isReCertification == false
                    ? SignUpTextWidget(
                        highlightText: "????????????",
                        oneLinetext: "??? ????????? ????????????",
                        twoLinetext: "?????? ????????? ??????????????????")
                    : SignUpTextWidget(
                        highlightText: "???????????? ??????",
                        oneLinetext: "",
                        twoLinetext: "????????? ????????? ??????????????????"),
                LabelTextFieldWidget(
                    label: "??????",
                    hintText: "?????? ????????? ???????????????",
                    textController: _signupController.namecontroller),
                const SizedBox(
                  height: 24,
                ),
                LabelTextFieldWidget(
                    ontap: () {
                      Get.to(() => UnivDeptSearchScreen(
                            searchType: UnivDeptSearchType.univ,
                          ));
                    },
                    label: "??????",
                    hintText: "?????? ????????? ???????????????",
                    readOnly: true,
                    textController: _signupController.univcontroller),
                const SizedBox(
                  height: 24,
                ),
                LabelTextFieldWidget(
                    ontap: () {
                      if (_signupController.selectUniv.value.id == 0) {
                        showCustomDialog("?????? ????????? ?????? ??????????????????", 1000);
                      } else {
                        Get.to(() => UnivDeptSearchScreen(
                              searchType: UnivDeptSearchType.dept,
                            ));
                      }
                    },
                    label: "??????",
                    hintText: "?????? ????????? ???????????????",
                    readOnly: true,
                    textController: _signupController.departmentcontroller),
                const SizedBox(
                  height: 24,
                ),
                LabelTextFieldWidget(
                    ontap: () {
                      int year = DateTime.now().year;

                      showCustomYearPicker(
                          childCount: 50,
                          builder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (year - index).toString(),
                                  style: MyTextTheme.mainbold(context),
                                ),
                              ),
                          onItemTapCallback: (index) {
                            _signupController.admissioncontroller.text =
                                (year - index).toString();
                            Get.back();
                          },
                          onSelectedItemChanged: (index) {
                            _signupController.admissioncontroller.text =
                                (year - index).toString();
                          });
                    },
                    label: "?????? ??????",
                    hintText: "?????? ????????? ???????????????",
                    readOnly: true,
                    textController: _signupController.admissioncontroller),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "?????? ????????? ?????? ????????? ????????? ??????????????????",
                  style: MyTextTheme.main(context)
                      .copyWith(color: AppColors.maingray),
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
