import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/app.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/home_posting_screen.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_student_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../api/tag_api.dart';
import '../widget/disconnect_reload_widget.dart';
import '../widget/error_reload_widget.dart';

class SearchScreen extends StatelessWidget {
  final SearchController _searchController = Get.put(SearchController());
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final ctx = Get.find<AppController>().searcnPageNaviationKey.currentContext;
    final result =
        ctx?.dependOnInheritedWidgetOfExactType<PrimaryScrollController>();
    _searchController.scrollcontroller = result!.controller!;
    return GestureDetector(
      onTap: () {
        _searchController.focusNode.unfocus();
      },
      child: Obx(
        () => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 50,
              centerTitle: false,
              titleSpacing: 0,
              elevation: 0,
              backgroundColor: mainWhite,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 36,
                child: Row(
                  children: [
                    Expanded(
                      child: SearchTextFieldWidget(
                        hinttext: '무엇을 찾으시나요?',
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchFocusScreen()));
                        },
                        readonly: true,
                        controller: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: ScrollNoneffectWidget(
              child: SmartRefresher(
                scrollController: _searchController.scrollcontroller,
                primary: false,
                // physics: const BouncingScrollPhysics(),
                // scrollController: _searchController.scrollcontroller,
                controller: _searchController.refreshController,
                enablePullUp: true,
                header: const MyCustomHeader(),
                footer: const MyCustomFooter(),
                onRefresh: _searchController.onRefresh,
                onLoading: _searchController.onLoading,
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          "이 계정을 추천해요",
                          style: kmainbold,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      SizedBox(
                          height: 105,
                          child: Center(
                            child: Text(
                              "준비 중입니다",
                              style: kmain.copyWith(color: maingray),
                            ),
                          )
                          // ListView.separated(
                          //     scrollDirection: Axis.horizontal,
                          //     padding: const EdgeInsets.symmetric(horizontal: 20),
                          //     itemBuilder: (context, index) {
                          //       return Container();
                          //     },
                          //     separatorBuilder: (context, index) {
                          //       return const SizedBox(
                          //         width: 14,
                          //       );
                          //     },
                          //     itemCount: _searchController.recommandUsers.length),
                          ),
                      DivideWidget(),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          "지금 인기있는 포스트를 만나보세요",
                          style: kmainbold,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PostingWidget(
                                item: _searchController.popPostList[index],
                                type: PostingWidgetType.search);
                          },
                          separatorBuilder: (context, index) => DivideWidget(
                                height: 10,
                              ),
                          itemCount: _searchController.popPostList.length)
                      // weekendStudent(_modalController),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

Widget weekendStudent() {
  return Padding(
    padding: const EdgeInsets.only(
      right: 16,
      left: 16,
      top: 28,
      bottom: 32,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "이 주의 학생",
              style: ktempFont,
            ),
            GestureDetector(
              onTap: () {
                showCustomDialog(
                  '이 주의 활동 수, 포스팅 수, 답변 수 등을 점수로 환산해 매긴 순위입니다 (매 주 금요일마다 갱신됩니다)',
                  1500,
                );
              },
              child: Text(
                "선정 기준이 뭔가요?",
                style: ktempFont.copyWith(color: mainblue),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
              SearchStudentWidget(),
            ],
          ),
        )
      ],
    ),
  );
}

Widget searchloading() {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
      SizedBox(
        height: 4,
      ),
      Text(
        '검색중...',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: mainblue.withOpacity(0.6),
        ),
      ),
    ],
  );
}
