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
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/model/user_model.dart';
import '../constant.dart';
import '../controller/home_controller.dart';

Future<HTTPResponse> getProfile(int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    int isStudent = AppController.to.userType == UserType.student ? 1 : 0;
    print('user token: $token');

    var uri = Uri.parse(
        "$serverUri/user_api/profile?id=$userId&is_student=$isStudent");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("프로필 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        // Get.back();
        // showCustomDialog('이미 삭제된 유저입니다', 1400);
        return HTTPResponse.apiError("", response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> getCorpProfile(int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    int isStudent = AppController.to.userType == UserType.student ? 1 : 0;
    print('user token: $token');

    var uri = Uri.parse(
        "$serverUri/user_api/corp_profile?id=$userId&is_student=$isStudent");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("기업 프로필 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        // Get.back();
        // showCustomDialog('이미 삭제된 유저입니다', 1400);
        return HTTPResponse.apiError("", response.statusCode);
      }
    });
  }
}

// type: all, shown(기업이 조회한 프로필), user(기업을 조회한 유저들)
Future<HTTPResponse> getCompShowUsers(String type, int page) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    print('user token: $token');

    var uri = Uri.parse("$serverUri/user_api/view_list?type=$type&page=$page");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("기업 조회 $type 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("", response.statusCode);
      }
    });
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

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

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
    });
  }
}

Future<HTTPResponse> getCareerPosting(int careerId, int page) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    var uri = Uri.parse(
        "$serverUri/user_api/posting?id=$careerId&page=$page&type=career");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

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
    });
  }
}

Future<HTTPResponse> getAllPosting(int userId, int page) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    var uri =
        Uri.parse("$serverUri/user_api/posting?id=$userId&page=$page&type=all");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("프로필 모든 포스팅 리스트 get: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> postProjectArrange(List<Project> careerList) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse("$serverUri/user_api/project");

    return HTTPResponse.httpErrorHandling(() async {
      Map<String, int> body = {};
      careerList.asMap().entries.forEach((entry) {
        body[entry.value.id.toString()] = entry.key;
      });

      http.Response response = await http
          .post(uri,
              headers: {
                "Authorization": "Token $token",
                'Content-Type': 'application/json',
              },
              body: json.encode(body))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("커리어 정렬: ${response.statusCode}");
      if (response.statusCode == 200) {
        // var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("", response.statusCode);
      }
    });
  }
}

enum ProfileUpdateType { image, sns, profile }

Future<HTTPResponse> updateProfile(
    {Person? user,
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

        request.fields['image'] =
            user!.profileImage != "" ? json.encode(null) : user.profileImage;
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

    return HTTPResponse.httpErrorHandling(() async {
      http.StreamedResponse response = await request
          .send()
          .timeout(Duration(milliseconds: HTTPResponse.timeout));
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
    });
  }
}

Future<HTTPResponse> getInterestedCompany(int userId, int page) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    var uri = Uri.parse(
        "$serverUri/user_api/interest_companies?id=$userId&page=$page");

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("관심 기업 get: ${response.statusCode}");
      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));

        print(responseBody);

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> deleteSNS(int snsId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    Uri uri = Uri.parse('$serverUri/user_api/profile?type=sns&id=$snsId');

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("SNS 삭제 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
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

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http
          .put(uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'Token $token',
              },
              body: json.encode(password))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("비밀번호 변경 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}

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
      "department": HomeController.to.myProfile.value is Person
          ? (HomeController.to.myProfile.value as Person).department
          : ""
    };

    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http
          .post(uri,
              headers: {
                'Content-Type': 'application/json',
                "Authorization": "Token $token"
              },
              body: json.encode(password))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

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
    });
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

    return HTTPResponse.httpErrorHandling(() async {
      final response = await http
          .post(uri,
              headers: {
                'Content-Type': 'application/json',
                "Authorization": "Token $token"
              },
              body: json.encode(body))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('유저 신고 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}

enum InquiryType { normal, school, department, company_signup, company_info }

Future<HTTPResponse> inquiryRequest(
  InquiryType type, {
  String? content,
  String? email,
  String? name,
}) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    final Uri uri = Uri.parse("$serverUri/user_api/ask?type=${type.name}");
    Map body = {};

    if (type == InquiryType.normal) {
      ContactContentController controller = Get.find();
      body = {
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
        "real_name": HomeController.to.myProfile.value.name,
        "department": HomeController.to.myProfile.value is Person
            ? (HomeController.to.myProfile.value as Person).department
            : "",
        "id": HomeController.to.myProfile.value.userId
      };
    } else if (type == InquiryType.school) {
      body = {"content": content};
    } else if (type == InquiryType.department) {
      body = {
        "school": SignupController.to.selectUniv.value.univname,
        "content": content
      };
    } else {
      body = {
        "company_name": name,
        "email": email,
        "type": type.name,
      };
    }

    return HTTPResponse.httpErrorHandling(() async {
      final response = await http
          .post(uri,
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode(body))
          .timeout(Duration(milliseconds: HTTPResponse.timeout));

      print('문의하기 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
  }
}
