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

Future<HTTPResponse> getScoutCompanySearch({
  required int page,
  String query = "",
  required String fieldId,
}) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    // print(userid);
    final _url = Uri.parse(
        "$serverUri/scout_api/company_group?type=$fieldId&page=$page&query=$query");

    try {
      http.Response response =
          await http.get(_url, headers: {"Authorization": "Token $token"});
      print("스카우트 리포트 기업 정보 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print("스카우트 리포트 기업 정보 로드: $e");
      return HTTPResponse.unexpectedError(e);
    }
  }
}

// student: 0 , corp: 1
Future<HTTPResponse> getRecommandCompanys(String isCorp) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    // final _url = Uri.parse("$serverUri/scout_api/recommendation_company");
    final _url =
        Uri.parse("$serverUri/scout_api/recommendation_company?type=$isCorp");

    try {
      http.Response response =
          await http.get(_url, headers: {"Authorization": "Token $token"});
      print("스카우트 리포트 추천 기업 정보 로드: ${response.statusCode}");
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
      print("스카우트 리포트 추천 기업 정보 로드: $e");
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}
