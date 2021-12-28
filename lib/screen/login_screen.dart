import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/app.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/main.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final LogInController _loginController = Get.put(LogInController());
  static final FlutterSecureStorage? storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '로그인',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "캠퍼스 구성원 모두와 소통하는 공간",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Text(
                    "이메일",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  controller: _loginController.idcontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(3)),
                    focusColor: Colors.black,
                    contentPadding: EdgeInsets.all(10),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                  // validator: (value) => CheckValidate().validateEmail(value!)
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Text(
                    "비밀번호",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  controller: _loginController.passwordcontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(2)),
                    focusColor: Colors.black,
                    contentPadding: EdgeInsets.all(10),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                  // validator: (value) => CheckValidate().validateEmail(value!)
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width * 0.95,
                  height: 45,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Text("로그인",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      loginRequest();
                      if (_formKey.currentState!.validate()) {
                        // _loginController.loginRequest();
                      }
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width * 0.95,
                  height: 45,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Text("회원가입",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      Get.to(() => SignupCampusInfoScreen());
                    },
                  ),
                ),
                // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                //   ElevatedButton(
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         _loginController.loginRequest();
                //       }
                //     },
                //     child: Text("로그인"),
                //   ),
                //   ElevatedButton(
                //     onPressed: () async {
                //       Get.to(() => SignUpPage());
                //     },
                //     child: Text("회원가입"),
                //   ),
                // ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CheckValidate {
//   String? validateEmail(String value) {
//     if (value.isEmpty) {
//       return '이메일을 입력하세요.';
//     } else {
//       Pattern pattern =
//           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//       RegExp regExp = new RegExp(pattern.toString());
//       if (!regExp.hasMatch(value)) {
//         return '잘못된 이메일 형식입니다.';
//       } else {
//         return null;
//       }
//     }
//   }

//   String? validatePassword(String value) {
//     if (value.isEmpty) {
//       return '비밀번호를 입력하세요.';
//     } else {
//       Pattern pattern =
//           r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
//       RegExp regExp = new RegExp(pattern.toString());
//       if (!regExp.hasMatch(value)) {
//         return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
//       } else {
//         return null;
//       }
//     }
//   }
// }
