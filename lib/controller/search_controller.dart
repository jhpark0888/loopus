import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';
import 'package:loopus/widget/search_tag_project_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

class SearchController extends GetxController
    with SingleGetTickerProviderMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();
  RxList<SearchPostingWidget> searchpostinglist = <SearchPostingWidget>[].obs;
  RxList<SearchProfileWidget> searchprofilelist = <SearchProfileWidget>[].obs;
  RxList<SearchTagProjectWidget> searchtagprojectlist =
      <SearchTagProjectWidget>[].obs;
  RxList<SearchQuestionWidget> searchquestionlist =
      <SearchQuestionWidget>[].obs;
  RxList<SearchQuestionWidget> searchtagquestionlist =
      <SearchQuestionWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;
  RxBool isnosearch1 = false.obs;
  RxBool isnosearch2 = false.obs;
  RxBool isnosearch3 = false.obs;
  RxBool istag = false.obs;
  int pagenumber1 = 1;
  int pagenumber2 = 1;
  int pagenumber3 = 1;
  int pagenumber4 = 1;
  int pagenumber5 = 1;

  RxBool isFocused = false.obs;
  RxInt tabpage = 0.obs;
  late TabController tabController;
  late TabController tagtabController;

  final FocusNode focusNode = FocusNode();

  void onInit() {
    _focusListen();
    tabController = TabController(
      length: 5,
      initialIndex: 0,
      vsync: this,
    );
    tagtabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    searchtextcontroller.addListener(() {
      tagsearch();
    });

    tabController.addListener(() {
      if (searchtextcontroller.text.isEmpty == false) {
        if (tabController.indexIsChanging == true) {
          if (tabController.index != 3) {
            print(searchpostinglist);
            print(searchprofilelist);
            print(searchquestionlist);
            if (tabController.index == 0 && searchpostinglist.isEmpty) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber1);
            } else if (tabController.index == 1 && searchprofilelist.isEmpty) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber2);
            } else if (tabController.index == 2 && searchquestionlist.isEmpty) {
              search(
                  tabController.index, searchtextcontroller.text, pagenumber3);
            } else if (tabController.index == 2 && searchquestionlist.isEmpty) {
              tagsearch();
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
        isnosearch1.value = false;
        isnosearch2.value = false;
        isnosearch3.value = false;
      }
    });
  }

  void tagsearch() async {
    // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/login/');
    Uri uri = Uri.parse(
        'http://3.35.253.151:8000/tag_api/search?query=${searchtextcontroller.text}');

    http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);
    var responsebody = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
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
        // if (searchtextcontroller.text != '') {
        //   searchtaglist.insert(
        //       0,
        //       SearchTagWidget(
        //         id: -1,
        //         tag: "'${searchtextcontroller.text}'태그의 검색결과가 없습니다.",
        //         isSearch: 1,
        //       ));
        // }
      }
    } else if (response.statusCode == 401) {
    } else {
      print(response.statusCode);
    }
  }

  Future<void> search(int tab_index, var search, int pagenumber) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });
    // 수정
    List tab_list = [
      "post",
      "profile",
      "question",
      "tag_project",
      "tag_question"
    ];

    final url = Uri.parse(
        "http://3.35.253.151:8000/search_api/search/${tab_list[tab_index]}/?query=${search}&page=${pagenumber}");

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
      if (tab_index == 0 && searchlist.isNotEmpty) {
        if (searchlist[0]["id"] == searchpostinglist.value[0].id) {
          return;
        }
      }
      if (tab_index == 1 && searchlist.isNotEmpty) {
        if (searchlist[0]["user"] == searchprofilelist.value[0].id) {
          return;
        }
      }
      if (tab_index == 2 && searchlist.isNotEmpty) {
        if (searchlist[0]["id"] == searchquestionlist.value[0].id) {
          return;
        }
      }
    }

    if (searchlist.isEmpty) {
      if (tab_index == 0) {
        isnosearch1.value = true;
      } else if (tab_index == 1) {
        isnosearch2.value = true;
      } else if (tab_index == 2) {
        isnosearch3.value = true;
      } else if (tab_index == 3) {
        return;
      } else if (tab_index == 4) {
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

      if (tab_index == 0) {
        searchlist.forEach((element) {
          searchpostinglist.add(SearchPostingWidget(
            department: element["department"],
            name: element["real_name"],
            id: element["id"],
            postingtitle: element["title"],
            profileimage: element["thubnail"],
            projecttitle: element["project_name"],
            is_liked: RxInt(element["is_liked"]),
            is_marked: RxInt(element["is_marked"]),
            like_count: RxInt(element["like_count"]),
            user_id: element["user_id"],
          ));
        });
      } else if (tab_index == 1) {
        searchlist.forEach((element) {
          searchprofilelist.add(SearchProfileWidget(
              id: element["user_id"],
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
            istag: 0,
          ));
        });
      } else if (tab_index == 3) {
        searchlist.forEach((element) {
          searchtagprojectlist.add(SearchTagProjectWidget(
            department: element["department"],
            id: element["id"],
            like_count: element["project_post"]["like_count"],
            name: element["real_name"],
            post_count: element["project_post"]["post_count"],
            profileimage: element["profile_image"],
            projecttitle: element["project_name"],
            user_id: element["user_id"],
            end_date: element["end_date"],
            start_date: DateTime.parse(element["start_date"]),
          ));
        });
      } else if (tab_index == 4) {
        searchlist.forEach((element) {
          searchtagquestionlist.add(
            SearchQuestionWidget(
              answercount: element["count"],
              content: element["content"],
              id: element["id"],
              user: element["user_id"],
              real_name: element["real_name"],
              department: element["department"],
              tag: element["question_tag"],
              profileimage: element["profile_image"],
              istag: 1,
            ),
          );
        });
      }
    }
  }
}
