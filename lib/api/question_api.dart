import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/question_specific_model.dart';

import '../constant.dart';

Future postquestion(String content) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse("$serverUri/question_api/question");
  var data = {
    "content": content,
    "tag": Get.find<TagController>(tag: Tagtype.question.toString())
        .selectedtaglist
        .map((element) => element.text)
        .toList()
  };
  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data));
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
}

Future<dynamic> getquestionlist(int lastindex, String type) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });
  print(lastindex);
  final url = Uri.parse(
      "$serverUri/question_api/question_list_load/$type?last=$lastindex");
  final response = await get(url, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);

    List<dynamic> list = jsonDecode(responseBody);
    // print(list);
    return QuestionModel.fromJson(list);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<dynamic> getquestion(int questionid) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse("$serverUri/question_api/question?id=$questionid");

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

Future<dynamic> deletequestion(int questionid) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse("$serverUri/question_api/question?id=$questionid");

  final response =
      await delete(url, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    //   var statusCode = response.statusCode;
    // var responseHeaders = response.headers;
    // var responseBody = utf8.decode(response.bodyBytes);
    // print(statusCode);
    // Map<String, dynamic> map = jsonDecode(responseBody);

    print(' 질문 삭제 성공 : ${response.statusCode}');
    return;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<Map<dynamic, dynamic>> answermake(String content, int id) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse("$serverUri/question_api/answer/$id");

  print(token);
  var data = {
    "content": content,
  };
  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data));
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  List<dynamic> list = jsonDecode(responseBody);
  // print(list);
  Map<String, dynamic> map = jsonDecode(responseBody);

  print(responseBody);
  print(response.statusCode);
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return map;
  }
}
