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
import 'package:loopus/widget/tagsearchwidget.dart';

class SignupTagScreen extends StatelessWidget {
  SignupTagScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find();

  TagController tagController = Get.put(TagController(tagtype: Tagtype.profile),
      tag: Tagtype.profile.toString());

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
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '관심 태그',
                              style: kSubTitle1Style.copyWith(
                                color: mainblue,
                              ),
                            ),
                            const TextSpan(
                              text: '를 선택해주세요',
                              style: kSubTitle1Style,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        '전공 학과와 관심 태그를 바탕으로 홈 화면을 구성해드릴게요',
                        style: kBody1Style,
                        textAlign: TextAlign.center,
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
    );
  }
}
