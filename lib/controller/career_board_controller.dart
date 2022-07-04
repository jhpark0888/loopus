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
        fieldId: 10),
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
        fieldId: 10),
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
        fieldId: 10)
  ].obs;
  RxList<Company> companyList = <Company>[].obs;
  RxList<Post> topPostList = <Post>[].obs;
  RxList<Post> topTagtList = <Post>[].obs;
  RxMap<String, double> postUsageTrendNum = <String, double>{}.obs;
  RxMap<String, int> teptNumMap = <String, int>{}.obs;
  RxMap<String, int> myteptNumMap =
      {'1': 1, '2': 0, '3': 2, '4': 1, '5': 2, '6': 2}.obs;
  PageController fieldController =
      PageController(viewportFraction: 0.2, initialPage: 0);
  PageController pageFieldController = PageController();
  RxDouble currentField = 0.0.obs;
  RxString currentFieldText = ''.obs;
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;
  @override
  void onInit() async {
    careerRank.add(CareerRankWidget(isUniversity: true, ranker: ranker));
    careerRank.add(CareerRankWidget(isUniversity: false, ranker: ranker));
    companyList.add(Company(
        companyImage:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/DaangnMarket_logo.png/220px-DaangnMarket_logo.png',
        companyName: '당근마켓',
        contactField: 'IT, 디자인'));
    companyList.add(Company(
        companyImage:
            'http://image.kmib.co.kr/online_image/2021/1217/2021121717103643262_1639728637_0016582097.jpg',
        companyName: '우아한 형제들',
        contactField: 'IT, 디자인'));
    companyList.add(Company(
        companyImage:
            'https://blog.kakaocdn.net/dn/Sq4OD/btqzlkr13eD/dYwFnscXEA6YIOHckdPDDk/img.jpg',
        companyName: '카카오톡',
        contactField: 'IT, 디자인'));
  
    careerFieldList.value = careerField.entries.toList();
    currentFieldMap({careerField.keys.first: careerField.values.first});
    await getPostingGraph();
    await getTopPosts(int.parse(currentFieldMap.keys.first));
    getpopulartag();

    currentFieldMap.listen((data) async {
      await getPostingGraph();
      await getTopPosts(int.parse(currentFieldMap.keys.first));
    });

    super.onInit();
  }

  Future<void> getTopPosts(int id) async {
    await getTopPost(id).then((value) {
      if (value.isError == false) {
        topPostList.value = value.data;
      }
    });
  }

  Future<void> getPostingGraph() async {
    await getPostingTrend(currentFieldMap.keys.first).then((value) {
      if (value.isError == false) {
        Map<String, int> data = Map.from(value.data);
        teptNumMap(reverseMap(data));
        numberNormalization();
      }
    });
  }

  Map<String, int> reverseMap(Map<String, int> data) {
    Map<String, int> reverse = {};
    for (var _key in data.keys.toList().reversed) {
      reverse[_key] = data[_key]!;
    }
    return reverse;
  }

  void numberNormalization() {
    int maxNum = teptNumMap.values.toList().reduce(max);

    for (var i in teptNumMap.entries) {
      postUsageTrendNum[i.key] = i.value == 0
          ? 1
          : double.parse(((i.value / maxNum) * 100).toString());
    }
  }
}
