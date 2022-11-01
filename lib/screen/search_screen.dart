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
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_student_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../api/tag_api.dart';
import '../widget/disconnect_reload_widget.dart';
import '../widget/error_reload_widget.dart';

class SearchScreen extends StatelessWidget {
  final SearchController _searchController = Get.put(SearchController());

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
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            centerTitle: false,
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: mainWhite,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: SearchTextFieldWidget(
                      hinttext: '검색',
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchFocusScreen()));
                        _searchController.focusNode.requestFocus();
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Obx(
                    () => _searchController.recentSearchList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "최근 검색",
                                  style: kmainbold,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    if (_searchController
                                        .recentSearchList.isNotEmpty) {
                                      await deleteResentSearch("all", 0)
                                          .then((value) {
                                        if (value.isError == false) {
                                          _searchController.recentSearchList
                                              .clear();
                                        } else {
                                          errorSituation(value);
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    "기록 전체 삭제",
                                    style: kmain.copyWith(color: mainblue),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Obx(
                    () => ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => RecentSearchWidget(
                            recentSearch:
                                _searchController.recentSearchList[index]),
                        separatorBuilder: (content, index) =>
                            const SizedBox(height: 24),
                        itemCount: _searchController.recentSearchList.length),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )),
    );
  }
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
