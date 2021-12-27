import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void loginRequest() async {
  LogInController logInController = Get.put(LogInController());
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/login/');
  Uri uri = Uri.parse('http://3.35.253.151:8000/user_api/login/');

  var user = {
    'username': logInController.idcontroller.text,
    'password': logInController.passwordcontroller.text,
  };

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(user),
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    String token = jsonDecode(response.body)['Token'];
    String userid = jsonDecode(response.body)['user_id'];
    storage.write(key: 'token', value: '$token');
    storage.write(key: 'id', value: '$userid');
    Get.offAll(App());
  } else if (response.statusCode == 401) {
    Get.defaultDialog(
      title: '로그인 오류',
      content: Text('아이디 또는 비밀번호가 틀렸습니다'),
    );
  } else {
    print(response.statusCode);
  }
}
