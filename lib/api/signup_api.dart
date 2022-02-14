import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

import '../constant.dart';

void emailRequest() async {
  SignupController signupController = Get.put(SignupController());

  Uri uri = Uri.parse('$serverUri/user_api/check_email');

  var checkemail = {
    //TODO: 학교 도메인 확인
    "email": signupController.emailidcontroller.text + '@inu.ac.kr',
    "password": signupController.passwordcontroller.text,
  };

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(checkemail),
  );

  if (response.statusCode == 200) {
    signupController.emailcheck(true);
  }
}

Future<http.Response> signupRequest() async {
  SignupController signupController = Get.find();
  TagController tagController = Get.find(tag: Tagtype.profile.toString());
  Uri uri = Uri.parse('$serverUri/user_api/signup');
  const FlutterSecureStorage storage = FlutterSecureStorage();

  var user = {
    "email": signupController.emailidcontroller.text + '@inu.ac.kr',
    "image": null,
    "type": 0,
    "class_num": signupController.classnumcontroller.text,
    "real_name": signupController.namecontroller.text,
    "department": signupController.selectdept.value,
    "tag": tagController.selectedtaglist.map((tag) => tag.text).toList()
  };

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

    storage.write(key: 'token', value: token);
    storage.write(key: 'id', value: userid);
  }
  return response;
}

Future getdeptlist() async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/user_api/department_list");

  http.Response response = await http.get(
    uri,
  );

  print('학과 리스트 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));
    responseBody
        .forEach((key, value) => SignupController.to.deptlist.add(value));
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
