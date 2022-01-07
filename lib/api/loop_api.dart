import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/profile_controller.dart';
import 'dart:convert';

import 'package:loopus/model/user_model.dart';

Future<http.Response> getlooplist(var userid) async {
  String? token = await FlutterSecureStorage().read(key: "token");

  print(token);
  print(userid);
  final uri = Uri.parse("http://3.35.253.151:8000/loop_api/get_list/$userid");

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
