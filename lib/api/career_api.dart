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

Future<HTTPResponse> getTopPost(int id) async {
  ConnectivityResult result = await initConnectivity();


  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    // print(userid);
    final topPostUrl =
        Uri.parse("$serverUri/rank/ranking?id=10");

    try {
      http.Response response = await http.get(topPostUrl,
          headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Post> topPostList = responseBody.map((post) {
        return Post.fromJson(post);
      }).toList();
        return  HTTPResponse.success(topPostList);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('이미 삭제된 포스팅입니다', response.statusCode);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}