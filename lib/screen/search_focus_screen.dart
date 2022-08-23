import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/search_screen.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../controller/modal_controller.dart';

class SearchFocusScreen extends StatelessWidget {
  final SearchController _searchController = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: 36,
            child: Row(
              children: [
                Expanded(
                    child: SearchTextFieldWidget(
                  hinttext: '무엇을 찾으시나요?',
                  ontap: () {},
                  readonly: false,
                  controller: _searchController.searchtextcontroller,
                )),
                GestureDetector(
                  onTap: AppController.to.willPopAction,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      '취소',
                      style: kmain.copyWith(color: mainblue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: RefreshConfiguration(
          child: ScrollNoneffectWidget(
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        backgroundColor: mainWhite,
                        toolbarHeight: 44,
                        pinned: true,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            TabBar(
                                controller: _searchController.tabController,
                                labelStyle: kmainbold,
                                labelColor: mainblack,
                                unselectedLabelStyle:
                                    kmainbold.copyWith(color: dividegray),
                                unselectedLabelColor: dividegray,
                                automaticIndicatorColorAdjustment: false,
                                indicator: const UnderlineIndicator(
                                  strokeCap: StrokeCap.round,
                                  borderSide:
                                      BorderSide(width: 2, color: mainblack),
                                ),
                                isScrollable: false,
                                tabs: const [
                                  Tab(
                                    height: 40,
                                    child: Text(
                                      "계정",
                                    ),
                                  ),
                                  Tab(
                                    height: 40,
                                    child: Text(
                                      "포스트",
                                    ),
                                  ),
                                  Tab(
                                    height: 40,
                                    child: Text(
                                      "태그",
                                    ),
                                  ),
                                  Tab(
                                    height: 40,
                                    child: Text(
                                      "기업",
                                    ),
                                  ),
                                ]),
                            Divider(
                              height: 1,
                              thickness: 2,
                              color: dividegray,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: ScrollNoneffectWidget(
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _searchController.tabController,
                    children: [
                      Obx(
                        () => _searchController.isSearchLoadingList[0].value
                            ? const LoadingWidget()
                            : _searchController.isSearchEmptyList[0].value ==
                                    true
                                ? const SearchEmptyWidget()
                                : Obx(
                                    () => SmartRefresher(
                                      physics: const BouncingScrollPhysics(),
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      controller: _searchController
                                          .refreshControllerList[0],
                                      footer: const MyCustomFooter(),
                                      onLoading:
                                          _searchController.onSearchLoading,
                                      child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          itemBuilder: (context, index) {
                                            return SearchUserWidget(
                                                user: _searchController
                                                    .searchUserList[index]);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 4,
                                            );
                                          },
                                          itemCount: _searchController
                                              .searchUserList.length),
                                    ),
                                  ),
                      ),
                      Obx(
                        () => _searchController.isSearchLoadingList[1].value
                            ? const LoadingWidget()
                            : _searchController.isSearchEmptyList[1].value ==
                                    true
                                ? const SearchEmptyWidget()
                                : Obx(
                                    () => SmartRefresher(
                                      physics: const BouncingScrollPhysics(),
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      controller: _searchController
                                          .refreshControllerList[1],
                                      footer: const MyCustomFooter(),
                                      onLoading:
                                          _searchController.onSearchLoading,
                                      child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          itemBuilder: (context, index) {
                                            return PostingWidget(
                                              item: _searchController
                                                  .searchPostList[index],
                                              type: PostingWidgetType.search,
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return DivideWidget(
                                              height: 10,
                                            );
                                          },
                                          itemCount: _searchController
                                              .searchPostList.length),
                                    ),
                                  ),
                      ),
                      Obx(
                        () => _searchController.isSearchLoadingList[2].value
                            ? const LoadingWidget()
                            : _searchController.isSearchEmptyList[2].value ==
                                    true
                                ? const SearchEmptyWidget()
                                : Obx(
                                    () => SmartRefresher(
                                      physics: const BouncingScrollPhysics(),
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      controller: _searchController
                                          .refreshControllerList[2],
                                      footer: const MyCustomFooter(),
                                      onLoading:
                                          _searchController.onSearchLoading,
                                      child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          itemBuilder: (context, index) {
                                            return SearchTagWidget(
                                                tag: _searchController
                                                    .searchTagList[index]);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 4,
                                            );
                                          },
                                          itemCount: _searchController
                                              .searchTagList.length),
                                    ),
                                  ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/company_ready.svg",
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "기업 정보를 수집중이에요\n빠른 시일 내 기업 정보를 제공해 드릴게요",
                              style: kmainheight,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchEmptyWidget extends StatelessWidget {
  const SearchEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        '"${SearchController.to.searchtextcontroller.text}"에 대한 검색 결과가 없습니다',
        style: kmain,
      ),
    );
  }
}
