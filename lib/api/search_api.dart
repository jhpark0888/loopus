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
        searchController.presearchwordtag = searchword;
        var responsebody = json.decode(utf8.decode(response.bodyBytes));
        List responselist = responsebody["results"];
        List<SearchTag> tagmaplist =
            responselist.map((map) => SearchTag.fromJson(map)).toList();

        print(responselist);
        searchController.searchtaglist.clear();

        if (tagmaplist.isEmpty) {
          searchController.isnosearchtag(true);
        } else {
          searchController.searchtaglist(tagmaplist.map((element) {
            return SearchTagWidget(
              id: element.id,
              tag: element.tag,
              count: element.count,
              isSearch: 1,
            );
          }).toList());

          searchController.isnosearchtag(false);
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

Future<void> search(
    SearchType searchType, String searchtext, int pagenumber) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    if (searchType == SearchType.tag_project) {
      Get.find<TagDetailController>(tag: searchtext)
          .tagprojectscreenstate(ScreenState.disconnect);
    } else if (searchType == SearchType.tag_question) {
      Get.find<TagDetailController>(tag: searchtext)
          .tagquestionscreenstate(ScreenState.disconnect);
    }
    showdisconnectdialog();
  } else {
    SearchController searchController = Get.find();
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    // 수정

    String searchword = searchtext.trim().replaceAll(RegExp("\\s+"), " ");
    print("검색어: $searchword");

    final url = Uri.parse(
        "http://3.35.253.151:8000/search_api/search/${searchType.name}?query=${searchword}&page=${pagenumber}");

    try {
      final response =
          await http.get(url, headers: {"Authorization": "Token $token"});
      var statusCode = response.statusCode;
      var responseHeaders = response.headers;
      var responseBody = utf8.decode(response.bodyBytes);
      print("검색 : $statusCode");

      if (response.statusCode == 200) {
        List searchlist = jsonDecode(responseBody);
        print("pagenumber$pagenumber");
        print(searchlist);
        if (pagenumber >= 2) {
          print(searchlist);
          // print(searchController.searchquestionlist.value);
          print(searchController.searchprofilelist.value);
          if (searchType == SearchType.post && searchlist.isNotEmpty) {
            if (searchlist[0]["id"] ==
                searchController.searchpostinglist.value[0].post.id) {
              return;
            }
          }
          if (searchType == SearchType.profile && searchlist.isNotEmpty) {
            if (searchlist[0]["user"] ==
                searchController.searchprofilelist.value[0].user.userid) {
              return;
            }
          }
          if (searchType == SearchType.question && searchlist.isNotEmpty) {
            // if (searchlist[0]["id"] ==
            //     searchController.searchquestionlist.value[0].item.id) {
            //   return;
            // }
          }
        }

        if (searchlist.isEmpty) {
          if (searchType == SearchType.post) {
            searchController.presearchwordpost = searchword;

            searchController.isnosearchpost(true);
            searchController.searchpostinglist.clear();
          } else if (searchType == SearchType.profile) {
            searchController.presearchwordprofile = searchword;

            searchController.isnosearchprofile(true);
            searchController.searchprofilelist.clear();
          } else if (searchType == SearchType.question) {
            searchController.presearchwordquestion = searchword;

            searchController.isnosearchquestion(true);
            // searchController.searchquestionlist.clear();
          } else if (searchType == SearchType.tag_project) {
            Get.find<TagDetailController>(tag: searchtext)
                .tagprojectscreenstate(ScreenState.success);
            return;
          } else if (searchType == SearchType.tag_question) {
            Get.find<TagDetailController>(tag: searchtext)
                .tagquestionscreenstate(ScreenState.success);
            return;
          }
        } else {
          // if (tab_index == 0) {
          //   SearchController.to.pagenumber1 += 1;
          // } else if (tab_index == 1) {
          //   SearchController.to.pagenumber2 += 1;
          // } else if (tab_index == 2) {
          //   SearchController.to.pagenumber3 += 1;
          // }

          if (searchType == SearchType.post) {
            searchController.presearchwordpost = searchword;
            searchController.searchpostinglist(searchlist
                .map((json) => Post.fromJson(json))
                .toList()
                .map((post) => SearchPostingWidget(post: post))
                .toList());
            searchController.isnosearchpost(false);
          } else if (searchType == SearchType.profile) {
            searchController.presearchwordprofile = searchword;
            searchController.searchprofilelist(searchlist
                .map((json) => User.fromJson(json))
                .toList()
                .map((user) => SearchProfileWidget(
                      user: user,
                    ))
                .toList());
            searchController.isnosearchprofile(false);
          } else if (searchType == SearchType.question) {
            searchController.presearchwordquestion = searchword;
            // searchController.searchquestionlist(searchlist
            //     .map((json) => QuestionItem.fromJson(json))
            //     .toList()
            //     .map((question) => SearchQuestionWidget(
            //           item: question,
            //         ))
            //     .toList());
            searchController.isnosearchquestion(false);
          } else if (searchType == SearchType.tag_project) {
            Get.find<TagDetailController>(tag: searchtext)
                .searchtagprojectlist(searchlist
                    .map((json) => Project.fromJson(json))
                    .toList()
                    .map((project) => SearchTagProjectWidget(
                          project: project,
                        ))
                    .toList());
            Get.find<TagDetailController>(tag: searchtext)
                .tagprojectscreenstate(ScreenState.success);
          } else if (searchType == SearchType.tag_question) {
            // Get.find<TagDetailController>(tag: searchtext)
            //     .searchtagquestionlist(searchlist
            //         .map((json) => QuestionItem.fromJson(json))
            //         .toList()
            //         .map((question) => QuestionWidget(
            //               item: question,
            //             ))
            //         .toList());
            Get.find<TagDetailController>(tag: searchtext)
                .tagquestionscreenstate(ScreenState.success);
          }
        }
      } else {
        if (searchType == SearchType.tag_project) {
          Get.find<TagDetailController>(tag: searchtext)
              .tagprojectscreenstate(ScreenState.error);
        } else if (searchType == SearchType.tag_question) {
          Get.find<TagDetailController>(tag: searchtext)
              .tagquestionscreenstate(ScreenState.error);
        }
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
