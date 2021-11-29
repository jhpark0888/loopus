import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'dart:convert';

import 'package:loopus/model/user_model.dart';

class ProfileApi {
  static ProfileApi get to => Get.find();

  Future<User?> getProfile() async {
    String? token = await FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    print(token);
    print(userid);
    final uri =
        Uri.parse("http://3.35.253.151:8000/user_api/profile_load/$userid/");

    var response =
        await http.get(uri, headers: {"Authorization": "Token $token"});

    print(response.statusCode);
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);

    // print(response.statusCode);
    if (response.statusCode != 200) {
      return responseBody.map((e) => User.fromJson(e));
      return Future.error(response.statusCode);
    } else {}
  }
}
