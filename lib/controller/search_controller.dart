import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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

enum SearchType { post, profile, question, tag_project, tag_question }

class SearchController extends GetxController with GetTickerProviderStateMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();

  RxList<SearchPostingWidget> searchpostinglist = <SearchPostingWidget>[].obs;
  RxList<SearchProfileWidget> searchprofilelist = <SearchProfileWidget>[].obs;
  RxList<SearchQuestionWidget> searchquestionlist =
      <SearchQuestionWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;

  RxList<SearchTagProjectWidget> searchtagprojectlist =
      <SearchTagProjectWidget>[].obs;
  RxList<QuestionWidget> searchtagquestionlist = <QuestionWidget>[].obs;

  RxBool isnosearchpost = false.obs;
  RxBool isnosearchprofile = false.obs;
  RxBool isnosearchquestion = false.obs;
  RxBool isnosearchtag = false.obs;

  RxBool istag = false.obs;
  int postpagenumber = 1;
  int profilepagenumber = 1;
  int questionpagenumber = 1;
  int tagpagenumber = 1;
  int pagenumber = 1;

  RxBool isFocused = false.obs;
  RxInt tabpage = 0.obs;
  late TabController tabController;
  late TabController tagtabController;

  RxBool isSearchLoading = false.obs;

  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    _focusListen();
    tabController = TabController(
      length: 4,
      initialIndex: 0,
      vsync: this,
    );
    tagtabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );

    tabController.addListener(() {
      if (searchtextcontroller.text.isEmpty == false) {
        if (tabController.indexIsChanging == true) {
          isSearchLoading(true);
          print(searchpostinglist);
          print(searchprofilelist);
          print(searchquestionlist);
          if (tabController.index == 0 && searchpostinglist.isEmpty) {
            search(SearchType.post, searchtextcontroller.text, postpagenumber);
          } else if (tabController.index == 1 && searchprofilelist.isEmpty) {
            search(SearchType.profile, searchtextcontroller.text,
                profilepagenumber);
          } else if (tabController.index == 2 && searchquestionlist.isEmpty) {
            search(SearchType.question, searchtextcontroller.text,
                questionpagenumber);
          } else if (tabController.index == 3 && searchtaglist.isEmpty) {
            tagsearch();
          }
          isSearchLoading(false);
        }
      }
      if (tabController.index == 3) {
        istag.value = true;
      } else {
        istag.value = false;
      }
    });

    super.onInit();
  }

  void focusChange() {
    isFocused.value = false;
  }

  void _focusListen() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isFocused.value = true;
        isnosearchpost(false);
        isnosearchprofile(false);
        isnosearchquestion(false);
        isnosearchtag(false);
      }
    });
  }

  void clearSearchedList() {
    searchpostinglist.clear();
    searchprofilelist.clear();
    searchquestionlist.clear();
    searchtaglist.clear();
  }

  Future<void> tagsearch() async {
    Uri uri = Uri.parse(
        'http://3.35.253.151:8000/tag_api/tag?query=${searchtextcontroller.text}');

    http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      var responsebody = json.decode(utf8.decode(response.bodyBytes));
      List responselist = responsebody["results"];
      List<SearchTag> tagmaplist =
          responselist.map((map) => SearchTag.fromJson(map)).toList();

      print(responselist);
      if (tagmaplist
          .where((element) => element.tag == searchtextcontroller.text)
          .isNotEmpty) {
        searchtaglist.clear();

        searchtaglist(tagmaplist.map((element) {
          return SearchTagWidget(
            id: element.id,
            tag: element.tag,
            count: element.count,
            isSearch: 1,
          );
        }).toList());
      } else {
        searchtaglist.clear();

        searchtaglist(tagmaplist.map((element) {
          return SearchTagWidget(
            id: element.id,
            tag: element.tag,
            count: element.count,
            isSearch: 1,
          );
        }).toList());
      }
      if (tagmaplist.isEmpty) {
        isnosearchtag(true);
      } else {
        isnosearchtag(false);
      }
    } else if (response.statusCode == 401) {
    } else {
      print(response.statusCode);
    }
  }

  Future<void> search(SearchType searchType, var search, int pagenumber) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    // 수정

    final url = Uri.parse(
        "http://3.35.253.151:8000/search_api/search/${searchType.name}?query=${search}&page=${pagenumber}");

    final response = await get(url, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    print(statusCode);
    List searchlist = jsonDecode(responseBody);
    print("pagenumber$pagenumber");
    print(searchlist);
    if (pagenumber >= 2) {
      print(searchlist);
      print(searchquestionlist.value);
      print(searchprofilelist.value);
      if (searchType == SearchType.post && searchlist.isNotEmpty) {
        if (searchlist[0]["id"] == searchpostinglist.value[0].post.id) {
          return;
        }
      }
      if (searchType == SearchType.profile && searchlist.isNotEmpty) {
        if (searchlist[0]["user"] == searchprofilelist.value[0].user.userid) {
          return;
        }
      }
      if (searchType == SearchType.question && searchlist.isNotEmpty) {
        if (searchlist[0]["id"] == searchquestionlist.value[0].item.id) {
          return;
        }
      }
    }

    if (searchlist.isEmpty) {
      if (searchType == SearchType.post) {
        isnosearchpost(true);
      } else if (searchType == SearchType.profile) {
        isnosearchprofile(true);
      } else if (searchType == SearchType.question) {
        isnosearchquestion(true);
      } else if (searchType == SearchType.tag_project) {
        return;
      } else if (searchType == SearchType.tag_question) {
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
        searchpostinglist(searchlist
            .map((json) => Post.fromJson(json))
            .toList()
            .map((post) => SearchPostingWidget(post: post))
            .toList());
      } else if (searchType == SearchType.profile) {
        searchprofilelist(searchlist
            .map((json) => User.fromJson(json))
            .toList()
            .map((user) => SearchProfileWidget(
                  user: user,
                ))
            .toList());
      } else if (searchType == SearchType.question) {
        searchquestionlist(searchlist
            .map((json) => QuestionItem.fromJson(json))
            .toList()
            .map((question) => SearchQuestionWidget(
                  item: question,
                ))
            .toList());
      } else if (searchType == SearchType.tag_project) {
        searchtagprojectlist(searchlist
            .map((json) => Project.fromJson(json))
            .toList()
            .map((project) => SearchTagProjectWidget(
                  project: project,
                ))
            .toList());
      } else if (searchType == SearchType.tag_question) {
        searchtagquestionlist(searchlist
            .map((json) => QuestionItem.fromJson(json))
            .toList()
            .map((question) => QuestionWidget(
                  item: question,
                ))
            .toList());
      }
    }
  }
}
