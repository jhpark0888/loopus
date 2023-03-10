import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/login_api.dart';
import 'package:loopus/app.dart';

import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/home_controller.dart';

import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pw_find_screen.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/error_control.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

import '../utils/check_form_validate.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage? storage = const FlutterSecureStorage();

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomExpandedButton(
                          onTap: () {
                            Get.back();
                          },
                          isBlue: false,
                          title: "??????",
                          isBig: true),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Obx(
                        () => CustomExpandedButton(
                            onTap: () async {
                              if (_loginController.loginButtonOn.value) {
                                login(
                                  context,
                                  emailId: _loginController.idcontroller.text,
                                  password:
                                      _loginController.passwordcontroller.text,
                                );
                              }
                            },
                            isBlue: _loginController.loginButtonOn.value,
                            title: "?????????",
                            isBig: true),
                      ),
                    ),
                  ],
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
                    oneLinetext: "",
                    highlightText: "??????????????? ???????????????",
                    twoLinetext: "??????????????? ??????????????????"),
                // Obx(
                //   () => ToggleButtons(
                //     children: const [
                //       Text(
                //         "??????",
                //       ),
                //       Text(
                //         "??????",
                //       )
                //     ],
                //     constraints: BoxConstraints.tightFor(
                //         width: (Get.width / 2) - 16, height: 42),
                //     isSelected: [
                //       _loginController.loginType.value == UserType.student,
                //       _loginController.loginType.value == UserType.company
                //     ],
                //     textStyle: MyTextTheme.mainbold(context),
                //     onPressed: (index) {
                //       if (index == 0) {
                //         _loginController.loginType(UserType.student);
                //       } else {
                //         _loginController.loginType(UserType.company);
                //       }
                //     },
                //     fillColor: AppColors.mainblue,
                //     selectedColor: AppColors.mainWhite,
                //     selectedBorderColor: AppColors.mainblue,
                //     color: AppColors.dividegray,
                //     splashColor: Colors.transparent,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                // ),
                // const SizedBox(
                //   height: 24,
                // ),
                LabelTextFieldWidget(
                  label: "?????? ????????? ?????? ?????? ??????",
                  hintText: "?????? ?????? ?????? ?????? ?????? ?????? ???????????? ??????????????????.",
                  // validator: (value) =>
                  //     CheckValidate().validateEmail(value!),
                  textController: _loginController.idcontroller,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(
                  height: 24,
                ),
                LabelTextFieldWidget(
                  label: "????????????",
                  hintText: "?????? 6?????? ??????????????? ??????????????????",
                  obscureText: true,
                  // validator: (value) =>
                  //     CheckValidate().validatePassword(value!),
                  textController: _loginController.passwordcontroller,
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(() => PwFindScreen());
                    },
                    child: Center(
                      child: Text(
                        "??????????????? ????????????????",
                        style: MyTextTheme.main(context).copyWith(
                          color: AppColors.maingray,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void login(
  context, {
  required String emailId,
  required String password,
}) async {
  FocusScope.of(context).unfocus();
  loading();
  // Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
  await loginRequest(emailId, password).then((value) async {
    if (value.isError == false) {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      http.Response response = value.data;
      String token = jsonDecode(response.body)['token'];
      String userid = jsonDecode(response.body)['user_id'];
      int isStudent = jsonDecode(response.body)['is_student'];

      if (isStudent == 1) {
        String strSchoolId =
            jsonDecode(response.body)['school_id']; //school??????id
        String strDeptId =
            jsonDecode(response.body)['department_id']; // department??????id
        List<int> groupTpList = List.from(
            jsonDecode(response.body)['topic_list']); //ex) [34, 53, 64]

        storage.write(key: 'strSchoolId', value: strSchoolId);
        storage.write(key: 'strDeptId', value: strDeptId);
        storage.write(key: 'groupTpList', value: jsonEncode(groupTpList));

        await FirebaseMessaging.instance.subscribeToTopic(strSchoolId);
        await FirebaseMessaging.instance.subscribeToTopic(strDeptId);
        for (int careerId in groupTpList) {
          await FirebaseMessaging.instance.subscribeToTopic("project$careerId");
        }
      }

      //! GA
      // await _gaController.logLogin();

      storage.write(key: 'token', value: token);
      storage.write(key: 'id', value: userid);
      storage.write(key: 'type', value: UserType.values[isStudent].name);

      await FirebaseMessaging.instance.subscribeToTopic(userid);

      Get.offAll(() => App());
    } else {
      Get.back();
      if (value.errorData!["statusCode"] == 401) {
        showCustomDialog('????????? ????????? ?????? ??????????????????', 1400);
      } else {
        errorSituation(value);
      }
    }
  });
}

Future<void> logOut() async {
  loading();
  AppController.to.currentIndex.value = 0;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? userid = await secureStorage.read(key: "id");
  String? type = await secureStorage.read(key: "type");
  await FirebaseMessaging.instance.unsubscribeFromTopic(userid!);

  if (type == UserType.student.name) {
    String? strSchoolId = await secureStorage.read(key: "strSchoolId");
    String? strDeptId = await secureStorage.read(key: "strDeptId");
    String? strGroupTpList = await secureStorage.read(key: "groupTpList");
    List<int> groupTpList = [];

    if (strGroupTpList != null) {
      groupTpList = json.decode(strGroupTpList).cast<int>();

      secureStorage.delete(key: "groupTpList");

      for (int careerId in groupTpList) {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic("project$careerId");
      }
    }

    if (strSchoolId != null) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(strSchoolId);
      secureStorage.delete(key: "strSchoolId");
    }
    if (strDeptId != null) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(strDeptId);
      secureStorage.delete(key: "strDeptId");
    }
    if (strGroupTpList != null) {}
  }

  secureStorage.delete(key: "token");
  secureStorage.delete(key: "id");
  secureStorage.delete(key: "type");

  Get.delete<AppController>();
  Get.delete<HomeController>();
  Get.delete<SearchController>();
  // Get.delete<ProfileController>();
  Get.delete<ScoutReportController>();
  Get.delete<CareerBoardController>();
  Get.delete<SQLController>();

  Get.offAll(() => StartScreen());
}
