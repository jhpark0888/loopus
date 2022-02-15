import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/constant.dart';
import 'package:http/http.dart' as http;

import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/widget/notification_widget.dart';

Future<List> getNotificationlist(String type, int lastindex) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("$serverUri/user_api/alarm?type=$type&last=$lastindex");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  print("알림 리스트 로드: ${response.statusCode}");
  if (response.statusCode == 200) {
    List responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<NotificationModel> notificationlist = responseBody
        .map((project) => NotificationModel.fromJson(project))
        .toList();

    return notificationlist;
  } else {
    return Future.error(response.statusCode);
  }
}

Future deleteNotification(int noticeid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("$serverUri/user_api/alarm?id=$noticeid");

  http.Response response =
      await http.delete(uri, headers: {"Authorization": "Token $token"});

  print("알림 삭제: ${response.statusCode}");
  if (response.statusCode == 200) {
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
