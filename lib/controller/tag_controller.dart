import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  TagController({required this.tagtype});
  static TagController get to => Get.find();
  ScrollController _tagScrollController = ScrollController();
  RxBool isTagChanging = false.obs;
  Rx<ScreenState> tagsearchstate = ScreenState.loading.obs;
  // RxBool isTagSearchLoading = false.obs;
  RxString _searchword = "".obs;
  // late Timer _debounce;

  Tagtype tagtype;
  final maxExtent = Get.height * 0.25;
  RxDouble currentExtent = 0.0.obs;
  RxDouble textfieldOffset = 0.0.obs;
  RxDouble offsetDy = 0.0.obs;
  RxBool keyController = false.obs;
  // _onSearchChanged() {
  //   if (_debounce.isActive) _debounce.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () {
  //     //원하는 함수
  //     gettagsearch(tagtype);
  //   });
  // }

  void onInit() {
    super.onInit();

    debounce(_searchword, (_) {
      tagSearchFunction();
    }, time: Duration(milliseconds: 300));

    tagsearchContoller.addListener(() {
      _searchword(
          tagsearchContoller.text.trim().replaceAll(RegExp("\\s+"), " "));
    });
    _tagScrollController.addListener(() {
      currentExtent.value = maxExtent - _tagScrollController.offset;
      if (currentExtent.value < 0) currentExtent.value = 0.0;
      if (currentExtent.value > maxExtent) currentExtent.value = maxExtent;
    });
  }

  void tagSearchFunction() {
    tagsearch(_searchword.value).then((value) {
      if (value.isError == false) {
        List<Tag> taglist = List.from(value.data["results"])
            .map((map) => Tag.fromJson(map))
            .toList();

        if (taglist
            .where((element) => element.tag == _searchword.value)
            .isNotEmpty) {
          searchtaglist.clear();

          searchtaglist(taglist.map((element) {
            return SearchTagWidget(
              id: element.tagId,
              tag: element.tag,
              count: element.count,
              isSearch: 0,
              tagtype: tagtype,
            );
          }).toList());

          for (var selectedtag in selectedtaglist) {
            searchtaglist
                .removeWhere((element) => element.tag == selectedtag.text);
          }
        } else {
          searchtaglist.clear();

          searchtaglist(taglist.map((element) {
            return SearchTagWidget(
              id: element.tagId,
              tag: element.tag,
              count: element.count,
              isSearch: 0,
              tagtype: tagtype,
            );
          }).toList());
          // if (tagsearchword != '' &&
          //     tagController.selectedtaglist
          //         .where((tag) => tag.text == tagsearchword)
          //         .isEmpty) {
          //   tagController.searchtaglist.insert(
          //       0,
          //       SearchTagWidget(
          //         id: 0,
          //         tag: "처음으로 '${tagsearchword}' 태그 사용하기",
          //         isSearch: 0,
          //         tagtype: tagtype,
          //       ));
          // }

          selectedtaglist.forEach((selectedtag) {
            searchtaglist
                .removeWhere((element) => element.tag == selectedtag.text);
          });
        }
        tagsearchstate(ScreenState.success);
      } else {
        tagsearchstate(ScreenState.error);
      }
    });
  }

  TextEditingController tagsearchContoller = TextEditingController();
  FocusNode tagsearchfocusNode = FocusNode();

  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;
  RxList<SearchTagWidget> searchpagetag = <SearchTagWidget>[].obs;
  RxList<SelectedTagWidget> selectedpersontaglist = <SelectedTagWidget>[].obs;
}
