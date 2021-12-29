import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/question_model.dart';

Future<Post?> postingAddRequest(int project_id) async {
  PostingAddController postingAddController = Get.find();
  String? token = await FlutterSecureStorage().read(key: 'token');
  String? user_id = await FlutterSecureStorage().read(key: 'id');
  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/profile_update/customizing/$user_id/');
  Uri uri = Uri.parse(
      'http://3.35.253.151:8000/post_api/posting_upload/$project_id/');

  var request = new http.MultipartRequest('POST', uri);

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

  for (int i = 0; i < postingAddController.images.length; i++) {
    var multipartFile = await http.MultipartFile.fromPath(
        'image', postingAddController.images[i].path);
    request.files.add(multipartFile);
  }

  request.fields['title'] = postingAddController.titlecontroller.text;
  request.fields['contents'] = json
      .encode(postingAddController.postcontroller.document.toDelta().toJson());

  print(request.fields);
  print(request.files);

  http.StreamedResponse response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("success!");

    String responsebody = await response.stream.bytesToString();
    print(responsebody);
    var responsemap = jsonDecode(responsebody);
    // print(responsemap['contents']);

    // Post post = Post.fromJson(responsemap);
    // post.contents = post.contents.replaceAll(RegExp('True'), 'true');
    // List<dynamic> json = jsonDecode(post.contents);
    // print(post.contents);
    // return post;
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}

Future<http.Response?> getposting(int posting_id) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  // String? userid = await FlutterSecureStorage().read(key: "id");

  print(token);
  // print(userid);
  final uri = Uri.parse(
      "http://3.35.253.151:8000/post_api/specific_posting_load/$posting_id");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

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

  final url = Uri.parse(
      "http://3.35.253.151:8000/post_api/main_load/?page=$pageNumber");

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
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> looppost(int pageNumber) async {
  String? token;
  await FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final url = Uri.parse(
      "http://3.35.253.151:8000/post_api/loop_load/?page=$pageNumber/");

  final response = await get(url, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  List<dynamic> list = jsonDecode(responseBody);
  if (list.isEmpty) {
    HomeController.to.enablepullup3.value = false;
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

  final url =
      Uri.parse("http://3.35.253.151:8000/post_api/bookmark/$posting_id/");

  final response = await post(url, headers: {"Authorization": "Token $token"});
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

  final url = Uri.parse("http://3.35.253.151:8000/post_api/like/$posting_id/");

  final response = await post(url, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  print(statusCode);
  String result = jsonDecode(responseBody);
  print(result);
}
