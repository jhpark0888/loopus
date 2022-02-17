// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
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
import 'package:loopus/widget/tagsearchwidget.dart';

class ProfileTagChangeScreen extends StatelessWidget {
  ProfileController profileController = Get.find();
  TagController tagController =
      Get.find<TagController>(tag: Tagtype.profile.toString());

  User? user;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              bottomBorder: false,
              actions: [
                TextButton(
                  onPressed: () async {
                    LocalDataController.to.tagChange(true);
                    tagController.isTagChanging.value = true;
                    await changeMyTag().then((value) {
                      tagController.isTagChanging.value = false;
                      Get.back();
                      ModalController.to
                          .showCustomDialog('관심 태그 기반으로 홈 화면을 재구성했어요', 1500);
                    });
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
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '어떤 태그',
                                      style: kSubTitle2Style.copyWith(
                                        color: mainblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '로 변경하시겠어요?',
                                      style: kSubTitle2Style,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
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
                  body: TagSearchWidget(
                    tagtype: Tagtype.profile,
                  )),
            ),
          ),
          if (tagController.isTagChanging.value == true)
            Container(
              height: Get.height,
              width: Get.width,
              color: mainblack.withOpacity(0.3),
              child: Image.asset(
                'assets/icons/loading.gif',
                scale: 6,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> changeMyTag() async {
    if (tagController.selectedtaglist.length == 3) {
      user = await updateProfile(
          profileController.myUserInfo.value,
          null,
          tagController.selectedtaglist.map((tag) => tag.text).toList(),
          ProfileUpdateType.tag);
    }
    if (user != null) {
      profileController.myUserInfo(user);
    }
  }
}
