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

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print('차단 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        List<User> userlist = List.from(responseBody['banlist'])
            .map((banuser) => User.fromJson(banuser))
            .toList();

        return HTTPResponse.success(userlist);
      } else if (response.statusCode == 404) {
        return HTTPResponse.success(<User>[]);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> userban(int userid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');

    final Uri uri = Uri.parse("$serverUri/user_api/ban?id=$userid");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      );

      print('유저 차단 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future userbancancel(int userid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/user_api/ban?id=$userid");

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      );

      print('유저 차단해제 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        //상대가 나를 차단 했는지에 대한 여부를 알아야 할 듯
        if (Get.isRegistered<OtherProfileController>(tag: userid.toString())) {
          Get.find<OtherProfileController>(tag: userid.toString())
              .otherUser
              .value
              .banned(BanState.normal);
        }
        if (Get.isRegistered<BanPeopleController>()) {
          Get.find<BanPeopleController>()
              .banlist
              .removeWhere((banuser) => banuser.userid == userid);
        }
        showCustomDialog("해당 유저가 차단해제 되었습니다", 1000);
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
}
