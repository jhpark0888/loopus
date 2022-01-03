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
  RxBool isnosearch1 = false.obs;
  RxBool isnosearch2 = false.obs;
  RxBool isnosearch3 = false.obs;
  RxBool istag = false.obs;
  int pagenumber1 = 1;
  int pagenumber2 = 1;
  int pagenumber3 = 1;

  RxBool isFocused = false.obs;
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
    tabController.addListener(() {
      if (searchtextcontroller.text.isEmpty == false) {
        if (tabController.indexIsChanging == true) {
          if (tabController.index != 3) {
            if (tabController.index == 0) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber1);
            } else if (tabController.index == 1) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber2);
            } else if (tabController.index == 2) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber3);
            }
          }
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
      }
    });
  }

  Future<void> search(int tab_index, String search, int pagenumber) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    // 수정
    List tab_list = ["post", "profile", "question", "project", "project"];

    final url = Uri.parse(
        "http://3.35.253.151:8000/search_api/search/${tab_list[tab_index]}/?query=${search}&page=${pagenumber}");

    final response = await get(url, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    print(statusCode);
    List searchlist = jsonDecode(responseBody);
    print("pagenumber$pagenumber");
    if (pagenumber >= 2) {
      print(searchlist);
      print(searchquestionlist.value);
      print(searchprofilelist.value);
      if (tab_index == 0 && searchlist.isEmpty == false) {
        if (searchlist[0]["id"] == searchpostinglist.value[0].id) {
          return;
        }
      }
      if (tab_index == 1 && searchlist.isEmpty == false) {
        if (searchlist[0]["user"] == searchprofilelist.value[0].id) {
          return;
        }
      }
      if (tab_index == 2 && searchlist.isEmpty == false) {
        if (searchlist[0]["id"] == searchquestionlist.value[0].id) {
          return;
        }
      }
    }

    print(searchlist);

    if (searchlist.isEmpty) {
      if (tab_index == 0) {
        isnosearch1.value = true;
      } else if (tab_index == 1) {
        isnosearch2.value = true;
      } else if (tab_index == 2) {
        isnosearch3.value = true;
      }
    } else {
      if (tab_index == 0) {
        SearchController.to.pagenumber1 += 1;
      } else if (tab_index == 1) {
        SearchController.to.pagenumber2 += 1;
      } else if (tab_index == 2) {
        SearchController.to.pagenumber3 += 1;
      }

      if (tab_index == 0) {
        searchlist.forEach((element) {
          searchpostinglist.add(SearchPostingWidget(
            department: element["department"],
            name: element["real_name"],
            id: element["id"],
            postingtitle: element["title"],
            profileimage: element["thubnail"],
            projecttitle: element["title"],
            is_liked: RxInt(element["is_liked"]),
            is_marked: RxInt(element["is_marked"]),
            like_count: RxInt(element["like_count"]),
            user_id: element["user_id"],
          ));
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
            answercount: element["count"],
            content: element["content"],
            id: element["id"],
            user: element["user_id"],
            real_name: element["real_name"],
            department: element["department"],
            tag: element["question_tag"],
            profileimage: element["profile_image"],
          ));
        });
      }
    }
  }
}
