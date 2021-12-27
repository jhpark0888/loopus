import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/tag_controller.dart';

void projectaddRequest() async {
  ProjectAddController projectAddController = Get.find();
  TagController tagController = Get.find();

  String? token = await const FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse('http://3.35.253.151:8000/project_api/create_project/');

  var project = {
    "project_name": projectAddController.projectnamecontroller.text,
    "introduction": projectAddController.introcontroller.text,
    "start_date":
        '${projectAddController.startyearcontroller.text}-${projectAddController.startmonthcontroller.text}-${projectAddController.startdaycontroller.text}',
    "end_date": projectAddController.isongoing.value
        ? null
        : '${projectAddController.endyearcontroller.text}-${projectAddController.endmonthcontroller.text}-${projectAddController.enddaycontroller.text}',
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
