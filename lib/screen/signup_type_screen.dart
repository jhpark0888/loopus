import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/screen/signup_company_screen.dart';
import 'package:loopus/screen/signup_department_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class SignupTypeScreen extends StatelessWidget {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              //TODO: 학교 선택 시 활성화되어야 함
              if (signupController.selectedType.value == UserType.student) {
                Get.to(() => SignupCampusInfoScreen());
              } else if (signupController.selectedType.value ==
                  UserType.professer) {
                Get.to(() => SignupCompanyScreen());
              } else {
                Get.to(() => SignupCompanyScreen());
              }
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '가입 유형을 선택해주세요',
                style: kSubTitle1Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserTypeWidget(
                    title: '대학생',
                    userType: UserType.student,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  UserTypeWidget(
                    title: '기업',
                    userType: UserType.company,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  UserTypeWidget(
                    title: '교직원',
                    userType: UserType.professer,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserTypeWidget extends StatelessWidget {
  UserTypeWidget({
    Key? key,
    required this.userType,
    required this.title,
  }) : super(key: key);

  final SignupController signupController = Get.put(SignupController());
  final UserType userType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          signupController.selectedType.value = userType;
        },
        child: Obx(
          () => Container(
            decoration: kCardStyle.copyWith(
                color: (signupController.selectedType.value == userType)
                    ? mainblue
                    : mainWhite),
            padding: const EdgeInsets.all(24),
            child: Text(
              title,
              style: kSubTitle3Style.copyWith(
                  color: (signupController.selectedType.value == userType)
                      ? mainWhite
                      : mainblack),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
