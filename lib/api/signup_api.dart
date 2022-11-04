import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/login_api.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';

import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';

import '../app.dart';
import '../constant.dart';

Future<HTTPResponse> emailRequest(
    String email, Rx<Emailcertification> emailcertification,
    {required bool isCreate}) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    emailcertification(Emailcertification.fail);
    return HTTPResponse.networkError();
  } else {
    Uri uri = Uri.parse(
        '$serverUri/user_api/check_email?is_create=${isCreate ? 1 : 0}');

    var checkemail = {
      //TODO: 학교 도메인 확인
      "email": email,
    };
return HTTPResponse.httpErrorHandling(() async {
      emailcertification(Emailcertification.waiting);
      // showBottomSnackbar("$email로\n인증 메일을 보냈어요\n메일을 확인하고 인증을 완료해주세요");

      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(checkemail),
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));
      

      // response.
      print("이메일 체크 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("SUCCESS");
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
   
  }
}

Future<HTTPResponse> certfyNumRequest(String email, String number) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    Uri uri = Uri.parse('$serverUri/user_api/activate');

    var _body = {
      "email": email,
      "certify_num": number,
    };
    
    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(_body),
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      // response.
      print("인증번호 체크 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success("SUCCESS");
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  
  }
}

// Future<HTTPResponse> emailvalidRequest() async {
//   ConnectivityResult result = await initConnectivity();
//   SignupController signupController = Get.put(SignupController());
//   if (result == ConnectivityResult.none) {
//     signupController.signupcertification(Emailcertification.fail);
//     return HTTPResponse.networkError();
//   } else {
//     Uri uri = Uri.parse(
//         '$serverUri/user_api/valid?email=${signupController.emailidcontroller.text}@${signupController.selectUniv.value.email}');

//     // var checkemail = {
//     //   //TODO: 학교 도메인 확인
//     //   "email": signupController.emailidcontroller.text +
//     //       "@" +
//     //       signupController.selectUniv.value.email,
//     // };
//     try {
//       http.Response response = await http.get(
//         uri,
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//       );

//       // response.
//       print("이메일 인증 여부 체크 : ${response.statusCode}");
//       if (response.statusCode == 200) {
//         return HTTPResponse.success("success");
//       } else {
//         return HTTPResponse.apiError("fail", response.statusCode);
//       }
//     } on SocketException {
//       return HTTPResponse.serverError();
//     } catch (e) {
//       print(e);
//       return HTTPResponse.unexpectedError(e);
//     }
//   }
// }


Future<HTTPResponse> signupRequest() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    final SignupController signupController = Get.find();

    Uri uri = Uri.parse('$serverUri/user_api/signup');
    const FlutterSecureStorage storage = FlutterSecureStorage();
    //todo : @inu.ac.kr
    var user = {
      "email": signupController.emailidcontroller.text +
          "@" +
          signupController.selectUniv.value.email,
      "password": signupController.passwordcontroller.text,
      "image": null,
      "type": 0,
      "admission": signupController.admissioncontroller.text,
      "real_name": signupController.namecontroller.text,
      "school": signupController.selectUniv.value.id,
      "department": signupController.selectDept.value.id,
    };
    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(user),
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("회원가입: ${response.statusCode}");
      if (response.statusCode == 201) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    });
   
  }
}

Future<HTTPResponse> searchUniv(String text) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // print(userid);
    final searchUnivUri =
        Uri.parse("$serverUri/search_api/search_uni?type=school&query=$text");
    return HTTPResponse.httpErrorHandling(() async {
       http.Response response = await http.get(
        searchUnivUri,
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
    
  }
}

Future<HTTPResponse> searchDept(int univId, String text) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // print(userid);
    final searchDeptUri = Uri.parse(
        "$serverUri/search_api/search_uni?type=department&id=$univId&query=$text");
    return HTTPResponse.httpErrorHandling(() async {
        http.Response response = await http.get(
        searchDeptUri,
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}
