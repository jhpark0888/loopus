import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';

class SearchController extends GetxController
    with SingleGetTickerProviderMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();
  RxList<SearchPostingWidget> searchpostinglist = <SearchPostingWidget>[].obs;
  RxList<SearchProfileWidget> searchprofilelist = <SearchProfileWidget>[].obs;
  RxList<SearchQuestionWidget> searchquestionlist =
      <SearchQuestionWidget>[].obs;
  RxBool checknonesearch = false.obs;

  RxBool isFocused = true.obs;
  RxInt tabpage = 0.obs;
  late TabController tabController;

  final FocusNode focusNode = FocusNode();

  void onInit() {
    _focusListen();
    tabController = TabController(
      length: 5,
      initialIndex: 0,
      vsync: this,
    );
    super.onInit();
  }

  void _focusListen() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        isFocused.value = false;
      } else if (focusNode.hasFocus) {
        isFocused.value = true;
      }
    });
  }

  Future<void> search(int tab_index, String search) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    // 수정
    List tab_list = ["post", "profile", "question", "project", "project"];

    final url = Uri.parse(
        "http://3.35.253.151:8000/search_api/search_log/${tab_list[tab_index]}/?query=${search}");

    final response = await get(url, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    print(statusCode);
    List searchlist = jsonDecode(responseBody);
    print(searchlist);

    if (searchlist.isEmpty) {
      print("hihi");
      checknonesearch.value = true;
      print(checknonesearch.value);
    } else {
      if (tab_index == 0) {
        searchlist.forEach((element) {
          searchpostinglist.add(SearchPostingWidget(
              id: element["id"],
              postingtitle: element["title"],
              profileimage: element["thubnail"],
              projecttitle: element["title"],
              likecount: element["like_count"]));
        });
      } else if (tab_index == 1) {
        searchlist.forEach((element) {
          searchprofilelist.add(SearchProfileWidget(
              id: element["user"],
              department: element["department"],
              name: element["real_name"],
              profileimage: element["profile_image"]));
        });
      } else if (tab_index == 2) {
        searchlist.forEach((element) {
          searchquestionlist.add(SearchQuestionWidget(
            answercount: element["answer"].length,
            content: element["content"],
            id: element["id"],
            tag: element["question_tag"],
          ));
        });
      }
    }
  }
}
