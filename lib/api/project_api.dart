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
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    Uri uri = Uri.parse('$serverUri/project_api/project');
    try {
      print(projectAddController.selectCompany.value.userId);
      var body = {
        'project_name': projectAddController.projectnamecontroller.text,
        'looper': projectAddController.selectedpersontaglist
            .map((person) => person.id)
            .toList(),
        'is_public': projectAddController.isPublic.value,
        'company': projectAddController.selectCompany.value.userId
      };

      final headers = {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      };

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      // var request = http.MultipartRequest('POST', uri);

      // request.headers.addAll(headers);

      // request.fields['project_name'] =
      //     projectAddController.projectnamecontroller.text;

      // request.fields['looper'] = json.encode(projectAddController
      //     .selectedpersontaglist
      //     .map((person) => person.id)
      //     .toList());

      // request.fields['is_public'] =
      //     projectAddController.isPublic.value.toString();

      // http.StreamedResponse response = await request.send();

      print("활동 생성: ${response.statusCode}");
      if (response.statusCode == 201) {
        // String responsebody = await response.stream.bytesToString();
        // var responsemap = json.decode(responsebody);
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        print(responseBody);
        return HTTPResponse.success(responseBody);
      } else {
        //!GA
        return HTTPResponse.apiError('fail', response.statusCode);
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

Future<HTTPResponse> getproject(int projectId, int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    try {
      final uri = Uri.parse(
          "$serverUri/project_api/project?project_id=$projectId&user_id=$userId");
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("활동 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        Project project = Project.fromJson(responseBody);

        return HTTPResponse.success(project);
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 활동입니다', 1400);
        return HTTPResponse.success('');
      }
      return HTTPResponse.apiError('', response.statusCode);
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

enum ProjectUpdateType { project_name, date, looper }

Future updateproject(int projectId, ProjectUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  ProjectDetailController controller =
      Get.find<ProjectDetailController>(tag: projectId.toString());
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    ProjectAddController projectAddController = Get.find();
    TagController tagController = Get.find(tag: Tagtype.Posting.toString());

    String? token = await const FlutterSecureStorage().read(key: "token");
    Uri uri = Uri.parse(
        '$serverUri/project_api/project?id=$projectId&type=${updateType.name}');
    try {
      var request = http.MultipartRequest('PUT', uri);

      final headers = {
        'Authorization': 'Token $token',
        'Content-Type': 'multipart/form-data',
      };

      request.headers.addAll(headers);

      if (updateType == ProjectUpdateType.project_name) {
        request.fields['project_name'] =
            projectAddController.projectnamecontroller.text;
        if (projectAddController.selectCompany.value.name != '') {
          request.fields['company'] =
              projectAddController.selectCompany.value.userId.toString();
        }
      } else if (updateType == ProjectUpdateType.date) {
        request.fields['start_date'] = DateFormat('yyyy-MM-dd').format(
            DateTime.parse(projectAddController.selectedStartDateTime.value));
        request.fields['end_date'] = projectAddController.isEndedProject.value
            ? DateFormat('yyyy-MM-dd').format(
                DateTime.parse(projectAddController.selectedEndDateTime.value))
            : '';
      } else if (updateType == ProjectUpdateType.looper) {
        request.fields['looper'] = json.encode(projectAddController
            .selectedpersontaglist
            .map((person) => person.id)
            .toList());
      }

      http.StreamedResponse response = await request.send();
      print("활동 수정: ${response.statusCode}");
      if (response.statusCode == 200) {
        // late Project project;
        // await getproject(controller.project.value.id).then((value) {if(value.isError == false){
        //   project = value.data;
        // }});
        // if (project != null) {
        //   if (Get.isRegistered<ProfileController>()) {
        //     int projectindex = ProfileController.to.myProjectList
        //         .indexWhere((inproject) => inproject.id == project.id);
        //     ProfileController.to.myProjectList.removeAt(projectindex);
        //     ProfileController.to.myProjectList.insert(projectindex, project);
        //   }
        // }

        Get.back();
        showCustomDialog('변경이 완료되었어요', 1000);
        // String responsebody = await response.stream.bytesToString();
        // print(responsebody);
        // var responsemap = json.decode(responsebody);
        // print(responsemap);
        // Project project = Project.fromJson(responsemap);
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

enum DeleteType { exit, del }
Future<HTTPResponse> deleteProject(int projectId, DeleteType type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    try {
      final uri = Uri.parse(
          "$serverUri/project_api/project?id=$projectId&type=${type.name}"); //type exit del
      http.Response response =
          await http.delete(uri, headers: {"Authorization": "Token $token"});

      print("프로젝트(커리어) 삭제 : ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success('');
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 활동입니다', 1400);
        return HTTPResponse.success('');
      }
      return HTTPResponse.apiError('', response.statusCode);
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> updateCareer(int projectId, List<User>? selectedMember,
    String? title, ProjectUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    try {
      final uri = Uri.parse(
          "$serverUri/project_api/project?type=${updateType.name}&id=$projectId");
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
      }
      print(request.files);
      http.StreamedResponse response = await request.send();
      print("커리어 업데이트: ${response.statusCode}");
      if (response.statusCode == 200) {
        return HTTPResponse.success('');
      }
      return HTTPResponse.apiError('', response.statusCode);
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print("커리어 업데이트 에러: $e");
      return HTTPResponse.unexpectedError(e);
    }
  }
}
