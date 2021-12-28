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
  // const QuestionAnswerScreen({ Key? key }) : super(key: key);
  // ProjectMakeController projectmakecontroller =
  //     Get.put(ProjectMakeController());

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            releaseIcon: Icon(Icons.refresh_rounded, color: mainblack),
            completeIcon: Icon(Icons.done_rounded, color: mainblue),
            idleIcon: Icon(Icons.arrow_downward_rounded, color: mainblack),
          ),
          footer: ClassicFooter(
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 1,
            ),
            canLoadingIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 1,
            ),
          ),
          onRefresh: homeController.onRefresh2,
          onLoading: homeController.onLoading2,
          child: CustomScrollView(
            key: PageStorageKey("key2"),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
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
                                      onTap: () {},
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      elevation: 1,
                                      underline: Container(),
                                      icon: Icon(Icons.expand_more),
                                      value: homeController.selectgroup.value,
                                      items: ["모든 질문", "내가 한 질문 "].map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                  style: TextStyle(
                                    color: mainblue,
                                    fontSize: 16,
                                  ),
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
                              child: MyQuestionPostingWidget(
                                item: homeController
                                    .questionResult.value.questionitems[index],
                                index: index,
                                key: Key(
                                  toString(),
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
