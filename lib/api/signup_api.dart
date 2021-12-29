import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

void emailRequest() async {
  SignupController signupController = Get.put(SignupController());

  Uri uri = Uri.parse('http://3.35.253.151:8000/user_api/check_email/');

  var user = {
    "email": signupController.emailidcontroller.text,
    "password": signupController.passwordcontroller.text,
  };

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(user),
  );
  print(response.body);
  // storage.write(key: 'token', value: json.decode(response.body)['token']);
  // print(storage.read(key: 'token'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(response.statusCode);
    signupController.emailcheck(true);
  }
}

Future<http.Response> signupRequest() async {
  SignupController signupController = Get.find();
  TagController tagController = Get.find();
  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/signup/');
  Uri uri = Uri.parse('http://3.35.253.151:8000/user_api/signup/');
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var checkemail = {
    "email": signupController.emailidcontroller.text,
    "image": null,
    "type": 0,
    "class_num": signupController.classnumcontroller.text,
    "real_name": signupController.namecontroller.text,
    "department": signupController.departmentcontroller.text,
    "tag": tagController.selectedtaglist.map((tag) => tag.text).toList()
  };

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode(checkemail),
  );
  print(json.encode(checkemail));
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(response.statusCode);
    String token = jsonDecode(response.body)['Token'];
    String userid = jsonDecode(response.body)['user_id'];
    storage.write(key: 'token', value: '$token');
    storage.write(key: 'id', value: '$userid');
  }
  return response;
}
