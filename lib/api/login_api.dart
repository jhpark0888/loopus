import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/notification_controller.dart';

void loginRequest() async {
  LogInController logInController = Get.put(LogInController());
  const FlutterSecureStorage storage = FlutterSecureStorage();

  Uri uri = Uri.parse('http://3.35.253.151:8000/user_api/login/');

  final user = {
    'username': logInController.idcontroller.text,
    'password': logInController.passwordcontroller.text,
    'fcm_token': await NotificationController.to.getToken(),
  };
  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(user),
  );

  if (response.statusCode == 202) {
    String token = jsonDecode(response.body)['Token'];
    String userid = jsonDecode(response.body)['user_id'];

    storage.write(key: 'token', value: token);
    storage.write(key: 'id', value: userid);

    Get.offAll(App());

    if (kDebugMode) {
      print('login status code : ${response.statusCode}');
    }
  } else if (response.statusCode == 401) {
    Get.defaultDialog(
      title: '로그인 오류',
      content: const Text('아이디 또는 비밀번호가 틀렸습니다'),
    );
    if (kDebugMode) {
      print('login status code : ${response.statusCode}');
    }
  } else {
    if (kDebugMode) {
      print('login status code : ${response.statusCode}');
    }
    Get.defaultDialog(
      title: '${response.statusCode}',
      content: Text('${response.statusCode}'),
    );
  }
}
