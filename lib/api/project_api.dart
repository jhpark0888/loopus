import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';

Future addproject() async {
  ProjectAddController projectAddController = Get.find();
  TagController tagController = Get.find();

  String? token = await const FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse('http://3.35.253.151:8000/project_api/create_project');

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
  request.fields['introduction'] = projectAddController.introcontroller.text;
  request.fields['start_date'] =
      '${projectAddController.startyearcontroller.text}-${projectAddController.startmonthcontroller.text}-${projectAddController.startdaycontroller.text}';
  request.fields['end_date'] = projectAddController.isongoing.value
      ? ""
      : '${projectAddController.endyearcontroller.text}-${projectAddController.endmonthcontroller.text}-${projectAddController.enddaycontroller.text}';
  request.fields['looper'] = json.encode(projectAddController
      .selectedpersontaglist
      .map((person) => person.id)
      .toList());
  request.fields['tag'] = json
      .encode(tagController.selectedtaglist.map((tag) => tag.text).toList());

  http.StreamedResponse response = await request.send();

  String responsebody = await response.stream.bytesToString();

  if (response.statusCode == 201) {
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    AppController.to.changePageIndex(4);
  }
}

Future<Project> getproject(int projectId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri =
      Uri.parse("http://3.35.253.151:8000/project_api/load_project/$projectId");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    Project project = Project.fromJson(responseBody);
    return project;
  } else {
    return Future.error(response.statusCode);
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
  ProjectAddController projectAddController = Get.find();
  TagController tagController = Get.find();

  String? token = await const FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse(
      'http://3.35.253.151:8000/project_api/update_project/${updateType.name}/$projectId');

  var request = http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (updateType == ProjectUpdateType.project_name) {
    request.fields['project_name'] =
        projectAddController.projectnamecontroller.text;
  } else if (updateType == ProjectUpdateType.introduction) {
    request.fields['introduction'] = projectAddController.introcontroller.text;
  } else if (updateType == ProjectUpdateType.date) {
    request.fields['start_date'] =
        '${projectAddController.startyearcontroller.text}-${projectAddController.startmonthcontroller.text}-${projectAddController.startdaycontroller.text}';
    request.fields['end_date'] = projectAddController.isongoing.value
        ? ""
        : '${projectAddController.endyearcontroller.text}-${projectAddController.endmonthcontroller.text}-${projectAddController.enddaycontroller.text}';
  } else if (updateType == ProjectUpdateType.tag) {
    request.fields['tag'] = json
        .encode(tagController.selectedtaglist.map((tag) => tag.text).toList());
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

  String responsebody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    var responsemap = json.decode(responsebody);
    print(responsemap);
    Project project = Project.fromJson(responsemap);
    return project;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> deleteproject(int projectId) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse(
      "http://3.35.253.151:8000/project_api/delete_project/$projectId");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  if (response.statusCode == 200) {
    Get.back();
    Get.back();
    Get.back();
    ProfileController.to.myProjectList
        .removeWhere((project) => project.project.value.id == projectId);
  } else {
    return Future.error(response.statusCode);
  }
}
