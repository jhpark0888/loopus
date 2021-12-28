import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupDepartmentScreen extends StatelessWidget {
  // const SignupDepartmentScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => SignupEmailcheckScreen());
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
                '어느 학과를 전공하고 계신가요?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '선택한 학과 그룹에 소속됩니다!',
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
                  '학과',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  controller: signupController.departmentcontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "선택",
                    hintStyle: TextStyle(fontSize: 14),
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
          ],
        ),
      ),
    );
  }
}
