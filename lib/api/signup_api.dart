import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';

import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

import '../app.dart';
import '../constant.dart';

void emailRequest() async {
  SignupController signupController = Get.put(SignupController());

  Uri uri = Uri.parse('$serverUri/user_api/check_email');

  var checkemail = {
    //TODO: 학교 도메인 확인
    "email": signupController.emailidcontroller.text + '@inu.ac.kr',
    "password": signupController.passwordcontroller.text,
  };
  try {
    http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(checkemail),
    );

    print("이메일 체크 : ${response.statusCode}");
    if (response.statusCode == 200) {
      signupController.emailcheck(true);
    } else if (response.statusCode == 400) {
      Get.put(ModalController()).showCustomDialog("이미 가입된 회원입니다", 1000);
    } else {
      return Future.error(response.statusCode);
    }
  } on SocketException {
    ErrorController.to.isServerClosed(true);
  } catch (e) {
    print(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<void> signupRequest() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    Get.put(ModalController()).showdisconnectdialog();
  } else {
    final SignupController signupController = Get.find();
    final TagController tagController =
        Get.find(tag: Tagtype.profile.toString());
    final GAController _gaController = Get.put(GAController());
    final ModalController _modalController = Get.put(ModalController());

    Uri uri = Uri.parse('$serverUri/user_api/signup');
    const FlutterSecureStorage storage = FlutterSecureStorage();
    //todo : @inu.ac.kr
    var user = {
      "email": signupController.emailidcontroller.text + '@inu.ac.kr',
      "image": null,
      "type": 0,
      "class_num": signupController.classnumcontroller.text,
      "real_name": signupController.namecontroller.text,
      "department": signupController.selectdept.value,
      "tag": tagController.selectedtaglist.map((tag) => tag.text).toList()
    };
    try {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(user),
      );

      if (response.statusCode == 200) {
        String token = jsonDecode(response.body)['token'];
        String userid = jsonDecode(response.body)['user_id'];

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'id', value: userid);
        //!GA
        await _gaController.logSignup();
        await _gaController.setUserProperties(
            userid, signupController.selectdept.value);

        Get.offAll(() => App());

        SchedulerBinding.instance!.addPostFrameCallback((_) {
          _modalController.showCustomDialog('관심태그 기반으로 홈 화면을 구성했어요', 1500);
        });

        await _gaController.logScreenView('signup_6');
      } else {
        await _gaController.logScreenView('signup_6');
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future getdeptlist() async {
  ConnectivityResult result = await initConnectivity();
  final SignupController signupController = Get.find();
  if (result == ConnectivityResult.none) {
    signupController.deptscreenstate(ScreenState.disconnect);
    Get.put(ModalController()).showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    final GAController _gaController = Get.put(GAController());

    final uri = Uri.parse("$serverUri/user_api/department_list");
    try {
      http.Response response = await http.get(
        uri,
      );

      print('학과 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            json.decode(utf8.decode(response.bodyBytes));
        responseBody
            .forEach((key, value) => SignupController.to.deptlist.add(value));
        signupController.deptscreenstate(ScreenState.success);
        await _gaController.logScreenView('signup_2');

        return;
      } else {
        signupController.deptscreenstate(ScreenState.error);
        await _gaController.logScreenView('signup_2');
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}
