import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

class SearchController extends GetxController with GetTickerProviderStateMixin {
  static SearchController get to => Get.find();
  TextEditingController searchtextcontroller = TextEditingController();
  RxString _searchword = "".obs;

  RxList<SearchPostingWidget> searchpostinglist = <SearchPostingWidget>[].obs;
  RxList<SearchProfileWidget> searchprofilelist = <SearchProfileWidget>[].obs;
  RxList<SearchQuestionWidget> searchquestionlist =
      <SearchQuestionWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;

  RxBool isnosearchpost = false.obs;
  RxBool isnosearchprofile = false.obs;
  RxBool isnosearchquestion = false.obs;
  RxBool isnosearchtag = false.obs;

  String presearchwordpost = "";
  String presearchwordprofile = "";
  String presearchwordquestion = "";
  String presearchwordtag = "";

  // RxBool istag = false.obs;
  int postpagenumber = 1;
  int profilepagenumber = 1;
  int questionpagenumber = 1;
  int tagpagenumber = 1;
  int pagenumber = 1;

  // RxBool isFocused = false.obs;
  RxInt tabpage = 0.obs;
  late TabController tabController;

  RxBool isSearchLoading = false.obs;

  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    // _focusListen();
    tabController = TabController(
      length: 4,
      initialIndex: 0,
      vsync: this,
    );

    debounce(_searchword, (_) async {
      if (_searchword.value != "") {
        isSearchLoading(true);
        // if (_searchController.postpagenumber == 1) {
        //   _searchController.searchpostinglist.clear();
        // } else if (_searchController.profilepagenumber == 1) {
        //   _searchController.searchprofilelist.clear();
        // } else if (_searchController.questionpagenumber == 1) {
        //   _searchController.searchquestionlist.clear();
        // } else if (_searchController.tagpagenumber == 1) {
        //   _searchController.searchtaglist.clear();
        // }

        if (tabController.index == 0) {
          await search(SearchType.post, _searchword.value, postpagenumber);
        } else if (tabController.index == 1) {
          await search(
              SearchType.profile, _searchword.value, profilepagenumber);
        } else if (tabController.index == 2) {
          await search(
              SearchType.question, _searchword.value, questionpagenumber);
        } else if (tabController.index == 3) {
          await tagsearch();
        }
        isSearchLoading(false);
      }
    }, time: Duration(milliseconds: 300));

    searchtextcontroller.addListener(() {
      _searchword(
          searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " "));
    });

    tabController.addListener(() {
      if (searchtextcontroller.text.isEmpty == false) {
        if (tabController.indexIsChanging == true) {
          String searchword =
              searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ");
          isSearchLoading(true);
          // print(searchpostinglist);
          // print(searchprofilelist);
          // print(searchquestionlist);
          if (tabController.index == 0 && searchword != presearchwordpost) {
            search(SearchType.post, searchtextcontroller.text, postpagenumber);
          } else if (tabController.index == 1 &&
              searchword != presearchwordprofile) {
            search(SearchType.profile, searchtextcontroller.text,
                profilepagenumber);
          } else if (tabController.index == 2 &&
              searchword != presearchwordquestion) {
            search(SearchType.question, searchtextcontroller.text,
                questionpagenumber);
          } else if (tabController.index == 3 &&
              searchword != presearchwordtag) {
            tagsearch();
          }
          isSearchLoading(false);
        }
      }
      // if (tabController.index == 3) {
      //   istag.value = true;
      // } else {
      //   istag.value = false;
      // }
    });

    super.onInit();
  }

  // void focusChange() {
  //   isFocused.value = false;
  // }

  // void _focusListen() {
  //   focusNode.addListener(() {
  //     if (focusNode.hasFocus) {
  //       isFocused.value = true;
  //       // isnosearchpost(false);
  //       // isnosearchprofile(false);
  //       // isnosearchquestion(false);
  //       // isnosearchtag(false);
  //     }
  //   });
  // }

  void clearSearchedList() {
    searchpostinglist.clear();
    searchprofilelist.clear();
    searchquestionlist.clear();
    searchtaglist.clear();
    presearchwordpost = "";
    presearchwordprofile = "";
    presearchwordquestion = "";
    presearchwordtag = "";
  }
}
