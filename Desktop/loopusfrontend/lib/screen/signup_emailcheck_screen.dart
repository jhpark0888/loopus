import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_last_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  // const SignupDepartmentScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (signupController.emailidcontroller.text
                  .contains("inu.ac.kr")) {
                if (signupController.emailcheck == true) {
                  Get.to(() => SignupLastScreen());
                } else {
                  Get.dialog(Dialog(
                      child: Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "이메일 인증을 부탁드립니다.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))));
                }
              } else {
                Get.dialog(Dialog(
                    child: Container(
                        height: Get.height * 0.15,
                        width: Get.width * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "학교 이메일이 아닙니다.\n다시 입력해주세요.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))));
              }
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Text(
                  '인증이 필요해요!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  '학교 메일주소로 인증 메일을 보내드릴께요.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '학교 메일 주소',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 40,
                  child: TextFormField(
                    controller: signupController.emailidcontroller,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "예) abc1519@inu.ac.kr",
                      hintStyle: TextStyle(fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(3)),
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    // validator: (value) => CheckValidate().validateEmail(value!)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 40,
                  child: TextFormField(
                      obscureText: true,
                      controller: signupController.passwordcontroller,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "영어, 숫자, 특수문자 포함 8자리 이상",
                        hintStyle: TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.2)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(3)),
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) =>
                          CheckValidate().validatePassword(value!)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호 확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 40,
                  child: TextFormField(
                      obscureText: true,
                      controller: signupController.passwordcheckcontroller,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "비밀번호와 같아야 합니다.",
                        hintStyle: TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.2)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(3)),
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) {
                        if (value != signupController.passwordcontroller.text) {
                          return "비밀번호와 같지 않습니다.";
                        } else {
                          return null;
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      emailRequest();
                    },
                    child: Text(
                      '인증하기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
