import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';

Future<void> loginRequest() async {
  LogInController logInController = Get.put(LogInController());
  const FlutterSecureStorage storage = FlutterSecureStorage();
  ModalController _modalController = Get.put(ModalController());

  Uri uri = Uri.parse('http://3.35.253.151:8000/user_api/login');

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

    Get.offAll(() => App());
  } else if (response.statusCode == 401) {
    _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
  } else {
    _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
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
