import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';

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

  request.fields['title'] =
      json.encode(postingAddController.titlecontroller.text);
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
    print(responsemap['contents']);

    Post post = Post.fromJson(responsemap);
    // post.contents = post.contents.replaceAll(RegExp('True'), 'true');
    // List<dynamic> json = jsonDecode(post.contents);
    print(post.contents);
    return post;
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}

Future<Post?> getposting(int project_id) async {
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

  request.fields['title'] =
      json.encode(postingAddController.titlecontroller.text);
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
    print(responsemap['contents']);

    Post post = Post.fromJson(responsemap);
    // post.contents = post.contents.replaceAll(RegExp('True'), 'true');
    // List<dynamic> json = jsonDecode(post.contents);
    print(post.contents);
    return post;
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}
