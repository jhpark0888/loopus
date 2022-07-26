import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/screen/univ_dept_search_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../utils/check_form_validate.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupPwScreen extends StatelessWidget {
  SignupPwScreen({Key? key}) : super(key: key);

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
                    onTap: () async {
                      if (_signupController.isPassWordCheck.value) {
                        await signupRequest().then((value) async {
                          final GAController _gaController = GAController();

                          if (value.isError == false) {
                            // String token = jsonDecode(response.body)['token'];
                            // String userid = jsonDecode(response.body)['user_id'];

                            // await storage.write(key: 'token', value: token);
                            // await storage.write(key: 'id', value: userid);
                            //!GA
                            await _gaController.logSignup();
                            await _gaController.setUserProperties(
                                value.data['user_id'],
                                _signupController.selectDept.value.deptname);

                            // Get.offAll(() => App());

                            // SchedulerBinding.instance!.addPostFrameCallback((_) {
                            //   showCustomDialog('관심태그 기반으로 홈 화면을 구성했어요', 1500);
                            // });

                            await _gaController.logScreenView('signup_6');
                            Get.offAll(() => SignupCompleteScreen(
                                  emailId: _signupController
                                          .emailidcontroller.text +
                                      "@" +
                                      _signupController.selectUniv.value.email,
                                  password:
                                      _signupController.passwordcontroller.text,
                                ));
                          } else {
                            await _gaController.logScreenView('signup_6');
                            errorSituation(value);
                          }
                        });
                      }
                    },
                    isBlue: _signupController.isPassWordCheck.value,
                    title: "다음",
                    isBig: true),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    oneLinetext: "마지막으로", twoLinetext: "비밀번호를 설정해주세요"),
                LabelTextFieldWidget(
                  label: "비밀번호",
                  hintText: "최소 6글자",
                  textController: _signupController.passwordcontroller,
                  obscureText: true,
                ),
                LabelTextFieldWidget(
                  label: "비밀번호 확인",
                  hintText: "입력한 비밀번호를 다시 입력해주세요",
                  textController: _signupController.passwordcheckcontroller,
                  obscureText: true,
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
