import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/profile_controller.dart';
import 'dart:convert';

import 'package:loopus/model/user_model.dart';

Future<http.Response> getProfile(var userid) async {
  String? token = await FlutterSecureStorage().read(key: "token");

  print(token);
  print(userid);
  final uri =
      Uri.parse("http://3.35.253.151:8000/user_api/profile_load/$userid");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  // var responseBody = json.decode(utf8.decode(response.bodyBytes));
  // print(responseBody);

  // print(response.statusCode);
  if (response.statusCode == 200) {
    return response;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<User?> updateProfile(User user, File? image, List? taglist) async {
  String? token = await FlutterSecureStorage().read(key: "token");
  // String? userid = await FlutterSecureStorage().read(key: "id");

  print(token);
  // print(userid);
  final uri = Uri.parse("http://3.35.253.151:8000/user_api/update_profile/");

  var request = new http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (image != null) {
    var multipartFile = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(multipartFile);
  } else {
    request.fields['image'] = user.profileImage ?? json.encode(null);
  }

  request.fields['department'] = user.department;
  request.fields['tag'] =
      json.encode(taglist ?? user.profileTag.map((tag) => tag.tag).toList());

  print(request.fields);
  print(request.files);

  http.StreamedResponse response = await request.send();

  print(response.statusCode);
  if (response.statusCode == 200) {
    print("success!");

    String responsebody = await response.stream.bytesToString();
    var responsemap = jsonDecode(responsebody);
    print(responsemap);
    User edituser = User.fromJson(responsemap);

    return edituser;
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}
