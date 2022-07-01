import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

import '../constant.dart';

void getpopulartag() async {
  ConnectivityResult result = await initConnectivity();
  HomeController controller = Get.find();
  controller.populartagstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    controller.populartagstate(ScreenState.disconnect);
    showdisconnectdialog();
  } else {
    Uri uri = Uri.parse('$serverUri/tag_api/tag?query=');
    print(uri);

    try {
      http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      var responsebody = json.decode(utf8.decode(response.bodyBytes));

      print("인기 태그 리스트: ${response.statusCode}");
      if (response.statusCode == 200) {
        List responselist = responsebody["results"];
        List<Tag> tagmaplist =
            responselist.map((map) => Tag.fromJson(map)).toList();

        controller.populartaglist(tagmaplist
            .map((tag) => Tag(tagId: tag.tagId, tag: tag.tag, count: tag.count))
            .toList());
        controller.topTagList.value = controller.populartaglist.sublist(0,5);
        controller.populartagstate(ScreenState.success);
      } else if (response.statusCode == 401) {
        controller.populartagstate(ScreenState.error);
      } else {
        controller.populartagstate(ScreenState.error);
        print('tag status code :${response.statusCode}');
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<HTTPResponse> getTagPosting(int tagId, int page, String type) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    // print(userid);
    //type: new, pop
    final specificPostingLoadUri = Uri.parse(
        "$serverUri/tag_api/tagged_post?id=$tagId&page=$page&type=$type");

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

// Future<SearchTag?> postmaketag(Tagtype tagtype) async {
//   TagController tagController = Get.find(tag: tagtype.toString());

//   Uri uri = Uri.parse('$serverUri/tag_api/tag');

//   var tag = {"tag": tagsearchword};

//   http.Response response = await http.post(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(tag),
//   );

//   print('태그 생성: ${response.statusCode}');
//   if (response.statusCode == 201) {
//     tagController.tagsearch.clear();
//     Map responsebody = json.decode(utf8.decode(response.bodyBytes));
//     SearchTag searchtag = SearchTag.fromJson(responsebody["tag"]);
//     return searchtag;
//   } else if (response.statusCode == 401) {
//   } else {}
// }
