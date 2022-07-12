import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CareerBoardController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, String> careerField = {
    for (var entry in fieldList.entries)
      if (entry.key != "10") entry.key: entry.value
  };
  //  {
  //   '1': 'IT',
  //   '2': '디자인',
  //   '3': '제조',
  //   '4': '경영',
  //   '9': '기타',
  // };
  RxList<MapEntry<String, String>> careerFieldList =
      <MapEntry<String, String>>[].obs;

  Map<String, RxList<Company>> companyMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: <Company>[].obs
  };
  Map<String, RxList<User>> campusRankerMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: <User>[].obs
  };
  Map<String, RxList<User>> koreaRankerMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: <User>[].obs
  };
  Map<String, RxList<Post>> popPostMap = {
    for (var key in fieldList.keys)
      if (key != "10")
        key: <Post>[
          // Post(
          //     id: 1,
          //     userid: 15,
          //     content: "asdasdaslkdasncasnlcmlsansdlasndlkasnd",
          //     images: [],
          //     links: [],
          //     tags: [],
          //     date: DateTime.now(),
          //     project: Project(
          //         id: 1,
          //         userid: 15,
          //         fieldIds: ["1"],
          //         careerName: "연습",
          //         posts: <Post>[].obs,
          //         members: [],
          //         is_user: 1,
          //         user: User.defaultuser()),
          //     comments: <Comment>[].obs,
          //     likeCount: 0.obs,
          //     isLiked: 0.obs,
          //     isMarked: 0.obs,
          //     isuser: 1,
          //     user: User.defaultuser())
        ].obs
  };
  Map<String, RxList<Tag>> topTagMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: <Tag>[].obs
  };
  Map<String, Rx<ScreenState>> screenStateMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: ScreenState.normal.obs
  };
  Map<String, Map<String, Map<String, double>>> postGraphMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: {'postUsageTrendNum': {}, 'teptNumMap': {}}
  };
  Map<String, RefreshController> refreshControllerMap = {
    for (var key in fieldList.keys)
      if (key != "10") key: RefreshController()
  };

  RxMap<String, double> postUsageTrendNum = <String, double>{}.obs;
  RxMap<String, double> teptNumMap = <String, double>{}.obs;
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;

  late TabController tabController;

  RxInt currentField = 1.obs;

  @override
  void onInit() async {
    tabController = TabController(length: careerField.length, vsync: this);

    tabController.addListener(() {
      currentField.value = tabController.index;
      currentFieldMap({
        careerFieldList[currentField.value].key:
            careerFieldList[currentField.value].value
      });

      if (screenStateMap[currentFieldMap.keys.first.toString()]!.value ==
          ScreenState.normal) {
        careerBoardLoad(currentFieldMap.keys.first);
      }
    });

    careerFieldList.value = careerField.entries.toList();
    currentFieldMap[careerFieldList[0].key] = careerFieldList[0].value;
    careerBoardLoad(currentFieldMap.keys.first);

    // currentFieldMap.listen((data) async {
    //   if (screenStateMap[data.keys.first.toString()]!.value ==
    //       ScreenState.normal) {
    //     careerBoardLoad(data.keys.first);
    //   }
    // });

    super.onInit();
  }

  void careerBoardLoad(String fieldId, {bool isloading = true}) async {
    if (isloading) {
      screenStateMap[fieldId]!.value = ScreenState.loading;
    }
    await getPostingGraph(fieldId);
    await getTopPosts(fieldId);
    print(screenStateMap[fieldId]!.value);
  }

  void onRefresh() {
    careerBoardLoad(currentFieldMap.keys.first, isloading: false);
    refreshControllerMap[currentFieldMap.keys.first]!.refreshCompleted();
  }

  Future<void> getTopPosts(String id) async {
    await getTopPost(id, "main").then((value) {
      if (value.isError == false) {
        List<Post> postlist = List.from(value.data["posting"]).map((post) {
          return Post.fromJson(post);
        }).toList();

        koreaRankerMap[id.toString()]!.value =
            List.from(value.data["profile"]).map((user) {
          return User.fromJson(user);
        }).toList();
        if (popPostMap[id.toString()] == null) {
          popPostMap[id.toString()]!.value = postlist;
        }

        screenStateMap[id.toString()]!.value = ScreenState.success;
      } else {
        print(screenStateMap[id.toString()]!.hashCode);
        errorSituation(value, screenState: screenStateMap[id.toString()]!);
      }
      // print(activeFieldsPost.value);
    });
  }

  Future<void> getPostingGraph(String id) async {
    await getPostingTrend(currentFieldMap.keys.first).then((value) {
      if (value.isError == false) {
        Map<String, int> data = Map.from(value.data);
        teptNumMap(reverseMap(data));
        numberNormalization();
        postGraphMap[currentFieldMap.keys.first]!['teptNumMap'] =
            Map.from(reverseMap(data));
        postGraphMap[currentFieldMap.keys.first]!['postUsageTrendNum'] =
            Map.from(postUsageTrendNum);
        // activeFieldsGraph[currentFieldMap.keys.first] = postUsageTrendNum.value
      } else {
        errorSituation(value, screenState: screenStateMap[id.toString()]!);
      }
    });
  }

  Map<String, double> reverseMap(Map<String, int> data) {
    Map<String, double> reverse = {};
    for (var _key in data.keys.toList().reversed) {
      reverse[_key] = double.parse(data[_key]!.toString());
    }
    return reverse;
  }

  void numberNormalization() {
    double maxNum = teptNumMap.values.toList().reduce(max);

    for (var i in teptNumMap.entries) {
      postUsageTrendNum[i.key] = i.value == 0
          ? 1
          : double.parse(((i.value / maxNum) * 100).toString());
    }
  }
}
