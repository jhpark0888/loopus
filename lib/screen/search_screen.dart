import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/search_widget.dart';

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
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColors.mainWhite,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            centerTitle: false,
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.mainWhite,
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
                        _searchController.searchtextcontroller.clear();
                        _searchController.tabController.index = 0;
                        _searchController.searchInit();
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
                    () => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "최근 검색",
                            style: MyTextTheme.mainbold(context),
                          ),
                          const Spacer(),
                          if (_searchController.recentSearchList.isNotEmpty)
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
                                style: MyTextTheme.main(context)
                                    .copyWith(color: AppColors.mainblue),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Obx(
                    () => _searchController.recentSearchList.isNotEmpty
                        ? ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => RecentSearchWidget(
                                recentSearch:
                                    _searchController.recentSearchList[index]),
                            separatorBuilder: (content, index) =>
                                const SizedBox(height: 24),
                            itemCount:
                                _searchController.recentSearchList.length)
                        : Center(
                            child: Text(
                              "검색한 기록이 없어요",
                              style: MyTextTheme.main(context)
                                  .copyWith(color: AppColors.maingray),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )),
    );
  }
}
