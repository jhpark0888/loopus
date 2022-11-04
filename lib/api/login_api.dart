import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

Future<HTTPResponse> loginRequest(String email, String pw) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    Uri uri = Uri.parse('$serverUri/user_api/login');

    final user = {
      'username': email.trim(),
      'password': pw,
      // 'fcm_token': await NotificationController.getToken(),
    };

    return HTTPResponse.httpErrorHandling(() async {
      print(uri);
      print(email.trim());
      print(pw);
      http.Response response = await http
          .post(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(user),
          )
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('로그인 : ${response.statusCode}');

      if (response.statusCode == 202) {
        return HTTPResponse.success(response);
      } else if (response.statusCode == 401) {
        return HTTPResponse.apiError('fail', response.statusCode);
      } else {
        return HTTPResponse.apiError('fail', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> postpwfindemailcheck(
    String email, Rx<Emailcertification> emailcertification) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    Uri uri = Uri.parse('$serverUri/user_api/password');

    final checkemail = {
      'email': email.trim(),
    };

    return HTTPResponse.httpErrorHandling(() async {
      emailcertification(Emailcertification.waiting);

      http.Response response = await http
          .post(uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: json.encode(checkemail))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("비밀번호 찾기 이메일 체크 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("SUCCESS");
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
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

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http
          .put(uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: json.encode(user))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("비밀번호 찾기 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}
