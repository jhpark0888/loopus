import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class QuestionApi {
  static QuestionApi get to => Get.find();

  void questionmake(String content) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url =
        Uri.parse("http://3.38.89.253:8000/question_api/raise_question/");
    print("token");
    print(token);
    var data = {"content": content, "tag": ""};
    http.Response response = await http.post(url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data));
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(responseBody);
    print(list);
    // if (response.statusCode != 200) {
    //   return Future.error(response.statusCode);
    // } else {
    //   return HomeModel.fromJson(list);
    // }
  }
}
