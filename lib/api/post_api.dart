import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/posting_update_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';

import '../constant.dart';
import '../controller/modal_controller.dart';

Future<HTTPResponse> addposting(int projectId, double aspectRatio) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    final PostingAddController postingAddController = Get.find();
    TagController tagController = Get.find(tag: Tagtype.Posting.toString());
    final GAController _gaController = Get.put(GAController());

    final String? token = await const FlutterSecureStorage().read(key: 'token');

    Uri postingUploadUri =
        Uri.parse('$serverUri/post_api/posting?id=$projectId');

    var request = http.MultipartRequest('POST', postingUploadUri);

    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'multipart/form-data',
    };

    request.headers.addAll(headers);
    for (int i = 0; i < postingAddController.images.length; i++) {
      var multipartFile = await http.MultipartFile.fromPath(
          'image', postingAddController.images[i].path,
          filename:
              "${DateTime.now().toIso8601String()}_${projectId}_${i}_aspectRatio=${aspectRatio.toStringAsFixed(3)}.jpg");
      request.files.add(multipartFile);
      print(multipartFile.filename);
      print(request.files);
    }
    request.fields['contents'] =
        postingAddController.textcontroller.text.trim();
    for (var tag in tagController.selectedtaglist) {
      var multipartFile = await http.MultipartFile.fromString('tag', tag.text);
      request.files.add(multipartFile);
    }
    for (var link in postingAddController.scrapList) {
      var multipartFile = await http.MultipartFile.fromString('link', link.url);
      request.files.add(multipartFile);
    }
    // print("emoji: ${request.fields['contents']}");
    // return HTTPResponse.networkError();

    try {
      http.StreamedResponse response = await request.send();

      print("포스팅 업로드 statuscode:  ${response.statusCode}");
      if (response.statusCode == 200) {
        //!GA
        await _gaController.logPostingCreated(true);
        if (kDebugMode) {
          print("status code : ${response.statusCode} 포스팅 업로드 완료");
        }

        String responsebody = await response.stream.bytesToString();
        var responseResult = json.decode(responsebody);
        print(responseResult);

        return HTTPResponse.success(responseResult);
      } else if (response.statusCode == 400) {
        //!GA
        await _gaController.logPostingCreated(false);

        if (kDebugMode) {
          print("status code : ${response.statusCode} 포스팅 업로드 실패");
        }
        return HTTPResponse.apiError('False', response.statusCode);
      } else {
        //!GA
        await _gaController.logPostingCreated(false);

        if (kDebugMode) {
          print("status code : ${response.statusCode} 포스팅 업로드 실패");
        }
        return HTTPResponse.apiError('False', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getposting(int postingid) async {
  ConnectivityResult result = await initConnectivity();
  PostingDetailController controller =
      Get.find<PostingDetailController>(tag: postingid.toString());

  if (result == ConnectivityResult.none) {
    controller.postscreenstate(ScreenState.disconnect);
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");
    String? userid = await FlutterSecureStorage().read(key: "id");

    // print(userid);
    final specificPostingLoadUri =
        Uri.parse("$serverUri/post_api/posting?id=$postingid");

    try {
      http.Response response = await http.get(specificPostingLoadUri,
          headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 포스팅입니다', 1400);
        return HTTPResponse.apiError('이미 삭제된 포스팅입니다', response.statusCode);
      } else {
        controller.postscreenstate(ScreenState.error);
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      controller.postscreenstate(ScreenState.error);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

enum PostingUpdateType {
  title,
  contents,
  thumbnail,
}

Future<HTTPResponse> updateposting(
    int postid, PostingUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  PostingDetailController controller =
      Get.find<PostingDetailController>(tag: postid.toString());

  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    TagController tagController = Get.find(tag: Tagtype.Posting.toString());

    String? token = await const FlutterSecureStorage().read(key: "token");
    Uri uri = Uri.parse('$serverUri/post_api/posting?id=$postid');

    var request = http.MultipartRequest('PUT', uri);

    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'multipart/form-data',
    };

    request.headers.addAll(headers);

    request.fields['contents'] = PostingUpdateController.to.textcontroller.text;

    for (var tag in tagController.selectedtaglist) {
      var multipartFile = await http.MultipartFile.fromString('tag', tag.text);
      request.files.add(multipartFile);
    }

    try {
      http.StreamedResponse response = await request.send();

      print("포스팅 수정: ${response.statusCode}");
      if (response.statusCode == 200) {
        String responsebody = await response.stream.bytesToString();
        print(responsebody);
        // var responsemap = json.decode(responsebody);
        // print(responsemap);
        // Project project = Project.fromJson(responsemap);
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> deleteposting(int postid, int projectid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/post_api/posting?id=$postid");

    try {
      http.Response response =
          await http.delete(uri, headers: {"Authorization": "Token $token"});

      print('포스팅 삭제: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> mainload(int lastindex) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token;
    // print('메인페이지 번호 : $pageNumber');
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final mainloadUri =
        Uri.parse("$serverUri/post_api/main_load?last=$lastindex");

    try {
      final response = await http
          .get(mainloadUri, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        // Future.error(response.statusCode);
        var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        // print(responseBody);
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
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

Future<HTTPResponse> bookmarklist(int pageNumber) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final bookmarkListUri =
        Uri.parse("$serverUri/post_api/bookmark_list?page=$pageNumber");

    try {
      final response = await http
          .get(bookmarkListUri, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> bookmarkpost(int postId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final bookmarkUri = Uri.parse("$serverUri/post_api/bookmark?id=$postId");
    try {
      final response = await http
          .post(bookmarkUri, headers: {"Authorization": "Token $token"});
      print('북마크 : ${response.statusCode}');
      if (response.statusCode == 202) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

enum contentType { post, comment, cocomment }

Future<HTTPResponse> likepost(int id, contentType type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    String? userType = await const FlutterSecureStorage().read(key: "type");
    int isStudent = UserType.student.name == userType ? 1 : 0;
    print(userType);

    final likeUri = Uri.parse(
        "$serverUri/post_api/like?id=$id&type=${type.name}&is_student=$isStudent");
    try {
      final response =
          await http.post(likeUri, headers: {"Authorization": "Token $token"});
      print('좋아요 ${type.name} : ${response.statusCode}');
      if (response.statusCode == 202) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getlikepeoele(int postid, contentType type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse(
        "$serverUri/post_api/like_list_load?id=$postid&type=${type.name}");
    //"$serverUri/post_api/like_list_load/$postid"

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print('like 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> contentreport(int id, contentType type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/post_api/report?type=${type.name}");

    var body = {"id": id, "reason": ""};

    try {
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('포스팅 신고 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success("success");
      } else {
        return HTTPResponse.apiError("fail", response.statusCode);
      }
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

//type : comment, cocomment
Future<HTTPResponse> commentPost(
    int id, contentType type, String text, int? tagUserId) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? userType = await const FlutterSecureStorage().read(key: "type");
  int isStudent = UserType.student.name == userType ? 1 : 0;

  final CommentUri = Uri.parse(
      "$serverUri/post_api/comment?id=$id&type=${type.name}&is_student=$isStudent");

  final content = {"content": text.trim(), "tagged_user": tagUserId};

  try {
    final response = await http.post(
      CommentUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
      body: json.encode(content),
    );
    // var responseBody = utf8.decode(response.bodyBytes);
    print('댓글 작성 : ${response.statusCode}');
    if (response.statusCode == 201) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      return HTTPResponse.success(responseBody);
    } else {
      return HTTPResponse.apiError('', response.statusCode);
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

//type : comment, cocomment
Future<HTTPResponse> commentDelete(int id, contentType type) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  final CommentUri =
      Uri.parse("$serverUri/post_api/comment?id=$id&type=${type.name}");

  try {
    final response = await http.delete(
      CommentUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );
    // var responseBody = utf8.decode(response.bodyBytes);
    print('댓글 삭제 : ${response.statusCode}');
    if (response.statusCode == 200) {
      return HTTPResponse.success("success");
    } else {
      return HTTPResponse.apiError('', response.statusCode);
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

//type : comment, cocomment
Future<HTTPResponse> commentListGet(int id, contentType type, int last) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  final CommentUri = Uri.parse(
      "$serverUri/post_api/comment?id=$id&type=${type.name}&last=$last");

  try {
    final response = await http.get(
      CommentUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );
    // var responseBody = utf8.decode(response.bodyBytes);
    print('댓글 로드 : ${response.statusCode}');
    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      return HTTPResponse.success(responseBody);
    } else {
      return HTTPResponse.apiError('', response.statusCode);
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
