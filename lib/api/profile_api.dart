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
import 'package:loopus/model/sns_model.dart';

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

    try {
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
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getCareerPosting(int careerId, int page) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri = Uri.parse(
      "$serverUri/user_api/posting?id=$careerId&page=$page&type=career");
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("커리어 안 포스팅 리스트 get: ${response.statusCode}");
      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));

        List<Post> postlist = responseBody.map((post) {
          return Post.fromJson(post);
        }).toList();
        return HTTPResponse.success(postlist);
      } else if (response.statusCode == 204) {
        return HTTPResponse.success(<Post>[]);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getAllPosting(int userId, int page) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  var uri =
      Uri.parse("$serverUri/user_api/posting?id=$userId&page=$page&type=all");
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("프로필 모든 포스팅 리스트 get: ${response.statusCode}");
      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));

        List<Post> postlist = responseBody.map((post) {
          return Post.fromJson(post);
        }).toList();
        return HTTPResponse.success(postlist);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> postProjectArrange(List<Project> careerList) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse("$serverUri/user_api/project");

    try {
      Map<String, int> body = {};
      careerList.asMap().entries.forEach((entry) {
        body[entry.value.id.toString()] = entry.key;
      });

      http.Response response = await http.post(uri,
          headers: {
            "Authorization": "Token $token",
            'Content-Type': 'application/json',
          },
          body: json.encode(body));

      print("커리어 정렬: ${response.statusCode}");
      if (response.statusCode == 200) {
        // var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

enum ProfileUpdateType { image, sns, profile }

Future<HTTPResponse> updateProfile(
    {User? user,
    File? image,
    SNS? sns,
    String? email,
    String? name,
    int? deptId,
    int? univId,
    String? admission,
    required ProfileUpdateType updateType}) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
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

        request.fields['image'] = user!.profileImage ?? json.encode(null);
      }
    } else if (updateType == ProfileUpdateType.sns) {
      request.fields['type'] = sns!.snsType.index.toString();
      request.fields['url'] = sns.url;
    } else if (updateType == ProfileUpdateType.profile) {
      request.fields['email'] = email!;
      request.fields['real_name'] = name!;
      request.fields['department'] = deptId!.toString();
      request.fields['school'] = univId!.toString();
      request.fields['admission'] = admission!;
    }

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        String responsebody = await response.stream.bytesToString();
        var responsemap = jsonDecode(responsebody);

        if (kDebugMode) {
          print("profile status code : ${response.statusCode}");
        }

        return HTTPResponse.success(responsemap);
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print("profile status code : ${response.statusCode}");
        }
        return HTTPResponse.apiError("fail", response.statusCode);
      } else {
        if (kDebugMode) {
          print("profile status code : ${response.statusCode}");
        }
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

// Future postlogout() async {
//   ConnectivityResult result = await initConnectivity();
//   if (result == ConnectivityResult.none) {
//     showdisconnectdialog();
//   } else {
//     String? token = await const FlutterSecureStorage().read(key: "token");
//     print('user token: $token');

//     var uri = Uri.parse("$serverUri/user_api/logout");

//     try {
//       http.Response response =
//           await http.post(uri, headers: {"Authorization": "Token $token"});

//       print("로그아웃: ${response.statusCode}");
//       if (response.statusCode == 200) {
//         AppController.to.currentIndex.value = 0;
//         FlutterSecureStorage().delete(key: "token");
//         FlutterSecureStorage().delete(key: "id");
//         Get.delete<AppController>();
//         Get.delete<HomeController>();
//         Get.delete<SearchController>();
//         Get.delete<ProfileController>();
//         Get.offAll(() => StartScreen());
//       } else {
//         return Future.error(response.statusCode);
//       }
//     } on SocketException {
//       // ErrorController.to.isServerClosed(true);
//     } catch (e) {
//       print(e);
//       // ErrorController.to.isServerClosed(true);
//     }
//   }
// }

Future<HTTPResponse> deleteuser(String pw, String reason) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print('user token: $token');

    var uri = Uri.parse("$serverUri/user_api/resign");

    // for (var reasonwidget in WithDrawalController.to.reasonlist) {
    //   if (reasonwidget.isSelected.value == true) {
    //     reason += reasonwidget.text;
    //   }
    // }

    final password = {
      'password': pw,
      'reason': reason,
      "department": HomeController.to.myProfile.value.department
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
        return HTTPResponse.success('success');
      } else if (response.statusCode == 401) {
        showCustomDialog("비밀번호를 다시 입력해주세요", 1000);
        return HTTPResponse.apiError('', response.statusCode);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
        ;
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
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
      "real_name": HomeController.to.myProfile.value.realName,
      "department": HomeController.to.myProfile.value.department,
      "id": HomeController.to.myProfile.value.userid
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
