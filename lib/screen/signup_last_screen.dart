import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupLastScreen extends StatelessWidget {
  // const SignupDepartmentScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (CheckValidate().validatePassword(
                      signupController.passwordcontroller.text) ==
                  null) {
                if (signupController.passwordcontroller.text ==
                    signupController.passwordcheckcontroller.text) {
                  Get.to(() => LogInScreen());
                  signupRequest();
                  signupController.campusnamecontroller.clear();
                  signupController.classnumcontroller.clear();
                  signupController.departmentcontroller.clear();
                  signupController.emailidcontroller.clear();
                  signupController.namecontroller.clear();
                  signupController.passwordcontroller.clear();
                  signupController.passwordcheckcontroller.clear();
                  Get.dialog(Dialog(
                      child: Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "축하합니다. 회원가입이 완료되었습니다. 로그인해주세요!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ))));
                } else {
                  Get.dialog(Dialog(
                      child: Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "비밀번호와 비밀번호 확인이 동일하지 않습니다.",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
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
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "${CheckValidate().validatePassword(signupController.passwordcontroller.text)}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ))));
              }
              print(CheckValidate()
                  .validatePassword(signupController.passwordcontroller.text));
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                '거의 다 끝났어요!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '나머지 정보를 입력해주세요.',
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
                  '이름',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  controller: signupController.namecontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    // hintText: "예) abc1519@inu.ac.kr",
                    // hintStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
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
                      hintText: "영어, 숫자, 특수문자 포함",
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
          ],
        ),
      ),
    );
  }
}

class CheckValidate {
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return '이메일을 입력하세요.';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력하세요.';
    } else {
      Pattern pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '비밀 번호를 특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }
}
