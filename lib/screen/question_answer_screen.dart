import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/my_question_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QuestionAnswerScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SmartRefresher(
          controller: homeController.refreshController2,
          enablePullDown: true,
          enablePullUp: homeController.enablepullup2.value,
          header: ClassicHeader(
            textStyle: TextStyle(color: mainblack),
            refreshingText: '',
            releaseText: "",
            completeText: "",
            idleText: "",
            releaseIcon: Column(
              children: [
                Image.asset(
                  'assets/icons/loading.gif',
                  scale: 4.5,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '새로운 질문 받는 중...',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            completeIcon: Column(
              children: [
                Icon(
                  Icons.check_rounded,
                  color: mainblue,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '완료!',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            idleIcon: Column(
              children: [
                Image.asset(
                  'assets/icons/loading.png',
                  scale: 9,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '당겨주세요',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          footer: ClassicFooter(
            completeDuration: Duration.zero,
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: Container(),
            canLoadingIcon: Column(
              children: [
                Text(
                  '또 다른 질문 찾는 중...',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Image.asset(
                  'assets/icons/loading.gif',
                  scale: 4.5,
                ),
              ],
            ),
          ),
          onRefresh: homeController.onRefresh2,
          onLoading: homeController.onLoading2,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            key: PageStorageKey("key2"),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      itemHeight: 48,
                                      onTap: () {},
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      elevation: 1,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.expand_more_rounded,
                                        color: mainblack,
                                      ),
                                      value: homeController.selectgroup.value,
                                      items: ["모든 질문", "나의 질문"].map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        homeController.selectgroup(value);
                                        homeController.onRefresh2();
                                        print(homeController.selectgroup.value);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => QuestionAddContentScreen());
                                },
                                child: Text(
                                  "질문 남기기",
                                  style:
                                      kSubTitle2Style.copyWith(color: mainblue),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ])),
              SliverList(
                delegate: homeController.selectgroup.value == "모든 질문"
                    ? SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                              //on tap event 발생시
                              onTap: () async {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  top: 8,
                                ),
                                child: QuestionPostingWidget(
                                  item: homeController.questionResult.value
                                      .questionitems[index],
                                  index: index,
                                  key: Key(
                                    toString(),
                                  ),
                                ),
                              ));
                        },
                        childCount: homeController
                            .questionResult.value.questionitems.length,
                      )
                    : SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                              //on tap event 발생시
                              onTap: () async {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: MyQuestionPostingWidget(
                                  item: homeController.questionResult.value
                                      .questionitems[index],
                                  index: index,
                                  key: Key(
                                    toString(),
                                  ),
                                ),
                              ));
                        },
                        childCount: homeController
                            .questionResult.value.questionitems.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
