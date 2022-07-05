import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/career_rank_widget.dart';

class CareerBoardController extends GetxController {
  Map<String, String> careerField = {
    '1': 'IT',
    '2': '디자인',
    '3': '제조',
    '4': '경영',
    '9': '기타',
    '10': '미정'
  };
  RxList<MapEntry<String, String>> careerFieldList =
      <MapEntry<String, String>>[].obs;
  RxList<CareerRankWidget> careerRank = <CareerRankWidget>[].obs;
  RxList<User> ranker = <User>[
    User(
        userid: 3,
        realName: '김원우',
        type: 1,
        department: '산업경영공',
        loopcount: 0.obs,
        totalposting: 1,
        isuser: 0,
        profileImage:
            'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202203/23/d58e7390-afda-42cd-9374-ca327df1cad8.jpg',
        profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
        looped: FollowState.follower.obs,
        banned: BanState.normal.obs,
        fieldId: "10"),
    User(
        userid: 3,
        realName: '한근형',
        type: 1,
        department: '산업경영공',
        loopcount: 0.obs,
        totalposting: 1,
        isuser: 0,
        profileImage:
            'http://www.footballist.co.kr/news/photo/201405/9983_15159_0541.jpg',
        profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
        looped: FollowState.follower.obs,
        banned: BanState.normal.obs,
        fieldId: "10"),
    User(
        userid: 3,
        realName: '박지성',
        type: 1,
        department: '산업경영공',
        loopcount: 0.obs,
        totalposting: 1,
        isuser: 0,
        profileImage:
            'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202110/04/b9651a63-1ba7-4ee3-bbe8-3c83fbc1f71f.jpg',
        profileTag: [Tag(tagId: 1, tag: '태그', count: 1)],
        looped: FollowState.follower.obs,
        banned: BanState.normal.obs,
        fieldId: "10")
  ].obs;
  RxList<Company> companyList = <Company>[].obs;
  RxList<Post> topPostList = <Post>[].obs;
  RxList<Post> topTagtList = <Post>[].obs;
  RxMap<String, double> postUsageTrendNum = <String, double>{}.obs;
  RxMap<String, double> teptNumMap = <String, double>{}.obs;
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;
  RxMap<String, List<Post>?> activeFieldsPost = <String, List<Post>?>{}.obs;
  RxMap<String, Map<String, Map<String, double>?>> activeFieldsGraph =
      <String, Map<String, Map<String, double>?>>{}.obs;
  PageController pageFieldController = PageController();
  RxInt currentField = 1.obs;

  @override
  void onInit() async {
    careerRank.add(CareerRankWidget(isUniversity: true, ranker: ranker));
    careerRank.add(CareerRankWidget(isUniversity: false, ranker: ranker));
    companyList.add(Company(
        id: 1,
        companyImage:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/DaangnMarket_logo.png/220px-DaangnMarket_logo.png',
        companyName: '당근마켓',
        contactField: 'IT, 디자인',
        contactcount: 0.obs));
    companyList.add(Company(
        id: 2,
        companyImage:
            'http://image.kmib.co.kr/online_image/2021/1217/2021121717103643262_1639728637_0016582097.jpg',
        companyName: '우아한 형제들',
        contactField: 'IT, 디자인',
        contactcount: 0.obs));
    companyList.add(Company(
        id: 3,
        companyImage:
            'https://blog.kakaocdn.net/dn/Sq4OD/btqzlkr13eD/dYwFnscXEA6YIOHckdPDDk/img.jpg',
        companyName: '카카오톡',
        contactField: 'IT, 디자인', contactcount: 0.obs));
    createMap();
    careerFieldList.value = careerField.entries.toList();
    currentFieldMap({careerField.keys.first: careerField.values.first});
    await getPostingGraph();
    await getTopPosts(int.parse(currentFieldMap.keys.first));
    getpopulartag();

    currentFieldMap.listen((data) async {
      if (activeFieldsPost[data.keys.first.toString()] == null) {
        await getPostingGraph();
        await getTopPosts(int.parse(data.keys.first));
      }
    });

    super.onInit();
  }

  void createMap() {
    for (var key in careerField.keys) {
      activeFieldsGraph[key] = {'postUsageTrendNum': null, 'teptNumMap': null};
      activeFieldsPost[key] = null;
    }
    Future.delayed(Duration(milliseconds: 300));
  }

  Future<void> getTopPosts(int id) async {
    await getTopPost(id).then((value) {
      if (value.isError == false) {
        topPostList.value = value.data;
        print(topPostList);
        print(id);
        if (activeFieldsPost[id.toString()] == null) {
          activeFieldsPost[id.toString()] = topPostList.toList();
        }
      }
      print(activeFieldsPost.value);
    });
  }

  Future<void> getPostingGraph() async {
    await getPostingTrend(currentFieldMap.keys.first).then((value) {
      if (value.isError == false) {
        Map<String, int> data = Map.from(value.data);
        teptNumMap(reverseMap(data));
        numberNormalization();
        activeFieldsGraph[currentFieldMap.keys.first]!['teptNumMap'] =
            Map.from(reverseMap(data));
        activeFieldsGraph[currentFieldMap.keys.first]!['postUsageTrendNum'] =
            Map.from(postUsageTrendNum);
        // activeFieldsGraph[currentFieldMap.keys.first] = postUsageTrendNum.value
      }
      print(activeFieldsGraph.value);
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
