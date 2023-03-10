import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/company_model.dart';

import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/search_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController with GetTickerProviderStateMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();
  RxString _searchword = "".obs;
  ScrollController searchScrollController = ScrollController();
  late ScrollController scrollcontroller;
  RefreshController refreshController = RefreshController();
  late ScrollController? scrollController;

  RxList<RecentSearch> recentSearchList = <RecentSearch>[].obs;
  RxList<Person> searchUserList = <Person>[].obs;
  RxList<Post> searchPostList = <Post>[].obs;
  RxList<Tag> searchTagList = <Tag>[].obs;
  RxList<Company> searchCompanyList = <Company>[].obs;

  List<int> pagenumList = List.generate(4, (index) => 1);
  List<RefreshController> refreshControllerList =
      List.generate(4, (index) => RefreshController()..loadNoData());
  List<String> preWordList = List.generate(4, (index) => "");
  List<RxBool> isSearchEmptyList = List.generate(4, (index) => false.obs);
  List<RxBool> isSearchLoadingList = List.generate(4, (index) => false.obs);

  RxBool isFocused = false.obs;
  late TabController tabController;

  final FocusNode focusNode = FocusNode();

  void onSearchLoading() async {
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

    // for (var i in refreshControllerList) {
    //   i.loadNoData();
    // }
    getRecentSearchList();

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
          if (tabController.index == 0 &&
              _searchword.value != preWordList[tabController.index]) {
            searchFunction();
          } else if (tabController.index == 1 &&
              _searchword.value != preWordList[tabController.index]) {
            searchFunction();
          } else if (tabController.index == 2 &&
              _searchword.value != preWordList[tabController.index]) {
            searchFunction();
          } else if (tabController.index == 3 &&
              _searchword.value != preWordList[tabController.index]) {
            searchFunction();
          }
        }
      }
    });

    super.onInit();
  }

  void getRecentSearchList() async {
    await getResentSearches().then((value) {
      if (value.isError == false) {
        List<RecentSearch> tempList = List.from(value.data)
            .map((recSearch) => RecentSearch.fromJson(recSearch))
            .toList();

        recentSearchList(tempList);
      }
    });
  }

  void searchFunction() async {
    if (pagenumList[tabController.index] == 1) {
      isSearchLoadingList[tabController.index](true);
    }

    if (tabController.index == 0 || tabController.index == 1) {
      await search(SearchType.values[tabController.index], _searchword.value,
              pagenumList[tabController.index])
          .then((value) {
        if (value.isError == false) {
          List teptList = List.from(value.data);

          if (teptList.isEmpty && tabController.index != 0) {
            isSearchEmptyList[tabController.index](true);
          }

          if (tabController.index == 0) {
            List<Person> userList =
                teptList.map((user) => Person.fromJson(user)).toList();

            searchUserList.addAll(userList);
          } else if (tabController.index == 1) {
            List<Post> postList =
                teptList.map((post) => Post.fromJson(post)).toList();

            searchPostList.addAll(postList);
          }

          pagenumList[tabController.index] += 1;
          preWordList[tabController.index] = _searchword.value;
          refreshControllerList[tabController.index].loadComplete();
        } else {
          if (value.errorData!['statusCode'] == 204) {
            if (tabController.index == 0 &&
                pagenumList[tabController.index] == 1) {
              isSearchEmptyList[tabController.index](true);
            } else {
              refreshControllerList[tabController.index].loadNoData();
            }
          } else {
            refreshControllerList[tabController.index].loadComplete();
          }
        }
      });
    } else if (tabController.index == 2) {
      await tagsearch(_searchword.value).then((value) {
        if (value.isError == false) {
          List<Tag> tagList = List.from(value.data['results'])
              .map((tag) => Tag.fromJson(tag))
              .toList();

          if (tagList.isEmpty) {
            isSearchEmptyList[tabController.index](true);
          }

          searchTagList.addAll(tagList);

          pagenumList[tabController.index] += 1;
          preWordList[tabController.index] = _searchword.value;
        } else {}
        refreshControllerList[tabController.index].loadNoData();
      });
    } else if (tabController.index == 3) {
      await companySearch(_searchword.value, pagenumList[tabController.index])
          .then((value) {
        if (value.isError == false) {
          List teptList = List.from(value.data);

          if (teptList.isEmpty) {
            isSearchEmptyList[tabController.index](true);
          }

          List<Company> companyList =
              teptList.map((company) => Company.fromJson(company)).toList();

          searchCompanyList.addAll(companyList);

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
    }
    isSearchLoadingList[tabController.index](false);
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
    searchTagList.clear();
    searchCompanyList.clear();
  }
}
