import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';

import '../constant.dart';
import '../controller/ga_controller.dart';

Future<void> loginRequest() async {
  ConnectivityResult result = await initConnectivity();
  final ModalController _modalController = Get.put(ModalController());
  if (result == ConnectivityResult.none) {
    _modalController.showdisconnectdialog();
  } else {
    final LogInController logInController = Get.put(LogInController());
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final NotificationController notificationController =
        Get.put(NotificationController());
    final GAController _gaController = Get.put(GAController());

    Uri uri = Uri.parse('$serverUri/user_api/login');

    final user = {
      'username': logInController.idcontroller.text.trim(),
      'password': logInController.passwordcontroller.text,
      'fcm_token': await notificationController.getToken(),
    };

    try {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 202) {
        String token = jsonDecode(response.body)['token'];
        String userid = jsonDecode(response.body)['user_id'];
        //! GA
        await _gaController.logLogin();

        storage.write(key: 'token', value: token);
        storage.write(key: 'id', value: userid);
        Get.offAll(() => App());
      } else if (response.statusCode == 401) {
        _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        print('에러1');
      } else {
        _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        print('에러');
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<void> postpwfindemailcheck() async {
  ConnectivityResult result = await initConnectivity();
  LogInController logInController = Get.put(LogInController());
  ModalController _modalController = Get.put(ModalController());
  if (result == ConnectivityResult.none) {
    _modalController.showdisconnectdialog();
  } else {
    ModalController.to
        .showCustomDialog('입력하신 이메일로 들어가서 링크를 클릭해 본인 인증을 해주세요', 1400);
    Uri uri = Uri.parse('$serverUri/user_api/password');

    //이메일 줘야 됨
    final email = {
      'email': logInController.idcontroller.text,
    };

    try {
      http.Response response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode(email));

      print("비밀번호 찾기 이메일 체크 : ${response.statusCode}");
      if (response.statusCode == 200) {
        PwChangeController.to.isPwFindCheck(true);
        // _modalController.showCustomDialog('입력하신 이메일로 새로운 비밀번호를 알려드렸어요', 1400);
      } else if (response.statusCode == 401) {
        _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        print('에러1');
      } else {
        _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        print('에러');
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<void> putpwfindchange() async {
  ConnectivityResult result = await initConnectivity();
  ModalController _modalController = Get.put(ModalController());
  PwChangeController pwChangeController = Get.find();
  LogInController logInController = Get.find();

  if (result == ConnectivityResult.none) {
    _modalController.showdisconnectdialog();
  } else {
    Uri uri = Uri.parse('$serverUri/user_api/password?type=find');

    final user = {
      "email": logInController.idcontroller.text,
      'password': pwChangeController.newpwcontroller.text,
    };

    try {
      http.Response response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode(user));

      print("비밀번호 찾기 : ${response.statusCode}");
      if (response.statusCode == 200) {
        getbacks(2);
        _modalController.showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
      } else if (response.statusCode == 401) {
        _modalController.showCustomDialog('현재 비밀번호가 틀렸습니다.', 1400);
        print('에러1');
      } else {
        _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        print('에러');
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}



// Future<void> postconnect() async {
//   String? token = await const FlutterSecureStorage().read(key: "token");

//   Uri uri = Uri.parse('http://3.35.253.151:8000/search_api/connect');

//   http.Response response = await http.post(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       "Authorization": "Token $token"
//     },
//   );

//   if (response.statusCode == 200) {
//     print('postconnect :연결 성공');
//   } else if (response.statusCode == 401) {
//     print('postconnect :연결 실패');
//   } else {
//     print('postconnect :연결 실패');
//   }
// }