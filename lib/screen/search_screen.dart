import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/home_posting_screen.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/widget/search_student_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../api/tag_api.dart';
import '../widget/disconnect_reload_widget.dart';
import '../widget/error_reload_widget.dart';

class SearchScreen extends StatelessWidget {
  final SearchController _searchController = Get.put(SearchController());
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 50,
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: mainWhite,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          height: 36,
          child: TextField(
              autocorrect: false,
              readOnly: true,
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SearchFocusScreen()));
                _searchController.isFocused(true);
              },
              focusNode: _searchController.focusNode,
              style: k16Normal,
              cursorColor: mainblack,
              cursorWidth: 1.2,
              cursorRadius: Radius.circular(5.0),
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: cardGray,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.only(right: 24),
                isDense: true,
                hintText: "무엇을 찾으시나요?",
                hintStyle: k16Normal.copyWith(color: maingray),
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 14, 8),
                  child: SvgPicture.asset(
                    "assets/icons/Search_Inactive.svg",
                    width: 20,
                    height: 20,
                    color: maingray,
                  ),
                ),
              )),
        ),
      ),
      body: GestureDetector(
          onTap: () => _searchController.focusNode.unfocus(),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                      top: 24,
                      bottom: 16,
                    ),
                    child: Text(
                      "인기 태그",
                      style: kSubTitle2Style,
                    ),
                  ),
                  Obx(
                    () => homeController.populartagstate.value ==
                            ScreenState.loading
                        ? Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          )
                        : homeController.populartagstate.value ==
                                ScreenState.disconnect
                            ? DisconnectReloadWidget(reload: () {
                                getpopulartag();
                              })
                            : homeController.populartagstate.value ==
                                    ScreenState.error
                                ? ErrorReloadWidget(reload: () {
                                    getpopulartag();
                                  })
                                : Container(
                                    height: 88,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: homeController.populartaglist
                                          .map((tag) => Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    (homeController
                                                                .populartaglist
                                                                .indexOf(tag) ==
                                                            0)
                                                        ? const SizedBox(
                                                            width: 16,
                                                          )
                                                        : Container(),
                                                    (homeController
                                                                .populartaglist
                                                                .indexOf(tag) !=
                                                            homeController
                                                                .populartaglist
                                                                .length)
                                                        ? const SizedBox(
                                                            width: 16,
                                                          )
                                                        : Container()
                                                  ]))
                                          .toList(),
                                    ),
                                  ),
                  )

                  // weekendStudent(_modalController),
                ],
              ),
            ),
          )),
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
              style: kSubTitle2Style,
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
                style: kButtonStyle.copyWith(color: mainblue),
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
