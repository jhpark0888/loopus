import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupFailScreen extends StatelessWidget {
  SignupFailScreen({Key? key, required this.signupController})
      : super(key: key);

  SignupController signupController;

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomExpandedButton(
                onTap: () async {
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
                          signupController.selectDept.value.deptname);

                      // Get.offAll(() => App());

                      // SchedulerBinding.instance!.addPostFrameCallback((_) {
                      //   showCustomDialog('관심태그 기반으로 홈 화면을 구성했어요', 1500);
                      // });

                      await _gaController.logScreenView('signup_6');
                      Get.offAll(() => SignupCompleteScreen(
                            emailId: signupController.emailidcontroller.text +
                                "@" +
                                signupController.selectUniv.value.email,
                            password: signupController.passwordcontroller.text,
                          ));
                    } else {
                      await _gaController.logScreenView('signup_6');
                      errorSituation(value);
                    }
                  });
                },
                isBlue: true,
                title: "다시 시도하기",
                isBig: true),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                    oneLinetext: "죄송해요. 아래 버튼을 눌러", twoLinetext: "다시 시도해주세요"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}