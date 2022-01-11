// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProfileTagChangeScreen extends StatelessWidget {
  ProfileController profileController = Get.find();
  TagController tagController = Get.put(TagController());

  User? user;

  @override
  Widget build(BuildContext context) {
    tagController.selectedtaglist.clear();
    for (var tag in profileController.myUserInfo.value.profileTag) {
      tagController.selectedtaglist.add(SelectedTagWidget(
        id: tag.tagId,
        text: tag.tag,
      ));
    }
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () async {
              if (tagController.selectedtaglist.length == 3) {
                user = await updateProfile(
                    profileController.myUserInfo.value,
                    null,
                    tagController.selectedtaglist
                        .map((tag) => tag.text)
                        .toList());
                print(user!.profileTag);
              }
              if (user != null) {
                profileController.myUserInfo(user);
              }
              Get.back();
            },
            child: Obx(
              () => Text(
                '변경',
                style: kSubTitle2Style.copyWith(
                  color: tagController.selectedtaglist.length == 3
                      ? mainblue
                      : mainblack.withOpacity(0.38),
                ),
              ),
            ),
          )
        ],
        title: "관심 태그 변경",
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
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
                    children: [
                      Text(
                        '어떤 태그로 변경하시겠어요?',
                        style: kSubTitle1Style,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        '관심태그와 관련된 포스팅과 질문을 추천해드려요',
                        style: kBody1Style,
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
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: Get.width,
                  height: 32,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: tagController.selectedtaglist,
                  ),
                ),
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
                        color: mainblack.withOpacity(0.38)),
                    isDense: true,
                    hintText: "예) 봉사, 기계공학과, 서포터즈",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
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
      ),
    );
  }
}
