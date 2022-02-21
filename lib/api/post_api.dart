import 'dart:convert';
import 'dart:async';
import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:loopus/api/project_api.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/post_content_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/smarttextfield.dart';

import '../constant.dart';
import '../controller/modal_controller.dart';

Future<void> addposting(int projectId, PostaddRoute route) async {
  final PostingAddController postingAddController = Get.find();
  final EditorController editorController = Get.find();
  final GAController _gaController = Get.put(GAController());

  final String? token = await const FlutterSecureStorage().read(key: 'token');

  Uri postingUploadUri = Uri.parse('$serverUri/post_api/posting?id=$projectId');

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
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H1) {
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.H2) {
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    }
    // else if (type == SmartTextType.QUOTE) {
    //   map['type'] = type.name;
    //   map['content'] = editorController.textcontrollers[i].text;
    //   postcontent.add(map);
    // }
    else if (type == SmartTextType.BULLET) {
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    } else if (type == SmartTextType.IMAGE) {
      map['type'] = type.name;
      map['content'] = 'image';
      var multipartFile = await http.MultipartFile.fromPath(
          'image', editorController.imageindex[i]!.path);
      request.files.add(multipartFile);
      postcontent.add(map);
    } else if (type == SmartTextType.LINK) {
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      map['url'] = editorController.linkindex[i];
      postcontent.add(map);
    } else if (type == SmartTextType.IMAGEINFO) {
      map['type'] = type.name;
      map['content'] = editorController.textcontrollers[i].text;
      postcontent.add(map);
    }
  }
  request.fields['title'] = postingAddController.titlecontroller.text;
  request.fields['contents'] = json.encode(postcontent);

  http.StreamedResponse response = await request.send();

  print("포스팅 업로드 statuscode:  ${response.statusCode}");
  if (response.statusCode == 200) {
    //!GA
    await _gaController.logPostingCreated(true);
    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 완료");
    }
    // String responsebody = await response.stream.bytesToString();
    // String responsemap = json.decode(responsebody);
    // print(responsemap);
    if (route == PostaddRoute.project) {
      getbacks(3);
      Get.find<ProjectDetailController>(tag: projectId.toString())
          .loadProject();
      Get.to(
        () => ProjectScreen(
          projectid: projectId,
          isuser: 1,
        ),
      );
      ModalController.to.showCustomDialog('포스팅을 업로드했어요', 1000);
    } else {
      String responsebody = await response.stream.bytesToString();
      Map<String, dynamic> responsemap = json.decode(responsebody);
      Post post = Post.fromJson(responsemap);
      post.isuser = 1;
      post.isLiked = 0.obs;
      post.isMarked = 0.obs;
      AppController.to.changePageIndex(0);
      HomeController.to.recommandpostingResult.value.postingitems
          .insert(0, post);
      getbacks(5);
      ModalController.to.showCustomDialog('포스팅을 업로드했어요', 1000);
    }
  } else if (response.statusCode == 400) {
    //!GA
    await _gaController.logPostingCreated(false);

    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 실패");
    }
  } else {
    //!GA
    await _gaController.logPostingCreated(false);

    if (kDebugMode) {
      print("status code : ${response.statusCode} 포스팅 업로드 실패");
    }
    return Future.error(response.statusCode);
  }
}

Future<Map> getposting(int postingid) async {
  ConnectivityResult result = await initConnectivity();
  PostingDetailController controller =
      Get.find<PostingDetailController>(tag: postingid.toString());

  if (result == ConnectivityResult.none) {
    controller.postscreenstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog();
    return {};
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    // print(userid);
    final specificPostingLoadUri =
        Uri.parse("$serverUri/post_api/posting?id=$postingid");

    http.Response response = await http.get(specificPostingLoadUri,
        headers: {"Authorization": "Token $token"});

    if (response.statusCode == 200) {
      Map responseBody = json.decode(utf8.decode(response.bodyBytes));
      controller.post(Post.fromJson(responseBody['posting_info']));
      controller.postcontentlist(controller.post.value.contents!
          .map((content) => PostContentWidget(content: content))
          .toList());
      controller.recommendposts = List.from(responseBody['recommend_post'])
          .map((post) => Post.fromJson(post))
          .toList()
          .map((posting) => SearchPostingWidget(post: posting))
          .toList();

      // Post post = Post.fromJson(responseBody['posting_info']);
      controller.postscreenstate(ScreenState.success);
      return responseBody;
    } else if (response.statusCode == 404) {
      Get.back();
      ModalController.to.showCustomDialog('이미 삭제된 포스팅입니다', 1400);
      return Future.error(response.statusCode);
    } else {
      controller.postscreenstate(ScreenState.error);
      return Future.error(response.statusCode);
    }
  }
}

enum PostingUpdateType {
  title,
  contents,
  thumbnail,
}

