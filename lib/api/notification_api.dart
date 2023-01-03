import 'dart:async';
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
import 'package:loopus/model/environment_model.dart';
import '../controller/error_controller.dart';

Future<HTTPResponse> getNotificationlist(String type, int lastindex) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse(
        "${Environment.apiUrl}/user_api/alarm?type=$type&last=$lastindex");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("알림 $type 리스트 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> deleteNotification(int noticeid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse("${Environment.apiUrl}/user_api/alarm?id=$noticeid");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.delete(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("알림 삭제: ${response.statusCode}");

      if (response.statusCode == 200) {
        return HTTPResponse.success(null);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> isNotiRead(int notiId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    final isReadURI =
        Uri.parse("${Environment.apiUrl}/user_api/alarm?type=read&id=$notiId");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(isReadURI, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("알림 읽기: ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success(null);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}
