import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/tag_controller.dart';

Future addproject() async {
  ProjectAddController projectAddController = Get.find();
  TagController tagController = Get.find();

  String? token = await const FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse('http://3.35.253.151:8000/project_api/create_project/');

  var request = new http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  if (projectAddController.projectimage.value!.path != '') {
    var multipartFile = await http.MultipartFile.fromPath(
        'thumbnail', projectAddController.projectimage.value!.path);
    request.files.add(multipartFile);
  }

  request.headers.addAll(headers);

  request.fields['project_name'] =
      projectAddController.projectnamecontroller.text;
  request.fields['introduction'] = projectAddController.introcontroller.text;
  request.fields['start_date'] =
      '${projectAddController.startyearcontroller.text}-${projectAddController.startmonthcontroller.text}-${projectAddController.startdaycontroller.text}';
  request.fields['end_date'] = projectAddController.isongoing.value
      ? ""
      : '${projectAddController.endyearcontroller.text}-${projectAddController.endmonthcontroller.text}-${projectAddController.enddaycontroller.text}';
  request.fields['tag'] = json.encode(
      tagController.selectedtaglist.map((element) => element.text).toList());

  http.StreamedResponse response = await request.send();

  String responsebody = await response.stream.bytesToString();
  // print(responseBody);
  // storage.write(key: 'token', value: json.decode(response.body)['token']);
  // print(storage.read(key: 'token'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(response.statusCode);
  }
}

Future<http.Response> getproject(int project_id) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  // String? userid = await FlutterSecureStorage().read(key: "id");

  print(token);
  // print(userid);
  final uri = Uri.parse(
      "http://3.35.253.151:8000/project_api/load_project/$project_id");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  // var responseBody = json.decode(utf8.decode(response.bodyBytes));
  // print(responseBody);

  // print(response.statusCode);
  if (response.statusCode == 200) {
    return response;
  } else {
    return Future.error(response.statusCode);
  }
}
