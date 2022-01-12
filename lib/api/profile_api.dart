import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:loopus/model/user_model.dart';

Future<http.Response> getProfile(var userId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("http://3.35.253.151:8000/user_api/profile_load/$userId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    return response;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<User?> updateProfile(User user, File? image, List? taglist) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("http://3.35.253.151:8000/user_api/update_profile");

  var request = http.MultipartRequest('POST', uri);

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

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responsebody = await response.stream.bytesToString();
    var responsemap = jsonDecode(responsebody);
    User edituser = User.fromJson(responsemap);
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }

    return edituser;
  } else if (response.statusCode == 400) {
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }
  } else {
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }
  }
}
