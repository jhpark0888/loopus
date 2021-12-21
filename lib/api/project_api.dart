import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/tag_controller.dart';

void projectaddRequest() async {
  ProjectAddController projectMakeController = Get.find();
  TagController tagController = Get.find();

  String? token = await FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse('http://3.35.253.151:8000/project_api/create_project/');

  var project = {
    "project_name": projectMakeController.projectnamecontroller.text,
    "introduction": projectMakeController.introcontroller.text,
    "start_date":
        '${projectMakeController.startyearcontroller.text}-${projectMakeController.startmonthcontroller.text}-${projectMakeController.startdaycontroller.text}',
    "end_date": projectMakeController.isongoing.value
        ? null
        : '${projectMakeController.endyearcontroller.text}-${projectMakeController.endmonthcontroller.text}-${projectMakeController.enddaycontroller.text}',
    'tag': tagController.selectedtaglist.map((element) => element.text).toList()
  };

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
      "Authorization": "Token $token"
    },
    body: jsonEncode(project),
  );
  var responseBody = json.decode(utf8.decode(response.bodyBytes));
  print(responseBody);
  // storage.write(key: 'token', value: json.decode(response.body)['token']);
  // print(storage.read(key: 'token'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(response.statusCode);
  }
}
