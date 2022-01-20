import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/user_model.dart';

import '../constant.dart';

Future<List<User>> getlooplist(int userid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/get_list/$userid");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  print('루프 리스트 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<User> looplist = List.from(responseBody["friend"])
        .map((friend) => User.fromJson(friend))
        .toList();
    return looplist;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> postloopRequest(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/loop_request/$friendid");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print('루프 신청 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> postloopPermit(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/loop/$friendid");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print('루프 허락 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> postloopRelease(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/get_list/$friendid");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print('루프 해제 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);
  } else {
    return Future.error(response.statusCode);
  }
}
