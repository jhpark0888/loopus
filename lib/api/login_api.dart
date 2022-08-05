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
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/screen/pwchange_screen.dart';

import '../constant.dart';
import '../controller/ga_controller.dart';

Future<HTTPResponse> loginRequest(String email, String pw) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    final LogInController logInController = Get.put(LogInController());
    // final NotificationController notificationController =
    //     Get.put(NotificationController());
    final GAController _gaController = Get.put(GAController());

    Uri uri = Uri.parse('$serverUri/user_api/login');

    final user = {
      'username': email.trim(),
      'password': pw,
      'fcm_token': await NotificationController.getToken(),
    };

    try {
      print('$serverUri/user_api/login');
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );

      print('로그인 : ${response.statusCode}');

      if (response.statusCode == 202) {
        return HTTPResponse.success(response);
      } else if (response.statusCode == 401) {
        return HTTPResponse.apiError('fail', response.statusCode);
      } else {
        return HTTPResponse.apiError('fail', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<HTTPResponse> postpwfindemailcheck(
    String email, Rx<Emailcertification> emailcertification) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    Uri uri = Uri.parse('$serverUri/user_api/password');

    String? fcmToken = await NotificationController.getToken();

    //이메일 줘야 됨
    final checkemail = {'email': email.trim(), "token": fcmToken};

    try {
      emailcertification(Emailcertification.waiting);
      showBottomSnackbar("$email로\n인증 메일을 보냈어요\n메일을 확인하고 인증을 완료해주세요");

      http.Response response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode(checkemail));

      print("비밀번호 찾기 이메일 체크 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> putpwfindchange() async {
  ConnectivityResult result = await initConnectivity();
  PwChangeController pwChangeController = Get.find();
  LogInController logInController = Get.find();

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
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
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
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