import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_department_screen.dart';

class SignupCampusInfoScreen extends StatelessWidget {
  // const SignupCampusInfoScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => SignupDepartmentScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: const Text(
          '회원 가입',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                '어느 대학에 재학 중이신가요?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '선택한 대학 그룹에 소속됩니다!',
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
                  '학교',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  controller: signupController.campusnamecontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "학교명을 검색해보세요",
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Text(
                    '학번',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                height: 40,
                child: TextFormField(
                  controller: signupController.classnumcontroller,
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
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
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
