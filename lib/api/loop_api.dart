import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/looppeople_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';

import '../constant.dart';

enum followlist { follower, following }

Future<void> getfollowlist(int userid, followlist followtype) async {
  ConnectivityResult result = await initConnectivity();
  LoopPeopleController controller = Get.find(tag: userid.toString());
  if (result == ConnectivityResult.none) {
    if (followtype == followlist.follower) {
      controller.followerscreenstate(ScreenState.disconnect);
    } else {
      controller.followingscreenstate(ScreenState.disconnect);
    }
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse(
        "$serverUri/loop_api/get_list/${describeEnum(followtype)}/$userid");

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print('루프 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        List<User> looplist = List.from(responseBody["follow"])
            .map((friend) => User.fromJson(friend))
            .toList();

        if (followtype == followlist.follower) {
          controller.followerlist(looplist);
        } else {
          controller.followinglist(looplist);
        }
        if (followtype == followlist.follower) {
          controller.followerscreenstate(ScreenState.success);
        } else {
          controller.followingscreenstate(ScreenState.success);
        }
        return;
      } else {
        if (followtype == followlist.follower) {
          controller.followerscreenstate(ScreenState.error);
        } else {
          controller.followingscreenstate(ScreenState.error);
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

Future<void> getprojectfollowlist(int userid, followlist followtype) async {
  ConnectivityResult result = await initConnectivity();
  ProjectAddController controller = Get.find();
  if (result == ConnectivityResult.none) {
    controller.looppersonscreenstate(ScreenState.disconnect);
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse(
        "$serverUri/loop_api/get_list/${describeEnum(followtype)}/$userid");

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print('루프 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        List<User> looplist = List.from(responseBody["follow"])
            .map((friend) => User.fromJson(friend))
            .toList();

        controller.looplist = looplist;
        controller.looppersonlist(controller.looplist
            .map((user) => CheckBoxPersonWidget(user: user))
            .toList());

        controller.looppersonscreenstate(ScreenState.success);
        return;
      } else {
        controller.looppersonscreenstate(ScreenState.error);
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

Future<void> postfollowRequest(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/loop/$friendid");

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

// Future<void> postloopPermit(int friendid) async {
//   String? token = await const FlutterSecureStorage().read(key: "token");

//   final uri = Uri.parse("$serverUri/loop_api/loop/$friendid");

//   http.Response response =
//       await http.post(uri, headers: {"Authorization": "Token $token"});

//   print('루프 허락 statusCode: ${response.statusCode}');
//   if (response.statusCode == 200) {
//     var responseBody = json.decode(utf8.decode(response.bodyBytes));
//     print(responseBody);
//   } else {
//     return Future.error(response.statusCode);
//   }
// }

Future<void> deletefollow(int friendid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/loop_api/unloop/$friendid");

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
