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
          controller: homeController.refreshController,
          enablePullDown: true,
          enablePullUp: homeController.enablepullup.value,
          header: ClassicHeader(
              textStyle: TextStyle(color: mainblack),
              releaseText: "새로고침",
              completeText: "완료",
              idleText: "",
              releaseIcon: Icon(Icons.refresh, color: mainblack),
              completeIcon: Icon(Icons.done, color: Colors.green),
              idleIcon: Icon(Icons.arrow_downward, color: mainblack)),
          footer: ClassicFooter(
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 3,
            ),
            canLoadingIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 3,
            ),
          ),
          onRefresh: homeController.onRefresh,
          onLoading: homeController.onLoading,
          child: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => DropdownButton(
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
                                    homeController.onRefresh;
                                    print(homeController.selectgroup.value);
                                  },
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
              // SliverList(
              //   delegate:
              // ),
              // SliverList(
              //     delegate: SliverChildListDelegate([
              //   Column(
              //     children: [
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Divider(
              //         thickness: 4,
              //       ),
              //     ],
              //   ),
              // ])),
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
                                      .questionitems.questions[index],
                                  index: index,
                                  key: Key(
                                    toString(),
                                  ),
                                ),
                              ));
                        },
                        childCount: homeController.questionResult.value
                            .questionitems.questions.length,
                      )
                    : SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                              //on tap event 발생시
                              onTap: () async {},
                              child: MyQuestionPostingWidget(
                                item: homeController.questionResult.value
                                    .questionitems.myQuestions[index],
                                index: index,
                                key: Key(
                                  toString(),
                                ),
                              ));
                        },
                        childCount: homeController.questionResult.value
                            .questionitems.myQuestions.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
