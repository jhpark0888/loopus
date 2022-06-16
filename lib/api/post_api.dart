import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/likepeople_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/post_content_widget.dart';
import 'package:loopus/widget/search_posting_widget.dart';

import '../constant.dart';
import '../controller/error_controller.dart';
import '../controller/modal_controller.dart';

Future<HTTPResponse> addposting(int projectId) async {
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

    for (File image in postingAddController.images) {
      var multipartFile =
          await http.MultipartFile.fromPath('image', image.path);
      request.files.add(multipartFile);
      print(request.files);
    }

    request.fields['contents'] = postingAddController.textcontroller.text;
    request.fields['tag'] = json
        .encode(tagController.selectedtaglist.map((tag) => tag.text).toList());

    try {
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
        // if (route == PostaddRoute.project) {
        //   getbacks(3);
        //   Get.find<ProjectDetailController>(tag: projectId.toString())
        //       .loadProject();
        //   Get.to(
        //     () => ProjectScreen(
        //       projectid: projectId,
        //       isuser: 1,
        //     ),
        //   );
        //   .showCustomDialog('포스팅을 업로드했어요', 1000);
        // } else {
        //   String responsebody = await response.stream.bytesToString();
        //   Map<String, dynamic> responsemap = json.decode(responsebody);
        //   Post post = Post.fromJson(responsemap);
        //   post.isuser = 1;
        //   post.isLiked = 0.obs;
        //   post.isMarked = 0.obs;
        //   AppController.to.changePageIndex(0);
        //   HomeController.to.recommandpostingResult.value.postingitems
        //       .insert(0, post);
        //   getbacks(5);
        //   .showCustomDialog('포스팅을 업로드했어요', 1000);
        // }
        return HTTPResponse.success('success');
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
      ErrorController.to.isServerClosed(true);
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
        Map responseBody = json.decode(utf8.decode(response.bodyBytes));
        // controller.post(Post.fromJson(responseBody['posting_info']));
        // controller.postcontentlist(controller.post.value.contents!
        //     .map((content) => PostContentWidget(content: content))
        //     .toList());
        // controller.recommendposts = List.from(responseBody['recommend_post'])
        //     .map((post) => Post.fromJson(post))
        //     .toList()
        //     .map((posting) => SearchPostingWidget(post: posting))
        //     .toList();

        // Post post = Post.fromJson(responseBody['posting_info']);
        controller.postscreenstate(ScreenState.success);
        return HTTPResponse.success(
            Post.fromJson(responseBody['posting_info']));
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 포스팅입니다', 1400);
        return HTTPResponse.apiError('이미 삭제된 포스팅입니다', response.statusCode);
      } else {
        controller.postscreenstate(ScreenState.error);
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
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

Future updateposting(int postid, PostingUpdateType updateType) async {
  ConnectivityResult result = await initConnectivity();
  PostingDetailController controller =
      Get.find<PostingDetailController>(tag: postid.toString());

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
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

    // if (updateType == PostingUpdateType.title) {
    //   request.fields['title'] = postingAddController.titlecontroller.text;
    // } else if (updateType == PostingUpdateType.contents) {
    //   List<Map> postcontent = [];

    //   for (int i = 0;
    //       i < postingAddController.editorController.types.length;
    //       i++) {
    //     SmartTextType type = postingAddController.editorController.types[i];
    //     Map map = {};
    //     print(type);
    //     print(postingAddController.editorController.textcontrollers[i].text);
    //     print(postingAddController.editorController.linkindex[i]);
    //     if (type == SmartTextType.T) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       postcontent.add(map);
    //     } else if (type == SmartTextType.H1) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       postcontent.add(map);
    //     } else if (type == SmartTextType.H2) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       postcontent.add(map);
    //     }
    //     // else if (type == SmartTextType.QUOTE) {
    //     //   map['type'] = type.name;
    //     //   map['content'] =
    //     //       postingAddController.editorController.textcontrollers[i].text;
    //     //   postcontent.add(map);
    //     // }
    //     else if (type == SmartTextType.BULLET) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       postcontent.add(map);
    //     } else if (type == SmartTextType.IMAGE) {
    //       if (postingAddController.editorController.imageindex[i] != null) {
    //         map['type'] = type.name;
    //         map['content'] = 'image';
    //         var multipartFile = await http.MultipartFile.fromPath('image',
    //             postingAddController.editorController.imageindex[i]!.path);
    //         request.files.add(multipartFile);
    //       } else {
    //         map['type'] = type.name;
    //         map['content'] =
    //             postingAddController.editorController.urlimageindex[i];
    //       }
    //       postcontent.add(map);
    //     } else if (type == SmartTextType.LINK) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       map['url'] = postingAddController.editorController.linkindex[i];
    //       postcontent.add(map);
    //     } else if (type == SmartTextType.IMAGEINFO) {
    //       map['type'] = type.name;
    //       map['content'] =
    //           postingAddController.editorController.textcontrollers[i].text;
    //       postcontent.add(map);
    //     }
    //   }
    //   request.fields['contents'] = json.encode(postcontent);
    // } else if (updateType == PostingUpdateType.thumbnail) {
    //   if (postingAddController.thumbnail.value.path != '') {
    //     var multipartFile = await http.MultipartFile.fromPath(
    //         'thumbnail', postingAddController.thumbnail.value.path);
    //     request.files.add(multipartFile);
    //   }
    // }

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(response.statusCode);
        HTTPResponse? result = await getposting(postid);
        if (result.isError == false) {
          if (Get.isRegistered<ProjectDetailController>(
              tag: result.data.project!.id.toString())) {
            ProjectDetailController projectDetailController =
                Get.find<ProjectDetailController>(
                    tag: result.data.project!.id.toString());
            int postindex = projectDetailController.project.value.posts
                .indexWhere((pjinpost) => pjinpost.id == result.data.id);
            projectDetailController.project.value.posts.removeAt(postindex);
            projectDetailController.project.value.posts
                .insert(postindex, result.data);
            // int widgetindex = projectDetailController.postinglist.indexWhere(
            //     (postwidget) => postwidget.item.value.id == post.id);
            // projectDetailController.postinglist.removeAt(widgetindex);
            // projectDetailController.postinglist.insert(
            //     widgetindex,
            //     ProjectPostingWidget(
            //         isuser: 1,
            //         item: post.obs,
            //         realname: post.user.realName,
            //         profileimage: post.user.profileImage,
            //         department: post.user.department));
          }
        }
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
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<void> deleteposting(int postid, int projectid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/post_api/posting?id=$postid");

    try {
      http.Response response =
          await http.delete(uri, headers: {"Authorization": "Token $token"});

      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.back();
        if (Get.isRegistered<ProjectDetailController>(
            tag: projectid.toString())) {
          Get.find<ProjectDetailController>(tag: projectid.toString())
              .project
              .value
              .posts
              .removeWhere((post) => post.id == postid);
          // Get.find<ProjectDetailController>(tag: projectid.toString())
          //     .postinglist
          //     .removeWhere((post) => post.item.value.id == postid);
        }

        HomeController.to.recommandpostingResult.value.postingitems
            .removeWhere((post) => post.id == postid);
        HomeController.to.latestpostingResult.value.postingitems
            .removeWhere((post) => post.id == postid);
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

Future<HTTPResponse> latestpost(int lastindex) async {
  String? token;
  // print('메인페이지 번호 : $pageNumber');
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final latestloadUri =
      Uri.parse("$serverUri/post_api/main_load?last=$lastindex");

  try {
    final response =
        await get(latestloadUri, headers: {"Authorization": "Token $token"});
    var responseBody = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(responseBody);

    if (kDebugMode) {
      print('posting list : $list');
    }
    if (response.statusCode != 200) {
      // Future.error(response.statusCode);
      return HTTPResponse.apiError('', response.statusCode);
    } else {
      return HTTPResponse.success(PostingModel.fromJson(list));
    }
  } on SocketException {
    ErrorController.to.isServerClosed(true);
    return HTTPResponse.serverError();
  } catch (e) {
    print(e);
    return HTTPResponse.unexpectedError(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<HTTPResponse> recommandpost(int pagenum) async {
  String? token;
  // print('메인페이지 번호 : $pageNumber');
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final recommandloadUri =
      Uri.parse("$serverUri/post_api/recommend_load?page=$pagenum");

  try {
    final response =
        await get(recommandloadUri, headers: {"Authorization": "Token $token"});

    // if (kDebugMode) {
    //   print('posting list : $list');
    // }
    print("추천 포스팅 리스트 :${response.statusCode}");
    if (response.statusCode != 200) {
      // Future.error(response.statusCode);
      return HTTPResponse.apiError('', response.statusCode);
    } else {
      var responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(responseBody);
      HomeController.to.recommandpagenum += 1;
      return HTTPResponse.success(PostingModel.fromJson(list));
    }
  } on SocketException {
    print("서버에러 발생");

    ErrorController.to.isServerClosed(true);
    return HTTPResponse.serverError();
  } catch (e) {
    print(e);
    return HTTPResponse.unexpectedError(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<HTTPResponse> bookmarklist(int pageNumber) async {
  // print('북마크페이지 번호 : $pageNumber');
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkListUri =
      Uri.parse("$serverUri/post_api/bookmark_list?page=$pageNumber");

  try {
    final response =
        await get(bookmarkListUri, headers: {"Authorization": "Token $token"});
    var responseBody = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(responseBody);

    if (response.statusCode != 200) {
      return HTTPResponse.apiError('', response.statusCode);
    } else {
      return HTTPResponse.success(PostingModel.fromJson(list));
    }
  } on SocketException {
    ErrorController.to.isServerClosed(true);
    return HTTPResponse.serverError();
  } catch (e) {
    print(e);
    return HTTPResponse.unexpectedError(e);
    // ErrorController.to.isServerClosed(true);
  }
}

// Future<HTTPResponse> looppost(int lastindex) async {
//   // print('루프페이지 번호 : $pageNumber');
//   String? token;
//   await const FlutterSecureStorage().read(key: 'token').then((value) {
//     token = value;
//   });

//   final loopUri = Uri.parse("$serverUri/post_api/loop_load?last=$lastindex");

//   try {
//     final response =
//         await get(loopUri, headers: {"Authorization": "Token $token"});
//     var responseBody = utf8.decode(response.bodyBytes);
//     List<dynamic> list = jsonDecode(responseBody);
//     if (list.isEmpty) {
//       HomeController.to.enableLoopPullup.value = false;
//     }
//     if (response.statusCode != 200) {
//       // Future.error(response.statusCode);
//       return HTTPResponse.apiError('', response.statusCode);
//     } else {
//       return HTTPResponse.success(PostingModel.fromJson(list));
//     }
//   } on SocketException {
//     ErrorController.to.isServerClosed(true);
//     return HTTPResponse.serverError();
//   } catch (e) {
//     print(e);
//     return HTTPResponse.unexpectedError(e);
//     // ErrorController.to.isServerClosed(true);
//   }
// }

Future<dynamic> bookmarkpost(int postingId) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final bookmarkUri = Uri.parse("$serverUri/post_api/bookmark/$postingId");
  try {
    final response =
        await post(bookmarkUri, headers: {"Authorization": "Token $token"});

    var responseBody = utf8.decode(response.bodyBytes);
    String result = jsonDecode(responseBody);
  } on SocketException {
    ErrorController.to.isServerClosed(true);
  } catch (e) {
    print(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<dynamic> likepost(int postingId) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });

  final likeUri = Uri.parse("$serverUri/post_api/like/$postingId");
  try {
    final response =
        await post(likeUri, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    String result = jsonDecode(responseBody);
  } on SocketException {
    ErrorController.to.isServerClosed(true);
  } catch (e) {
    print(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<void> getlikepeoele(int postid) async {
  ConnectivityResult result = await initConnectivity();
  LikePeopleController controller = Get.find(tag: postid.toString());
  if (result == ConnectivityResult.none) {
    controller.likepeoplescreenstate(ScreenState.disconnect);
    showdisconnectdialog();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/post_api/like_list_load/$postid");

    try {
      http.Response response =
          await http.get(uri, headers: {"Authorization": "Token $token"});

      print('like 리스트 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        List responseBody = json.decode(utf8.decode(response.bodyBytes));
        List<User> likepeople =
            responseBody.map((user) => User.fromJson(user)).toList();
        controller.likelist(likepeople);

        controller.likepeoplescreenstate(ScreenState.success);

        return;
      } else {
        controller.likepeoplescreenstate(ScreenState.error);

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

Future postingreport(int postingId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/post_api/report");

    var body = {"id": postingId, "reason": ""};

    try {
      final response = await post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('포스팅 신고 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        getbacks(2);
        showCustomDialog("신고가 접수되었습니다", 1000);
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
