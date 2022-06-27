import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';
import 'package:loopus/widget/search_tag_project_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

import '../controller/error_controller.dart';

Future<void> tagsearch() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
  } else {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    SearchController searchController = Get.find();
    String searchword = searchController.searchtextcontroller.text
        .trim()
        .replaceAll(RegExp("\\s+"), " ");

    Uri uri = Uri.parse(
        'http://3.35.253.151:8000/tag_api/search_tag?query=${searchword}');
    try {
      http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      );

      print("태그 검색: ${response.statusCode}");

      if (response.statusCode == 200) {
        searchController.preWordList[searchController.tabController.index] =
            searchword;
        var responsebody = json.decode(utf8.decode(response.bodyBytes));
        List responselist = responsebody["results"];
        List<SearchTag> tagmaplist =
            responselist.map((map) => SearchTag.fromJson(map)).toList();

        print(responselist);
        searchController.searchtaglist.clear();

        if (tagmaplist.isEmpty) {
          // searchController.isnosearchtag(true);
        } else {
          // searchController.searchtaglist(tagmaplist.map((element) {
          //   return SearchTagWidget(
          //     id: element.id,
          //     tag: element.tag,
          //     count: element.count,
          //     isSearch: 1,
          //   );
          // }).toList());

          // searchController.isnosearchtag(false);
        }
      } else if (response.statusCode == 401) {
        return Future.error(response.statusCode);
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

Future<HTTPResponse> search(
    SearchType searchType, String searchtext, int pagenumber) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    SearchController searchController = Get.find();
    String? token = await FlutterSecureStorage().read(key: 'token');
    // 수정

    String searchword = searchtext.trim().replaceAll(RegExp("\\s+"), " ");
    print("검색어: $searchword");

    final url = Uri.parse(
        "$serverUri/search_api/search/${searchType.name}?query=$searchword&page=$pagenumber");

    try {
      final response =
          await http.get(url, headers: {"Authorization": "Token $token"});

      print("검색 : ${response.statusCode}");

      if (response.statusCode == 200) {
        List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
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
    }
  }
}
