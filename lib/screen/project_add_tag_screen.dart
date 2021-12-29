// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProjectAddTagScreen extends StatelessWidget {
  ProjectAddTagScreen({Key? key}) : super(key: key);
  TagController tagController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (tagController.selectedtaglist.length == 3) {
                Get.to(() => ProjectAddPersonScreen());
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                  color: tagController.selectedtaglist.length == 3
                      ? mainblue
                      : mainblack.withOpacity(0.38),
                ),
              ),
            ),
          ),
        ],
        title: "활동 태그",
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '활동을 대표하는 키워드가 무엇인가요?',
                          style: kSubTitle1Style,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '누구나 쉽게 찾을 수 있는 태그를 입력해주세요',
                          style: kBody2Style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            15,
            20,
            15,
            10,
          ),
          child: Column(
            children: [
              Row(
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
              SizedBox(
                height: 16,
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  width: Get.width,
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: tagController.selectedtaglist,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: tagController.tagsearch,
                style: kBody1Style,
                cursorColor: mainblack,
                // autofocus: true,
                // focusNode: searchController.detailsearchFocusnode,
                textAlign: TextAlign.start,
                // selectionHeightStyle: BoxHeightStyle.tight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mainlightgrey,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12)),
                  // focusColor: Colors.black,
                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(10),
                  hintStyle:
                      kBody1Style.copyWith(color: mainblack.withOpacity(0.38)),
                  isDense: true,
                  hintText: "예) 봉사, 기계공학과, 서포터즈",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/icons/Search_Inactive.svg',
                    ),
                  ),
                ),
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
      ),
    );
  }
}
