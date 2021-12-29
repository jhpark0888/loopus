import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class ProjectController extends GetxController {
  static ProjectController get to => Get.find();

  late Project project;

  void onInit() async {
    super.onInit();
    // await getproject(project_id).then((response) {
    //   var responseBody = json.decode(utf8.decode(response.bodyBytes));
    //   project = Project.fromJson(responseBody);

    // List projectmaplist = responseBody['project'];
    // projectlist(projectmaplist
    //     .map((project) => Project.fromJson(project))
    //     .map((project) => ProjectWidget(
    //           project: project,
    //         ))
    //     .toList());
    // });
  }

  late int project_id;
}
