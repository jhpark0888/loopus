import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/project_widget.dart';

import '../constant.dart';

Future addproject() async {
  ConnectivityResult result = await initConnectivity();
  final ProjectAddController projectAddController = Get.find();
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    final LocalDataController _localDataController =
        Get.put(LocalDataController());
    TagController tagController = Get.find(tag: Tagtype.project.toString());
    final GAController _gaController = Get.put(GAController());

    String? token = await const FlutterSecureStorage().read(key: "token");
    Uri uri = Uri.parse('$serverUri/project_api/project');
    try {
      var request = http.MultipartRequest('POST', uri);

      final headers = {
        'Authorization': 'Token $token',
        'Content-Type': 'multipart/form-data',
      };

      request.headers.addAll(headers);

      if (projectAddController.projectthumbnail.value!.path != '') {
        var multipartFile = await http.MultipartFile.fromPath(
            'thumbnail', projectAddController.projectthumbnail.value!.path);
        request.files.add(multipartFile);
      }

      request.fields['project_name'] =
          projectAddController.projectnamecontroller.text;
      request.fields['introduction'] =
          projectAddController.introcontroller.text;
      request.fields['start_date'] = DateFormat('yyyy-MM-dd').format(
          DateTime.parse(projectAddController.selectedStartDateTime.value));
      request.fields['end_date'] = (projectAddController.isEndedProject.value ==
              true)
          ? DateFormat('yyyy-MM-dd').format(
              DateTime.parse(projectAddController.selectedEndDateTime.value))
          : '';
      request.fields['looper'] = json.encode(projectAddController
          .selectedpersontaglist
          .map((person) => person.id)
          .toList());
      request.fields['tag'] = json.encode(
          tagController.selectedtaglist.map((tag) => tag.text).toList());

      http.StreamedResponse response = await request.send();

      print("활동 생성: ${response.statusCode}");
      if (response.statusCode == 201) {
        //!GA
        await _gaController.logProjectCreated(true);
        getbacks(6);

        String responsebody = await response.stream.bytesToString();
        Map<String, dynamic> responsemap = json.decode(responsebody);
        Project project = Project.fromJson(responsemap);
        project.is_user = 1;

        Get.put(ProjectDetailController(project.id),
            tag: project.id.toString());

        ProfileController.to.myProjectList.insert(0, project);

        Get.to(() => ProjectScreen(
              projectid: project.id,
              isuser: 1,
            ));

        if (_localDataController.isAddFirstProject == false) {
          // Get.snackbar("활동", "활동이 성공적으로 만들어졌어요!");
          ModalController.to.showCustomDialog('활동이 성공적으로 만들어졌어요!', 1000);
        }
        if (_localDataController.isAddFirstProject == true) {
          ModalController.to.showCustomDialog('첫번째 활동 만들었을 때 리뷰 팝업', 1000);
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          }
        }
        _localDataController.firstProjectAdd();
      } else {
        //!GA
        await _gaController.logProjectCreated(false);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<Project?> getproject(int projectId) async {
  ConnectivityResult result = await initConnectivity();
  ProjectDetailController controller =
      Get.find<ProjectDetailController>(tag: projectId.toString());
  if (result == ConnectivityResult.none) {
    controller.projectscreenstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/project_api/project?id=$projectId");
    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print("활동 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        Project project = Project.fromJson(responseBody);
        controller.project(project);
        controller.projectscreenstate(ScreenState.success);

        return project;
      } else if (response.statusCode == 404) {
        Get.back();
        ModalController.to.showCustomDialog('이미 삭제된 활동입니다', 1400);
        return Future.error(response.statusCode);
      } else {
        controller.projectscreenstate(ScreenState.error);

        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

enum ProjectUpdateType {
  project_name,
  date,
  tag,
  introduction,
  thumbnail,
  looper
}

Future updateproject(int projectId, ProjectUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  ProjectDetailController controller =
      Get.find<ProjectDetailController>(tag: projectId.toString());
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    ProjectAddController projectAddController = Get.find();
    TagController tagController = Get.find(tag: Tagtype.project.toString());

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
      } else if (updateType == ProjectUpdateType.introduction) {
        request.fields['introduction'] =
            projectAddController.introcontroller.text;
      } else if (updateType == ProjectUpdateType.date) {
        request.fields['start_date'] = DateFormat('yyyy-MM-dd').format(
            DateTime.parse(projectAddController.selectedStartDateTime.value));
        request.fields['end_date'] = projectAddController.isEndedProject.value
            ? DateFormat('yyyy-MM-dd').format(
                DateTime.parse(projectAddController.selectedEndDateTime.value))
            : '';
      } else if (updateType == ProjectUpdateType.tag) {
        request.fields['tag'] = json.encode(
            tagController.selectedtaglist.map((tag) => tag.text).toList());
      } else if (updateType == ProjectUpdateType.looper) {
        request.fields['looper'] = json.encode(projectAddController
            .selectedpersontaglist
            .map((person) => person.id)
            .toList());
      } else if (updateType == ProjectUpdateType.thumbnail) {
        if (projectAddController.projectthumbnail.value!.path != '') {
          var multipartFile = await http.MultipartFile.fromPath(
              'thumbnail', projectAddController.projectthumbnail.value!.path);
          request.files.add(multipartFile);
        } else {
          request.fields['thumbnail'] = 'image';
        }
      }

      http.StreamedResponse response = await request.send();
      print("활동 수정: ${response.statusCode}");
      if (response.statusCode == 200) {
        Project? project = await getproject(controller.project.value.id);
        if (project != null) {
          if (Get.isRegistered<ProfileController>()) {
            int projectindex = ProfileController.to.myProjectList
                .indexWhere((inproject) => inproject.id == project.id);
            ProfileController.to.myProjectList.removeAt(projectindex);
            ProfileController.to.myProjectList.insert(projectindex, project);
          }
        }

        Get.back();
        ModalController.to.showCustomDialog('변경이 완료되었어요', 1000);
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
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<void> deleteproject(int projectId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await const FlutterSecureStorage().read(key: "id");

    final uri = Uri.parse("$serverUri/project_api/project?id=$projectId");

    try {
      http.Response response =
          await http.delete(uri, headers: {"Authorization": "Token $token"});

      print(response.statusCode);
      if (response.statusCode == 200) {
        ProfileController.to.myProjectList
            .removeWhere((project) => project.id == projectId);
        try {
          Get.find<OtherProfileController>(tag: userid)
              .otherProjectList
              .removeWhere((project) => project.project.value.id == projectId);
        } catch (e) {
          print("활동 삭제 : $e");
        }
        Get.back();
        Get.delete<ProjectDetailController>(tag: projectId.toString());
      } else {
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}
