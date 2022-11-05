import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';

import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/trash_bin/project_screen.dart';

import '../constant.dart';

Future<HTTPResponse> addproject() async {
  ConnectivityResult result = await initConnectivity();
  final ProjectAddController projectAddController = Get.find();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    int userId = projectAddController.selectCompany.value.userId;
    String? token = await const FlutterSecureStorage().read(key: "token");
    Uri uri = Uri.parse(
        '$serverUri/project_api/project${userId != 0 ? "?company_id=$userId" : ""}');
    return HTTPResponse.httpErrorHandling(() async {
      print(projectAddController.selectCompany.value.userId);
      var body = {
        'project_name': projectAddController.projectnamecontroller.text,
        'looper': projectAddController.selectedpersontaglist
            .map((person) => person.id)
            .toList(),
        'is_public': projectAddController.isPublic.value,
      };

      final headers = {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      };

      http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(Duration(milliseconds: HTTPResponse.timeout));
      print("활동 생성: ${response.statusCode}");
      if (response.statusCode == 201) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        // Project career = Project.fromJson(responseBody);
        print(responseBody);
        return HTTPResponse.success(responseBody);
      } else {
        //!GA
        return HTTPResponse.apiError('fail', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> getproject(int projectId, int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "$serverUri/project_api/project?project_id=$projectId&user_id=$userId");
      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));
      print(uri);
      print("활동 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

enum ProjectUpdateType { project_name, date, looper }
Future<HTTPResponse> updateCareer(int projectId, ProjectUpdateType updateType,
    {List<User>? selectedMember,
    String? title,
    String? companyName,
    int? companyId}) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "$serverUri/project_api/project?type=${updateType.name}&id=$projectId${companyId != 0 ? "&company_id=$companyId" : ""}");
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll({
        "Authorization": "Token $token",
        'Content-Type': 'multipart/form-data'
      });
      if (updateType == ProjectUpdateType.looper) {
        for (var member in selectedMember!) {
          var multipartFile = await http.MultipartFile.fromString(
              'looper', member.userId.toString());
          request.files.add(multipartFile);
        }
      } else if (updateType == ProjectUpdateType.project_name) {
        request.fields['project_name'] = title!;
        if (companyId != 0) {
          request.fields['company_name'] = companyName!;
        }
      }
      print(request.files);
      http.StreamedResponse response = await request
          .send()
          .timeout(Duration(milliseconds: HTTPResponse.timeout));
      print("커리어 업데이트: ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success('');
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

enum DeleteType { exit, del }
Future<HTTPResponse> deleteProject(int projectId, DeleteType type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "$serverUri/project_api/project?id=$projectId&type=${type.name}"); //type exit del
      http.Response response = await http.delete(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("프로젝트(커리어) 삭제 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success('');
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 활동입니다', 1400);
        return HTTPResponse.success('');
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}
