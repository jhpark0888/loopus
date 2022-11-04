import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/banpeople_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/user_model.dart';

Future<HTTPResponse> getbanlist() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/user_api/ban");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('차단 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        List<Person> banlist = List.from(responseBody['banlist'])
            .map((e) => Person.fromJson(e))
            .toList();
        return HTTPResponse.success(banlist);
      } else if (response.statusCode == 404) {
        return HTTPResponse.success(<Person>[]);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> userban(int userid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');

    final Uri uri = Uri.parse("$serverUri/user_api/ban?id=$userid");

    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('유저 차단 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> userbancancel(int userid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/user_api/ban?id=$userid");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('유저 차단해제 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        //상대가 나를 차단 했는지에 대한 여부를 알아야 할 듯

        return HTTPResponse.success("SUCCESS");
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  }
}

enum BanType {ban,resign}

Future<HTTPResponse> userResign(int userid, BanType type, int? otherId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');

    final Uri uri = Uri.parse("$serverUri/user_api/ban?id=$userid&type=${type.name}&${otherId != null ?"other_id=$otherId":""}");

    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('유저 차단 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });

  
  }
}