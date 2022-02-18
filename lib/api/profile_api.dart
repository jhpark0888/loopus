import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/project_model.dart';

import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/widget/notification_widget.dart';

import '../constant.dart';

Future<User> getProfile(var userId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  print('user token: $token');

  var uri = Uri.parse("$serverUri/user_api/profile?id=$userId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));

    User user = User.fromJson(responseBody);
    if (user.isuser == 1) {
      ProfileController.to.isnewalarm(responseBody["new_alarm"]);
      ProfileController.to.isnewmessage(responseBody["new_message"]);
    }
    return user;
  } else if (response.statusCode == 404) {
    Get.back();
    ModalController.to.showCustomDialog('이미 삭제된 유저입니다', 1400);
    return Future.error(response.statusCode);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<List<Project>> getProjectlist(var userId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("$serverUri/user_api/project?id=$userId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    List responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<Project> projectlist =
        responseBody.map((project) => Project.fromJson(project)).toList();

    return projectlist;
  } else {
    return Future.error(response.statusCode);
  }
}

enum ProfileUpdateType {
  image,
  department,
  tag,
}

Future<User?> updateProfile(
    User user, File? image, List? taglist, ProfileUpdateType updateType) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  print(taglist);
  final uri = Uri.parse("$serverUri/user_api/profile?type=${updateType.name}");

  var request = http.MultipartRequest('PUT', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (updateType == ProfileUpdateType.image) {
    if (image != null) {
      print('api image : ${image.path}');
      var multipartFile =
          await http.MultipartFile.fromPath('image', image.path);
      request.files.add(multipartFile);
      print('multipartFile : $multipartFile');
    } else {
      print('api error image : $image');

      request.fields['image'] = user.profileImage ?? json.encode(null);
    }
  } else if (updateType == ProfileUpdateType.department) {
    request.fields['department'] = user.department;
  } else if (updateType == ProfileUpdateType.tag) {
    request.fields['tag'] =
        json.encode(taglist ?? user.profileTag.map((tag) => tag.tag).toList());
  }

  http.StreamedResponse response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    String responsebody = await response.stream.bytesToString();
    var responsemap = jsonDecode(responsebody);
    User edituser = User.fromJson(responsemap);
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }

    return edituser;
  } else if (response.statusCode == 400) {
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }
  } else {
    if (kDebugMode) {
      print("profile status code : ${response.statusCode}");
    }
  }
}

Future<void> putpwchange() async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  ModalController _modalController = Get.put(ModalController());
  PwChangeController pwChangeController = Get.find();

  Uri uri = Uri.parse('$serverUri/user_api/password?type=change');

  //이메일 줘야 됨
  final password = {
    'origin_pw': pwChangeController.originpwcontroller.text,
    'new_pw': pwChangeController.newpwcontroller.text,
  };
  http.Response response = await http.put(uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode(password));

  print("비밀번호 변경 : ${response.statusCode}");
  if (response.statusCode == 200) {
    Get.back();
    _modalController.showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
  } else if (response.statusCode == 401) {
    _modalController.showCustomDialog('현재 비밀번호가 틀렸습니다.', 1400);
    print('에러1');
  } else {
    _modalController.showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
    print('에러');
  }
}

Future postlogout() async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  print('user token: $token');

  var uri = Uri.parse("$serverUri/user_api/resign");

  http.Response response =
      await http.delete(uri, headers: {"Authorization": "Token $token"});

  print("로그아웃: ${response.statusCode}");
  if (response.statusCode == 200) {
  } else {
    return Future.error(response.statusCode);
  }
}

Future deleteuser(String pw) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  print('user token: $token');

  var uri = Uri.parse("$serverUri/user_api/resign");

  final password = {
    'password': pw,
  };

  http.Response response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Token $token"
      },
      body: json.encode(password));

  print("회원탈퇴: ${response.statusCode}");
  if (response.statusCode == 200) {
    Get.offAll(() => StartScreen());

    Get.delete<AppController>();
  } else if (response.statusCode == 401) {
    ModalController.to.showCustomDialog("비밀번호를 다시 입력해주세요", 1000);
    return Future.error(response.statusCode);
  } else {
    return Future.error(response.statusCode);
  }
}
