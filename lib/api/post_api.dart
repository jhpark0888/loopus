import 'dart:convert';
import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:loopus/api/project_api.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/smarttextfield.dart';

import '../constant.dart';

Future<void> addposting(int projectId) async {
  final PostingAddController postingAddController = Get.find();
  final EditorController editorController = Get.find();

  final String? token = await const FlutterSecureStorage().read(key: 'token');

  Uri postingUploadUri =
      Uri.parse('$serverUri/post_api/posting_upload/$projectId');

  var request = http.MultipartRequest('POST', postingUploadUri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (postingAddController.thumbnail.value.path != '') {
    var multipartFile = await http.MultipartFile.fromPath(
        'thumbnail', postingAddController.thumbnail.value.path);
    request.files.add(multipartFile);
  }

  List<Map> postcontent = [];

  for (int i = 0; i < editorController.types.length; i++) {
    SmartTextType type = editorController.types[i];
    Map map = {};
    if (type == SmartTextType.T) {
      map['type'] = 0;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H1) {
      map['type'] = 1;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H2) {
      map['type'] = 2;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.QUOTE) {
      map['type'] = 3;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.BULLET) {
      map['type'] = 4;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.IMAGE) {
      map['type'] = 5;
      map['content'] = 'image';
      var multipartFile = await http.MultipartFile.fromPath(
          'image', editorController.imageindex[i]!.path);
      request.files.add(multipartFile);
      postcontent.add(map);
    } else if (type == SmartTextType.LINK) {
      map['type'] = 6;
      map['content'] = editorController.textcontrollers[i].text;
      map['url'] = editorController.linkindex[i];
      postcontent.add(map);
    }
  }
  request.fields['title'] = postingAddController.titlecontroller.text;
  request.fields['contents'] = json.encode(postcontent);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 완료");
    }
    // String responsebody = await response.stream.bytesToString();
    // String responsemap = json.decode(responsebody);
    // print(responsemap = ok);

    // await getproject(projectId).then((value) {
    //   ProjectDetailController.to.project(value);
    //   ProjectDetailController.to
    //       .postinglist(List.from(ProjectDetailController.to.project.value.post
    //           .map((post) => ProjectPostingWidget(
    //                 item: post,
    //                 realName:
    //                     ProjectDetailController.to.project.value.realname ?? '',
    //                 department:
    //                     ProjectDetailController.to.project.value.department ??
    //                         '',
    //                 profileImage:
    //                     ProjectDetailController.to.project.value.profileimage ??
    //                         '',
    //               ))
    //           .toList()
    //           .reversed));
    // });
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(
        () => ProjectScreen(
              projectid: projectId,
              isuser: 1,
            ),
        arguments: {"projectid": projectId, "isuser": 1});
  } else if (response.statusCode == 400) {
    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 실패");
    }
  } else {
    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 실패");
    }
    return Future.error(response.statusCode);
  }
}

Future<Post> getposting(int postingid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");
  String? userid = await FlutterSecureStorage().read(key: "id");

  // print(userid);
  final specificPostingLoadUri =
      Uri.parse("$serverUri/post_api/specific_posting_load/$postingid");

  http.Response response = await http
      .get(specificPostingLoadUri, headers: {"Authorization": "Token $token"});

  var responseBody = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    Post post = Post.fromJson(responseBody['posting_info']);

    return post;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> deleteposting(int postid, int projectid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/post_api/delete/$postid");

  http.Response response =
      await http.post(uri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  if (response.statusCode == 200) {
    Get.back();
    Get.find<ProjectDetailController>(tag: projectid.toString())
        .project
        .value
        .post
        .removeWhere((post) => post.id == postid);
    Get.find<ProjectDetailController>(tag: projectid.toString())
        .postinglist
        .removeWhere((post) => post.item.id == postid);
    HomeController.to.postingResult.value.postingitems
        .removeWhere((post) => post.id == postid);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<dynamic> mainpost(int lastindex) async {
  String? token;
  // print('메인페이지 번호 : $pageNumber');
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final mainloadUri =
      Uri.parse("$serverUri/post_api/main_load?last=$lastindex");

  final response =
      await get(mainloadUri, headers: {"Authorization": "Token $token"});
  var responseBody = utf8.decode(response.bodyBytes);
  List<dynamic> list = jsonDecode(responseBody);

  if (kDebugMode) {
    print('posting list : $list');
  }
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> bookmarklist(int pageNumber) async {
  // print('북마크페이지 번호 : $pageNumber');
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkListUri =
      Uri.parse("$serverUri/post_api/bookmark_list?page=$pageNumber");

  final response =
      await get(bookmarkListUri, headers: {"Authorization": "Token $token"});
  var responseBody = utf8.decode(response.bodyBytes);
  List<dynamic> list = jsonDecode(responseBody);

  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> looppost(int lastindex) async {
  // print('루프페이지 번호 : $pageNumber');
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final loopUri = Uri.parse("$serverUri/post_api/loop_load?last=$lastindex");

  final response =
      await get(loopUri, headers: {"Authorization": "Token $token"});
  var responseBody = utf8.decode(response.bodyBytes);
  List<dynamic> list = jsonDecode(responseBody);
  if (list.isEmpty) {
    HomeController.to.enableLoopPullup.value = false;
  }
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    return PostingModel.fromJson(list);
  }
}

Future<dynamic> bookmarkpost(int postingId) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkUri = Uri.parse("$serverUri/post_api/bookmark/$postingId");

  final response =
      await post(bookmarkUri, headers: {"Authorization": "Token $token"});

  var responseBody = utf8.decode(response.bodyBytes);
  String result = jsonDecode(responseBody);
}

Future<dynamic> likepost(int postingId) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final likeUri = Uri.parse("$serverUri/post_api/like/$postingId");

  final response =
      await post(likeUri, headers: {"Authorization": "Token $token"});
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = utf8.decode(response.bodyBytes);
  String result = jsonDecode(responseBody);
}
