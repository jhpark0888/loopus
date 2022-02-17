import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_department_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class SignupCampusInfoScreen extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final GAController _gaController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              //TODO: 학교 선택 시 활성화되어야 함
              signupController.isdeptSearchLoading(true);
              Get.to(() => SignupDepartmentScreen());

              getdeptlist().then((value) {
                signupController.isdeptSearchLoading(false);
              });
              await _gaController.logScreenView('signup_2');
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
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '어느 대학',
                      style: kSubTitle1Style.copyWith(
                        color: mainblue,
                      ),
                    ),
                    TextSpan(
                      text: '에 재학 중이신가요?',
                      style: kSubTitle1Style,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 16,
              ),
              //Todo: UX Writing
              const Text(
                '재학 중인 학교의 학생들과 정보를 교류할 수 있어요',
                style: kBody2Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              // CustomTextField(
              //   counterText: null,
              //   maxLength: null,
              //   textController: signupController.campusnamecontroller,
              //   hintText: '학교 이름 검색',
              //   obscureText: false,
              //   validator: null,
              //   maxLines: 1,
              // ),
              TextFormField(
                initialValue: '인천대학교',
                readOnly: true,

                style: kSubTitle3Style.copyWith(
                  height: 1.0,
                  color: mainblack.withOpacity(0.6),
                ),

                // controller: signupController.campusnamecontroller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 12),
                  isDense: true,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: mainblack, width: 1.2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: const BorderSide(color: mainblack, width: 1.2),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: const BorderSide(color: mainblack, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '아직은 인천대학교 학생만 가입할 수 있어요. 곧 업데이트 될 예정입니다!',
                style: kCaptionStyle.copyWith(
                  color: mainblack.withOpacity(0.6),
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
