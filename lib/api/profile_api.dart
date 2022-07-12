import 'dart:io';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/contact_content_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/controller/withdrawal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';

import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/widget/notification_widget.dart';
import 'package:loopus/widget/project_widget.dart';

import '../constant.dart';
import '../controller/error_controller.dart';
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';

Future<HTTPResponse> getProfile(int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print('user token: $token');

    var uri = Uri.parse("$serverUri/user_api/profile?id=$userId");
    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("프로필 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        // Get.back();
        // showCustomDialog('이미 삭제된 유저입니다', 1400);
        return HTTPResponse.apiError("", response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getProjectlist(int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse("$serverUri/user_api/project?id=$userId");

    // try {
    http.Response response =
        await http.get(uri, headers: {"Authorization": "Token $token"});

    print("프로젝트 리스트 get: ${response.statusCode}");
    if (response.statusCode == 200) {
      List responseBody = json.decode(utf8.decode(response.bodyBytes));

      return HTTPResponse.success(responseBody);
    } else {
      // if (isuser == 1) {
      //   ProfileController.to.myprofilescreenstate(ScreenState.error);
      // } else {
      //   Get.find<OtherProfileController>(tag: userId.toString())
      //       .otherprofilescreenstate(ScreenState.error);
      // }
      return HTTPResponse.apiError("", response.statusCode);
    }
    // } on SocketException {
    //   // ErrorController.to.isServerClosed(true);
    //   return HTTPResponse.serverError();
    // } catch (e) {
    //   print(e);
    //   return HTTPResponse.unexpectedError(e);
    // }
  }
}

Future<HTTPResponse> getCareerPosting(int careerId, int page) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse("$serverUri/user_api/posting?id=$careerId&page=$page");
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // try {
    http.Response response =
        await http.get(uri, headers: {"Authorization": "Token $token"});

    print("커리어 안 포스팅 리스트 get: ${response.statusCode}");
    if (response.statusCode == 200) {
      List responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Post> postlist = responseBody.map((post) {
        return Post.fromJson(post);
      }).toList();
      return HTTPResponse.success(postlist);
    } else {
      return HTTPResponse.apiError('', response.statusCode);
    }
    // } on SocketException {
    //   ErrorController.to.isServerClosed(true);
    //   return HTTPResponse.serverError();
    // } catch (e) {
    //   print(e);
    //   // ErrorController.to.isServerClosed(true);
    //   return HTTPResponse.unexpectedError(e);
    // }
  }
}

enum ProfileUpdateType {
  image,
  department,
  tag,
}

Future<User?> updateProfile(
    User user, File? image, List? taglist, ProfileUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print(taglist);
    final uri =
        Uri.parse("$serverUri/user_api/profile?type=${updateType.name}");

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
      request.fields['tag'] = json
          .encode(taglist ?? user.profileTag.map((tag) => tag.tag).toList());
    }

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        String responsebody = await response.stream.bytesToString();
        var responsemap = jsonDecode(responsebody);
        User edituser = User.fromJson(responsemap);

        if (updateType == ProfileUpdateType.tag) {
          Get.back();
          showCustomDialog('관심 태그 기반으로 홈 화면을 재구성했어요', 1500);
        }
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
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<HTTPResponse> putpwchange() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    PwChangeController pwChangeController = Get.find();

    Uri uri = Uri.parse('$serverUri/user_api/password?type=change');

    //이메일 줘야 됨
    final password = {
      'origin_pw': pwChangeController.originpwcontroller.text,
      'new_pw': pwChangeController.newpwcontroller.text,
    };

    try {
      http.Response response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
          body: json.encode(password));

      print("비밀번호 변경 : ${response.statusCode}");
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

