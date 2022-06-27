import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/enterprise_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController with GetTickerProviderStateMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();
  RxString _searchword = "".obs;

  RxList<User> recommandUsers = <User>[].obs;
  RxList<Post> recommandPosts = <Post>[].obs;

  RxList<User> searchUserList = <User>[
    // User.defaultuser(department: "산업경영공학과", realName: "홍길동"),
    // User.defaultuser(department: "전자공학과", realName: "아무개"),
    // User.defaultuser(department: "컴퓨터공학과", realName: "김루프"),
    // User.defaultuser(department: "안전공학과", realName: "박어스"),
    // User.defaultuser(department: "산업경영공학과", realName: "홍길동"),
    // User.defaultuser(department: "전자공학과", realName: "아무개"),
    // User.defaultuser(department: "컴퓨터공학과", realName: "김루프"),
    // User.defaultuser(department: "안전공학과", realName: "박어스"),
  ].obs;
  RxList<Post> searchPostList = <Post>[].obs;
  RxList<Tag> searchtaglist = <Tag>[
    Tag(tagId: 1, tag: '인공지능', count: 23),
    Tag(tagId: 1, tag: '인공지능 스터디', count: 23),
    Tag(tagId: 1, tag: '물류시스템 스터디', count: 23),
    Tag(tagId: 1, tag: '산업디자인', count: 23)
  ].obs;

  List<int> pagenumList = List.generate(4, (index) => 1);
  List<RefreshController> refreshControllerList =
      List.generate(4, (index) => RefreshController());
  List<String> preWordList = List.generate(4, (index) => "");
  List<RxBool> isSearchEmptyList = List.generate(4, (index) => false.obs);
  List<RxBool> isSearchLoadingList = List.generate(4, (index) => false.obs);

  RxBool isFocused = false.obs;
  RxInt tabpage = 0.obs;
  late TabController tabController;

  final FocusNode focusNode = FocusNode();

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    searchFunction();
  }

  @override
  void onInit() {
    // _focusListen();
    tabController = TabController(
      length: 4,
      initialIndex: 0,
      vsync: this,
    );

    for (var i in refreshControllerList) {
      i.loadNoData();
    }

    debounce(_searchword, (_) async {
      searchInit();
      if (_searchword.value != "") {
        searchFunction();
      }
    }, time: const Duration(milliseconds: 300));

    searchtextcontroller.addListener(() {
      if (_searchword.value !=
          searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ")) {
        _searchword(
            searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " "));
      }
    });

    tabController.addListener(() {
      if (searchtextcontroller.text.isEmpty == false) {
        if (tabController.indexIsChanging == true) {
          String searchword =
              searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ");

          if (tabController.index == 0 &&
              searchword != preWordList[tabController.index]) {
            searchFunction();
          } else if (tabController.index == 1 &&
              searchword != preWordList[tabController.index]) {
            searchFunction();
          } else if (tabController.index == 2 &&
              searchword != preWordList[tabController.index]) {
            tagsearch();
          } else if (tabController.index == 3 &&
              searchword != preWordList[tabController.index]) {}
        }
      }
    });

    super.onInit();
  }

  void searchFunction() async {
    if (tabController.index != 3) {
      if (pagenumList[tabController.index] == 1) {
        isSearchLoadingList[tabController.index](true);
      }

      if (tabController.index != 2) {
        await search(SearchType.values[tabController.index], _searchword.value,
                pagenumList[tabController.index])
            .then((value) {
          if (value.isError == false) {
            List teptList = List.from(value.data);

            if (teptList.isEmpty) {
              isSearchEmptyList[tabController.index](true);
            }

            if (tabController.index == 0) {
              List<User> userList =
                  teptList.map((user) => User.fromJson(user)).toList();

              searchUserList.addAll(userList);
            } else if (tabController.index == 1) {
              List<Post> postList =
                  teptList.map((post) => Post.fromJson(post)).toList();

              searchPostList.addAll(postList);
            } else if (tabController.index == 3) {}

            pagenumList[tabController.index] += 1;
            preWordList[tabController.index] = _searchword.value;
            refreshControllerList[tabController.index].loadComplete();
          } else {
            if (value.errorData!['statusCode'] == 204) {
              refreshControllerList[tabController.index].loadNoData();
            } else {
              refreshControllerList[tabController.index].loadComplete();
            }
          }
        });
      } else {
        // await tagsearch();
      }
      isSearchLoadingList[tabController.index](false);
    }
  }

  void searchInit() {
    pagenumList = List.generate(4, (index) => 1);
    preWordList = List.generate(4, (index) => "");
    // enablePullUpList = List.generate(4, (index) => false.obs);
    for (int i = 0; i < 4; i++) {
      isSearchEmptyList[i](false);
    }
    searchPostList.clear();
    searchUserList.clear();
    searchtaglist.clear();
  }
}
