import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/looppeople_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/model/environment_model.dart';
import '../constant.dart';

enum FollowListType { follower, following }

Future<HTTPResponse> getfollowlist(
    int userid, FollowListType followtype) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse(
        "${Environment.apiUrl}/loop_api/get_list/${describeEnum(followtype)}/$userid");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('루프 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        // List<Person> looplist = List.from(responseBody["follow"])
        //     .map((friend) => Person.fromJson(friend))
        //     .toList();

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}

Future<void> postfollowRequest(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  int isStudent = AppController.to.userType == UserType.student ? 1 : 0;

  final uri = Uri.parse(
      "${Environment.apiUrl}/loop_api/loop/$friendid?is_student=$isStudent");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print('팔로우 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> deletefollow(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("${Environment.apiUrl}/loop_api/unloop/$friendid");

  http.Response response =
      await http.delete(uri, headers: {"Authorization": "Token $token"});

  print('루프 해제 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    print(responseBody);
  } else {
    return Future.error(response.statusCode);
  }
}