Future postlogout() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print('user token: $token');

    var uri = Uri.parse("$serverUri/user_api/logout");

    try {
      http.Response response =
          await http.post(uri, headers: {"Authorization": "Token $token"});

      print("로그아웃: ${response.statusCode}");
      if (response.statusCode == 200) {
        AppController.to.currentIndex.value = 0;
        FlutterSecureStorage().delete(key: "token");
        FlutterSecureStorage().delete(key: "id");
        Get.delete<AppController>();
        Get.delete<HomeController>();
        Get.delete<SearchController>();
        Get.delete<ProfileController>();
        Get.offAll(() => StartScreen());
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

Future<HTTPResponse> deleteuser(String pw) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print('user token: $token');

    var uri = Uri.parse("$serverUri/user_api/resign");

    String reason = "";
    for (var reasonwidget in WithDrawalController.to.reasonlist) {
      if (reasonwidget.isSelected.value == true) {
        reason += reasonwidget.text;
      }
    }

    final password = {
      'password': pw,
      'reason': reason,
      "department": ProfileController.to.myUserInfo.value.department
    };

    try {
      http.Response response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(password));

      print("회원탈퇴: ${response.statusCode}");
      if (response.statusCode == 200) {
        Get.offAll(() => StartScreen());

        FlutterSecureStorage().delete(key: "token");
        FlutterSecureStorage().delete(key: "id");
        FlutterSecureStorage().delete(key: "login detect");
        Get.delete<AppController>();
        Get.delete<HomeController>();
        Get.delete<SearchController>();
        Get.delete<ProfileController>();

        return HTTPResponse.success('success');
      } else if (response.statusCode == 401) {
        showCustomDialog("비밀번호를 다시 입력해주세요", 1000);
        return HTTPResponse.apiError('', response.statusCode);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
        ;
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

Future<HTTPResponse> userreport(int userid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');

    final Uri uri = Uri.parse("$serverUri/user_api/report");

    var body = {"id": userid, "reason": ""};

    try {
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('유저 신고 statusCode: ${response.statusCode}');
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

Future inquiry() async {
  ConnectivityResult result = await initConnectivity();
  ContactContentController controller = Get.find();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/user_api/ask");

    var body = {
      "email": controller.emailcontroller.text.trim(),
      "content": controller.contentcontroller.text,
      "os": controller.userDeviceInfo.deviceData.isNotEmpty
          ? "${controller.userDeviceInfo.deviceData.values.first}"
          : "",
      "device": controller.userDeviceInfo.deviceData.isNotEmpty
          ? "${controller.userDeviceInfo.deviceData.values.last}"
          : "",
      "app_ver": controller.userDeviceInfo.appInfoData.isNotEmpty
          ? controller.userDeviceInfo.appInfoData.keys.first +
              ' ' +
              controller.userDeviceInfo.appInfoData.values.first
          : "",
      "real_name": ProfileController.to.myUserInfo.value.realName,
      "department": ProfileController.to.myUserInfo.value.department,
      "id": ProfileController.to.myUserInfo.value.userid
    };

    try {
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('문의하기 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        showCustomDialog("문의가 접수되었습니다", 1000);
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

// Future logindetect() async {
//   ConnectivityResult result = await initConnectivity();
//   NotificationController notificationController =
//       Get.put(NotificationController());
//   if (result == ConnectivityResult.none) {
//     showdisconnectdialog();
//   } else {
//     String? token;
//     await const FlutterSecureStorage().read(key: 'token').then((value) {
//       token = value;
//     });

//     final Uri uri = Uri.parse("$serverUri/user_api/check_token");

//     var body = {"fcm_token": await notificationController.getToken()};

//     try {
//       final response = await http.post(uri,
//           headers: {
//             'Content-Type': 'application/json',
//             "Authorization": "Token $token"
//           },
//           body: json.encode(body));

//       print('토큰 검사 statusCode: ${response.statusCode}');
//       if (response.statusCode == 200) {
//       } else {
//         showoneButtonDialog(
//           title: '로그인 감지',
//           content: '다른 기기에서 해당 계정으로 로그인 하여 로그아웃합니다',
//           oneFunction: () {
//             AppController.to.currentIndex.value = 0;
//             FlutterSecureStorage().delete(key: "token");
//             FlutterSecureStorage().delete(key: "id");
//             Get.delete<AppController>();
//             Get.delete<HomeController>();
//             Get.delete<SearchController>();
//             Get.delete<ProfileController>();
//             Get.offAll(() => StartScreen());
//           },
//           oneText: '확인',
//         );
//       }
//     } on SocketException {
//       ErrorController.to.isServerClosed(true);
//     } catch (e) {
//       print(e);
//       // ErrorController.to.isServerClosed(true);
//     }
//   }
// }
