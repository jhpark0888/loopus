import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/widget/notification_widget.dart';

import '../controller/error_controller.dart';

Future<void> getNotificationlist(String type, int lastindex) async {
  ConnectivityResult result = await initConnectivity();
  NotificationDetailController controller = Get.find();
  if (result == ConnectivityResult.none) {
    if (type == NotificationType.follow.name && lastindex == 0) {
      controller.followreqscreenstate(ScreenState.disconnect);
    } else if (type == "" && lastindex == 0) {
      controller.notificationscreenstate(ScreenState.disconnect);
    }

    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse("$serverUri/user_api/alarm?type=$type&last=$lastindex");

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("알림 $type 리스트 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));
        print(responseBody);
        List<NotificationModel> notificationlist = responseBody
            .map((project) => NotificationModel.fromJson(project))
            .toList();

        if (type == NotificationType.follow.name) {
          if (notificationlist.isEmpty && controller.followalarmlist.isEmpty) {
            controller.isfollowreqEmpty.value = true;
          } else if (notificationlist.isEmpty &&
              controller.followalarmlist.isNotEmpty) {
            controller.enablefollowreqPullup.value = false;
          }

          controller.followalarmlist.value = notificationlist
              .map((e) => NotificationWidget(key: UniqueKey(), notification: e))
              .toList();
          controller.followreqscreenstate(ScreenState.success);
        } else {
          if (notificationlist.isEmpty && controller.alarmlist.isEmpty) {
            controller.isalarmEmpty.value = true;
          } else if (notificationlist.isEmpty &&
              controller.alarmlist.isNotEmpty) {
            controller.enablealarmPullup.value = false;
          }

          controller.alarmlist.value = notificationlist
              .map((e) => NotificationWidget(key: UniqueKey(), notification: e))
              .toList();
          controller.notificationscreenstate(ScreenState.success);
        }

        return;
      } else {
        if (type == NotificationType.follow.name) {
          controller.followreqscreenstate(ScreenState.error);
        } else {
          controller.notificationscreenstate(ScreenState.error);
        }
        return Future.error(response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future deleteNotification(int noticeid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("$serverUri/user_api/alarm?id=$noticeid");

  try {
    http.Response response =
        await http.delete(uri, headers: {"Authorization": "Token $token"});

    print("알림 삭제: ${response.statusCode}");
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(response.statusCode);
    }
  } on SocketException {
    // ErrorController.to.isServerClosed(true);
  } catch (e) {
    print(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<HTTPResponse> isRead(int notiId, NotificationType type,int senderId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    late int type_id = type == NotificationType.question
        ? 1
        : type == NotificationType.follow
            ? 2
            : type == NotificationType.tag
                ? 3
                : 4;
    final isReadURI = Uri.parse(
        "$serverUri/user_api/alarm?type=read&id=$notiId&type_id=$type_id&sender_id=$senderId");

    try {
      http.Response response =
          await http.get(isReadURI, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        print(response.statusCode);
        return HTTPResponse.success(null);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}
