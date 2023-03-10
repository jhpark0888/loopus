import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

class SignupCompanyScreen extends StatelessWidget {
  SignupCompanyScreen({Key? key}) : super(key: key);

  final SignupController _signupController = Get.find();

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
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
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Obx(
                    () => CustomExpandedButton(
                        onTap: () async {
                          if (_signupController.isCompInfoCheck.value) {
                            await inquiryRequest(InquiryType.company_signup,
                                    email: _signupController
                                        .compEmailController.text
                                        .trim(),
                                    name: _signupController
                                        .compNameController.text
                                        .trim())
                                .then((value) {
                              if (value.isError == false) {
                                showOneButtonDialog(
                                    title: "메일을 보냈어요",
                                    startContent:
                                        "메일에 첨부된 양식을 작성해주시면,\n빠른 시일 내 가입을 도와드릴게요",
                                    buttonFunction: () {
                                      dialogBack();
                                    },
                                    btnColor: AppColors.mainblue,
                                    btnTextColor: AppColors.mainWhite,
                                    buttonText: "확인");
                              } else {
                                errorSituation(value);
                              }
                            });
                          }
                        },
                        isBlue: _signupController.isCompInfoCheck.value,
                        title: "다음",
                        isBig: true),
                  ),
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
                    highlightText: "기업 회원님 ",
                    oneLinetext: "가입을 위해",
                    twoLinetext: "이메일 주소를 남겨주세요"),
                LabelTextFieldWidget(
                  label: "기업 이름",
                  hintText: "루프어스는 모든 기업을 환영해요",
                  textController: _signupController.compNameController,
                ),
                const SizedBox(height: 24),
                LabelTextFieldWidget(
                  label: "연락 가능한 이메일 주소",
                  hintText: "담당자 이메일 주소를 입력해주세요",
                  textController: _signupController.compEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "입력해주신 메일 주소를 통해\n루프어스 가입을 위한 절차 메일을 보내드릴게요",
                  style: MyTextTheme.mainheight(context)
                      .copyWith(color: AppColors.maingray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
