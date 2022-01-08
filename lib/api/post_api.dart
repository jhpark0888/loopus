import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/smarttextfield.dart';

Future<void> addposting(int project_id) async {
  final PostingAddController postingAddController = Get.find();
  final EditorController editorController = Get.find();

  final String? token = await const FlutterSecureStorage().read(key: 'token');

  Uri postingUploadUri = Uri.parse(
      'http://3.35.253.151:8000/post_api/posting_upload/$project_id/');

  var request = http.MultipartRequest('POST', postingUploadUri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (postingAddController.thumbnail.value.path != '') {
    var multipartFile = await http.MultipartFile.fromPath(
        'thumbnail', postingAddController.thumbnail.value.path);
    request.files.add(multipartFile);
  }

  List<Map> postcontent = [];

  for (int i = 0; i < editorController.types.length; i++) {
    SmartTextType type = editorController.types[i];
    Map map = {};
    if (type == SmartTextType.T) {
      map['type'] = 0;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H1) {
      map['type'] = 1;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H2) {
      map['type'] = 2;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.QUOTE) {
      map['type'] = 3;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.BULLET) {
      map['type'] = 4;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.IMAGE) {
      map['type'] = 5;
      map['content'] = 'image';
      var multipartFile = await http.MultipartFile.fromPath(
          'image', editorController.imageindex[i]!.path);
      request.files.add(multipartFile);
      postcontent.add(map);
    } else if (type == SmartTextType.LINK) {
      map['type'] = 6;
      map['content'] = editorController.textcontrollers[i].text;
      map['url'] = editorController.linkindex[i];
      postcontent.add(map);
    }
  }
  request.fields['title'] = postingAddController.titlecontroller.text;
  request.fields['contents'] = json.encode(postcontent);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print("status code : ${response.statusCode} 포스팅 업로드 완료");

    Project project = await getproject(project_id);
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(() => ProjectScreen(project: project.obs));
  } else if (response.statusCode == 400) {
    print("status code : ${response.statusCode} 포스팅 업로드 실패");
  } else {
    print("status code : ${response.statusCode} 포스팅 업로드 실패");
    return Future.error(response.statusCode);
  }
}

Future<http.Response?> getposting(int posting_id) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  // String? userid = await FlutterSecureStorage().read(key: "id");

  print(token);
  // print(userid);
  final specificPostingLoadUri = Uri.parse(
      "http://3.35.253.151:8000/post_api/specific_posting_load/$posting_id");

  http.Response response = await http
      .get(specificPostingLoadUri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  // var responseBody = json.decode(utf8.decode(response.bodyBytes));

  print(response.statusCode);
  if (response.statusCode == 200) {
    // Post post = Post.fromJson(responseBody['posting_info']);
    return response;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<dynamic> mainpost(int pageNumber) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final mainloadUri = Uri.parse(
      "http://3.35.253.151:8000/post_api/main_load/?page=$pageNumber");

  final response =
      await get(mainloadUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  List<dynamic> list = jsonDecode(responseBody);

  print('posting list : $list');
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> bookmarklist(int pageNumber) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkListUri = Uri.parse(
      "http://3.35.253.151:8000/post_api/bookmark_list/?page=$pageNumber");

  final response =
      await get(bookmarkListUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  List<dynamic> list = jsonDecode(responseBody);

  print(list);
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> looppost(int pageNumber) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final loopUri = Uri.parse(
      "http://3.35.253.151:8000/post_api/loop_load/?page=$pageNumber/");

  final response =
      await get(loopUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  List<dynamic> list = jsonDecode(responseBody);
  if (list.isEmpty) {
    HomeController.to.enableLoopPullup.value = false;
  }
  print(list);
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> bookmarkpost(int posting_id) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkUri =
      Uri.parse("http://3.35.253.151:8000/post_api/bookmark/$posting_id/");

  final response =
      await post(bookmarkUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  String result = jsonDecode(responseBody);
  print(result);
}

Future<dynamic> likepost(int posting_id) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final likeUri =
      Uri.parse("http://3.35.253.151:8000/post_api/like/$posting_id/");

  final response =
      await post(likeUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  String result = jsonDecode(responseBody);
  print(result);
}
