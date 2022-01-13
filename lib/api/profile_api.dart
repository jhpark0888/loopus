import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/project_model.dart';

import 'package:loopus/model/user_model.dart';

Future<User> getProfile(var userId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("http://3.35.253.151:8000/user_api/profile_load/$userId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));

    User user = User.fromJson(responseBody);
    return user;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<List<Project>> getProjectlist(var userId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("http://3.35.253.151:8000/user_api/project_load/$userId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    List responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<Project> projectlist =
        responseBody.map((project) => Project.fromJson(project)).toList();

    return projectlist;
  } else {
    return Future.error(response.statusCode);
  }
}

enum ProfileUpdateType {
  image,
  department,
  tag,
}

Future<User?> updateProfile(
    User user, File? image, List? taglist, ProfileUpdateType updateType) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse(
      "http://3.35.253.151:8000/user_api/update_profile/${updateType.name}");

  var request = http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (updateType == ProfileUpdateType.image) {
    if (image != null) {
      print('api image : ${image.path}');
      var multipartFile =
          await http.MultipartFile.fromPath('image', image.path);
      request.files.add(multipartFile);
      print('multipartFile : $multipartFile');
    } else {
      print('api error image : $image');

      request.fields['image'] = user.profileImage ?? json.encode(null);
    }
  } else if (updateType == ProfileUpdateType.department) {
    request.fields['department'] = user.department;
  } else if (updateType == ProfileUpdateType.department) {
    request.fields['tag'] =
        json.encode(taglist ?? user.profileTag.map((tag) => tag.tag).toList());
  }

  http.StreamedResponse response = await request.send();
  print(response.statusCode);
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
