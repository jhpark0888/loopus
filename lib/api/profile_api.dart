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

Future<http.StreamedResponse?> updateProfile(User user, File image) async {
  String? token = await FlutterSecureStorage().read(key: "token");
  String? userid = await FlutterSecureStorage().read(key: "id");

  print(token);
  print(userid);
  final uri =
      Uri.parse("http://3.35.253.151:8000/user_api/update_profile/$userid");

  var request = new http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  var multipartFile = await http.MultipartFile.fromPath('image', image.path);
  request.files.add(multipartFile);

  request.fields['type'] = json.encode(user.type);
  request.fields['real_name'] = user.realName;
  request.fields['tag'] = json.encode(user.profileTag);

  print(request.fields);
  print(request.files);

  http.StreamedResponse response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("success!");

    String responsebody = await response.stream.bytesToString();
    var responsemap = jsonDecode(responsebody);

    return response;
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}
