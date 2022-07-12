import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/post_model.dart';

//type: main(포스팅 및 사람), all(사람 순위 100명까지)
Future<HTTPResponse> getTopPost(String id, String type, {int? page}) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    // print(userid);
    final topPostUrl = Uri.parse("$serverUri/rank/ranking?id=$id&type=$type" +
        (page != null ? "&page=$page" : ""));

    try {
      http.Response response = await http
          .get(topPostUrl, headers: {"Authorization": "Token $token"});
      print("인기 포스팅 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        // List<Post> topPostList = responseBody.map((post) {
        //   return Post.fromJson(post);
        // }).toList();
        return HTTPResponse.success(responseBody);
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

Future<HTTPResponse> getPostingTrend(String id) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    // print(userid);
    final topPostUrl = Uri.parse("$serverUri/rank/posting_trends?id=$id");

    try {
      http.Response response = await http
          .get(topPostUrl, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            json.decode(utf8.decode(response.bodyBytes));
        Map<String, dynamic> tempt = responseBody['monthly_count'];
        return HTTPResponse.success(tempt);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('이미 삭제된 포스팅입니다', response.statusCode);
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
