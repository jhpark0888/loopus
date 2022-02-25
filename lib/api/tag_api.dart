import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import '../constant.dart';

void gettagsearch(Tagtype tagtype) async {
  ConnectivityResult result = await initConnectivity();
  TagController tagController = Get.find(tag: tagtype.toString());
  tagController.tagsearchstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    tagController.tagsearchstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog();
  } else {
    String tagsearchword = tagController.tagsearch.text.replaceAll(" ", "");

    Uri uri = Uri.parse('$serverUri/tag_api/tag?query=${tagsearchword}');
    print(uri);
    try {
      http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var responsebody = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        List responselist = responsebody["results"];
        List<SearchTag> tagmaplist =
            responselist.map((map) => SearchTag.fromJson(map)).toList();

        if (tagmaplist
            .where((element) => element.tag == tagsearchword)
            .isNotEmpty) {
          tagController.searchtaglist.clear();

          tagController.searchtaglist(tagmaplist.map((element) {
            return SearchTagWidget(
              id: element.id,
              tag: element.tag,
              count: element.count,
              isSearch: 0,
              tagtype: tagtype,
            );
          }).toList());

          for (var selectedtag in tagController.selectedtaglist) {
            tagController.searchtaglist
                .removeWhere((element) => element.tag == selectedtag.text);
          }
        } else {
          tagController.searchtaglist.clear();

          tagController.searchtaglist(tagmaplist.map((element) {
            return SearchTagWidget(
              id: element.id,
              tag: element.tag,
              count: element.count,
              isSearch: 0,
              tagtype: tagtype,
            );
          }).toList());
          if (tagsearchword != '' &&
              tagController.selectedtaglist
                  .where((tag) => tag.text == tagsearchword)
                  .isEmpty) {
            tagController.searchtaglist.insert(
                0,
                SearchTagWidget(
                  id: 0,
                  tag: "처음으로 '${tagsearchword}' 태그 사용하기",
                  isSearch: 0,
                  tagtype: tagtype,
                ));
          }

          tagController.selectedtaglist.forEach((selectedtag) {
            tagController.searchtaglist
                .removeWhere((element) => element.tag == selectedtag.text);
          });
        }
        tagController.tagsearchstate(ScreenState.success);
      } else if (response.statusCode == 401) {
        tagController.tagsearchstate(ScreenState.error);
      } else {
        tagController.tagsearchstate(ScreenState.error);
        print('tag status code :${response.statusCode}');
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

void getpopulartag() async {
  ConnectivityResult result = await initConnectivity();
  HomeController controller = Get.find();
  controller.populartagstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    controller.populartagstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog();
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
        List<SearchTag> tagmaplist =
            responselist.map((map) => SearchTag.fromJson(map)).toList();

        controller.populartaglist(tagmaplist
            .map((tag) => Tag(tagId: tag.id, tag: tag.tag, count: tag.count!))
            .toList());

        controller.populartagstate(ScreenState.success);
      } else if (response.statusCode == 401) {
        controller.populartagstate(ScreenState.error);
      } else {
        controller.populartagstate(ScreenState.error);
        print('tag status code :${response.statusCode}');
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
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
