import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/question_specific_model.dart';

void questionmake(String content) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url =
      Uri.parse("http://3.35.253.151:8000/question_api/raise_question/");
  print("token");
  print(token);
  var data = {
    "content": content,
    "tag":
        TagController.to.selectedtaglist.map((element) => element.text).toList()
  };
  // TagController.to.selectedtaglist.clear();
  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data));
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  // List<dynamic> list = jsonDecode(responseBody);
  // print(list);
  print("---------------------------");
  print(responseBody);
  print(response.statusCode);
  // if (response.statusCode != 200) {
  //   return Future.error(response.statusCode);
  // } else {
  //   return HomeModel.fromJson(list);
  // }
}

Future<dynamic> questionlist(int pageNumber, String type) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse(
      "http://3.35.253.151:8000/question_api/question_list_load/$type?page=$pageNumber");
  print(url);
  final response = await get(url, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  List<dynamic> list = jsonDecode(responseBody);
  print(list);
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return QuestionModel.fromJson(list);
  }
}

Future<dynamic> specificquestion(int questionid) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse(
      "http://3.35.253.151:8000/question_api/specific_question_load/$questionid/");

  final response = await get(url, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  Map<String, dynamic> map = jsonDecode(responseBody);

  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return QuestionModel2.fromJson(map);
  }
}

Future<Map<dynamic, dynamic>> answermake(String content, int id) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse("http://3.35.253.151:8000/question_api/answer/$id/");
  print("token");
  print(token);
  var data = {
    "content": content,
  };
  // TagController.to.selectedtaglist.clear();
  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data));
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  // List<dynamic> list = jsonDecode(responseBody);
  // print(list);
  Map<String, dynamic> map = jsonDecode(responseBody);
  print("---------------------------");
  print(responseBody);
  print(response.statusCode);
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return map;
  }
}
