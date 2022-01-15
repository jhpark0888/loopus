// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class SignupTagScreen extends StatelessWidget {
  SignupTagScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find();

  TagController tagController = Get.put(TagController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              if (tagController.selectedtaglist.length == 3) {
                signupRequest();
                Get.to(() => LogInScreen());
              }
            },
            child: Obx(
              () => Text(
                '완료',
                style: kSubTitle2Style.copyWith(
                  color: tagController.selectedtaglist.length == 3
                      ? mainblue
                      : mainblack.withOpacity(0.38),
                ),
              ),
            ),
          )
        ],
        title: "회원 가입",
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  32,
                  24,
                  32,
                  12,
                ),
                child: Column(
                  children: const [
                    Text(
                      '관심 태그를 선택해주세요',
                      style: kSubTitle1Style,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '학과 및 관심 태그와 관련된 컨텐츠를 추천해드릴게요',
                      style: kBody1Style,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '선택한 태그',
                    style: kSubTitle2Style,
                  ),
                  Obx(
                    () => Text(
                      '${tagController.selectedtaglist.length} / 3',
                      style: kSubTitle2Style,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //TODO : 태그 삭제하고 검색 탭 눌렀을 때 초기화되는 오류 수정

            Container(
              height: 32,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: (index == 0) ? 16 : 0,
                          right: (index == 0) ? 16 : 0),
                      child: Obx(
                        () => Row(children: tagController.selectedtaglist),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: tagController.tagsearch,
                style: kBody2Style,
                cursorColor: Colors.grey,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),

                // focusNode: searchController.detailsearchFocusnode,
                textAlign: TextAlign.start,
                // selectionHeightStyle: BoxHeightStyle.tight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mainlightgrey,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  // focusColor: Colors.black,
                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(right: 16),
                  hintStyle: kBody2Style.copyWith(
                      color: mainblack.withOpacity(0.38), height: 1.5),
                  isDense: true,
                  hintText: "예) 봉사, 기계공학과, 서포터즈",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: SvgPicture.asset(
                      "assets/icons/Search_Inactive.svg",
                      width: 16,
                      height: 16,
                      color: mainblack.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Obx(
              () => Expanded(
                child: ListView(
                  children: tagController.searchtaglist,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