Future updateposting(int postid, PostingUpdateType updateType) async {
  final PostingAddController postingAddController = Get.find();

  String? token = await const FlutterSecureStorage().read(key: "token");
  Uri uri = Uri.parse(
      '$serverUri/post_api/posting?id=$postid&type=${updateType.name}');

  var request = http.MultipartRequest('PUT', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  if (updateType == PostingUpdateType.title) {
    request.fields['title'] = postingAddController.titlecontroller.text;
  } else if (updateType == PostingUpdateType.contents) {
    List<Map> postcontent = [];

    for (int i = 0;
        i < postingAddController.editorController.types.length;
        i++) {
      SmartTextType type = postingAddController.editorController.types[i];
      Map map = {};
      print(type);
      print(postingAddController.editorController.textcontrollers[i].text);
      print(postingAddController.editorController.linkindex[i]);
      if (type == SmartTextType.T) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        postcontent.add(map);
      } else if (type == SmartTextType.H1) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        postcontent.add(map);
      } else if (type == SmartTextType.H2) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        postcontent.add(map);
      }
      // else if (type == SmartTextType.QUOTE) {
      //   map['type'] = type.name;
      //   map['content'] =
      //       postingAddController.editorController.textcontrollers[i].text;
      //   postcontent.add(map);
      // }
      else if (type == SmartTextType.BULLET) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        postcontent.add(map);
      } else if (type == SmartTextType.IMAGE) {
        if (postingAddController.editorController.imageindex[i] != null) {
          map['type'] = type.name;
          map['content'] = 'image';
          var multipartFile = await http.MultipartFile.fromPath('image',
              postingAddController.editorController.imageindex[i]!.path);
          request.files.add(multipartFile);
        } else {
          map['type'] = type.name;
          map['content'] =
              postingAddController.editorController.urlimageindex[i];
        }
        postcontent.add(map);
      } else if (type == SmartTextType.LINK) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        map['url'] = postingAddController.editorController.linkindex[i];
        postcontent.add(map);
      } else if (type == SmartTextType.IMAGEINFO) {
        map['type'] = type.name;
        map['content'] =
            postingAddController.editorController.textcontrollers[i].text;
        postcontent.add(map);
      }
    }
    request.fields['contents'] = json.encode(postcontent);
  } else if (updateType == PostingUpdateType.thumbnail) {
    if (postingAddController.thumbnail.value.path != '') {
      var multipartFile = await http.MultipartFile.fromPath(
          'thumbnail', postingAddController.thumbnail.value.path);
      request.files.add(multipartFile);
    }
  }

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(response.statusCode);
    // String responsebody = await response.stream.bytesToString();
    // print(responsebody);
    // var responsemap = json.decode(responsebody);
    // print(responsemap);
    // Project project = Project.fromJson(responsemap);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> deleteposting(int postid, int projectid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/post_api/posting?id=$postid");

  http.Response response =
      await http.delete(uri, headers: {"Authorization": "Token $token"});

  print(response.statusCode);
  if (response.statusCode == 200) {
    Get.back();
    try {
      Get.find<ProjectDetailController>(tag: projectid.toString())
          .project
          .value
          .post
          .removeWhere((post) => post.id == postid);
      Get.find<ProjectDetailController>(tag: projectid.toString())
          .postinglist
          .removeWhere((post) => post.item.id == postid);
    } catch (e) {
      print(e);
    }

    HomeController.to.recommandpostingResult.value.postingitems
        .removeWhere((post) => post.id == postid);
    HomeController.to.latestpostingResult.value.postingitems
        .removeWhere((post) => post.id == postid);
  } else {
    return Future.error(response.statusCode);
  }
}

Future<dynamic> latestpost(int lastindex) async {
  String? token;
  // print('메인페이지 번호 : $pageNumber');
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final latestloadUri =
      Uri.parse("$serverUri/post_api/main_load?last=$lastindex");

  final response =
      await get(latestloadUri, headers: {"Authorization": "Token $token"});
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

Future<dynamic> recommandpost(int lastindex) async {
  String? token;
  // print('메인페이지 번호 : $pageNumber');
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final recommandloadUri =
      Uri.parse("$serverUri/post_api/recommend_load?last=$lastindex");

  final response =
      await get(recommandloadUri, headers: {"Authorization": "Token $token"});

  // if (kDebugMode) {
  //   print('posting list : $list');
  // }
  if (response.statusCode != 200) {
    return Future.error(response.statusCode);
  } else {
    var responseBody = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(responseBody);
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

Future<List<User>> getlikepeoele(int postid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("$serverUri/post_api/like_list_load/$postid");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  print('like 리스트 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    List responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<User> likepeople =
        responseBody.map((user) => User.fromJson(user)).toList();

    return likepeople;
  } else {
    return Future.error(response.statusCode);
  }
}

Future postingreport(int postingId) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final Uri uri = Uri.parse("$serverUri/post_api/report");

  var body = {"id": postingId, "reason": ""};

  final response = await post(uri,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Token $token"
      },
      body: json.encode(body));

  print('포스팅 신고 statusCode: ${response.statusCode}');
  if (response.statusCode == 200) {
    getbacks(2);
    ModalController.to.showCustomDialog("신고가 접수되었습니다", 1000);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
