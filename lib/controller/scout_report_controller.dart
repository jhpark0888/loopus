import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/career_rank_widget.dart';

class ScoutReportController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, String> careerField = {
    '1': 'IT',
    '2': '디자인',
    '3': '제조',
    '4': '경영',
    '9': '기타',
    '10': '미정'
  };

  late TabController tabController;
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

  List<Company> companyList = [
    Company(
        id: 1,
        companyImage:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/DaangnMarket_logo.png/220px-DaangnMarket_logo.png',
        companyName: '당근마켓',
        contactField: 'IT, 디자인',
        contactcount: 0.obs),
    Company(
        id: 2,
        companyImage:
            'http://image.kmib.co.kr/online_image/2021/1217/2021121717103643262_1639728637_0016582097.jpg',
        companyName: '우아한 형제들',
        contactField: 'IT, 디자인',
        contactcount: 0.obs),
    Company(
        id: 3,
        companyImage:
            'https://blog.kakaocdn.net/dn/Sq4OD/btqzlkr13eD/dYwFnscXEA6YIOHckdPDDk/img.jpg',
        companyName: '카카오톡',
        contactField: 'IT, 디자인',
        contactcount: 0.obs)
  ];

  RxList<Contact> contactList = <Contact>[].obs;

  @override
  void onInit() async {
    contactList.value = [
      Contact(
          id: 1,
          user: ranker[0],
          company: companyList[0],
          date: DateTime.now()),
      Contact(
          id: 2,
          user: ranker[1],
          company: companyList[1],
          date: DateTime.now()),
      Contact(
          id: 3,
          user: ranker[0],
          company: companyList[2],
          date: DateTime.now()),
      Contact(
          id: 4,
          user: ranker[2],
          company: companyList[0],
          date: DateTime.now()),
    ];

    tabController =
        TabController(length: fieldList.length, initialIndex: 0, vsync: this);

    super.onInit();
  }
}
