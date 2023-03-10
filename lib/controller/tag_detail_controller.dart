import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagDetailController extends GetxController
    with GetTickerProviderStateMixin {
  TagDetailController(this.tagid);
  static TagDetailController get to => Get.find();

  RxList<Post> tagPopPostList = <Post>[].obs;
  RxList<Post> tagNewPostList = <Post>[].obs;

  List<int> pagenumList = List.generate(2, (index) => 1);

  List<RxBool> isTagEmptyList = List.generate(2, (index) => false.obs);
  List<RxBool> isTagLoadingList = List.generate(2, (index) => false.obs);
  List<RxBool> enablePullUpList = List.generate(2, (index) => true.obs);

  late TabController tabController;

  int tagid;

  RxBool isTagLoading = true.obs;

  RxMap<String, double> tagUsageTrendNum = <String, double>{}.obs;

  Map<String, int> teptNumMap = {};

  //태그 정규화
  void numNormalization() async {
    int maxNum = teptNumMap.values.toList().reduce(max);

    await Future.delayed(const Duration(milliseconds: 500));

    for (var entry in teptNumMap.entries) {
      String key = entry.key;
      double value = maxNum != 0 ? entry.value * (130 / maxNum) : 1;

      tagUsageTrendNum[key] = value == 0 ? 1 : value;
    }
  }

  @override
  void onInit() async {
    tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );

    // for (var i in refreshControllerList) {
    //   i.loadNoData();
    // }

    // await postLoadFunction();

    super.onInit();
  }

  // void beforeSixMonth() {
  //   int month = DateTime.now().month;

  //   for (int i = 0; i < 6; i++) {
  //     tagUsageTrendNum[month.toString()] = 0.0.obs;
  //     month -= 1;
  //     if (month < 0) {
  //       month = 12;
  //     }
  //   }
  //   tagUsageTrendNum =
  //       LinkedHashMap.fromEntries(tagUsageTrendNum.entries.toList().reversed);
  // }

  Future postLoadFunction(
    List<RefreshController> refreshControllerList,
  ) async {
    await getTagPosting(tagid, pagenumList[tabController.index],
            tabController.index == 0 ? "pop" : "new")
        .then((value) {
      if (value.isError == false) {
        if (value.data["monthly_count"] != null) {
          // if (tagBarGraph != null) {
          teptNumMap = Map.from(value.data["monthly_count"]);

          teptNumMap =
              LinkedHashMap.fromEntries(teptNumMap.entries.toList().reversed);

          for (var key in teptNumMap.keys) {
            tagUsageTrendNum[key] = 0.0;
          }
          numNormalization();
          // }
        }

        if (value.data["related_pop"] != null) {
          List<Post> popList = List.from(value.data["related_pop"])
              .map((post) => Post.fromJson(post))
              .toList();

          if (popList.isEmpty) {
            isTagEmptyList[0].value = true;
          }

          tagPopPostList.addAll(popList);
        }

        if (value.data["related_new"] != null) {
          List<Post> newList = List.from(value.data["related_new"])
              .map((post) => Post.fromJson(post))
              .toList();

          if (newList.isEmpty) {
            isTagEmptyList[1].value = true;
          }

          tagNewPostList.addAll(newList);
        }

        if (pagenumList[tabController.index] == 1) {
          for (int i = 0; i < tabController.length; i++) {
            pagenumList[i] += 1;
            refreshControllerList[i].loadComplete();
            enablePullUpList[i](true);
          }
        } else {
          pagenumList[tabController.index] += 1;
          refreshControllerList[tabController.index].loadComplete();
          enablePullUpList[tabController.index](true);
        }
      } else {
        if (value.errorData!['statusCode'] == 204) {
          refreshControllerList[tabController.index].loadNoData();
          enablePullUpList[tabController.index](false);
        } else {
          refreshControllerList[tabController.index].loadComplete();
          enablePullUpList[tabController.index](true);
        }
      }
    });

    // if (pagenumList[tabController.index] == 1) {
    //   for (var isloading in isTagLoadingList) {
    //     isloading(false);
    //   }
    // }
    //  else {
    // isTagLoadingList[tabController.index](false);
    // }
  }
}

class TagBarGraph {
  RxMap<String, double> tagUsageTrendNum = <String, double>{}.obs;

  Map<String, int> teptNumMap = {};

  void numNormalization() async {
    int maxNum = teptNumMap.values.toList().reduce(max);

    await Future.delayed(const Duration(milliseconds: 500));

    for (var entry in teptNumMap.entries) {
      String key = entry.key;
      double value = maxNum != 0 ? entry.value * (130 / maxNum) : 1;

      tagUsageTrendNum[key] = value == 0 ? 1 : value;
    }
  }
}
