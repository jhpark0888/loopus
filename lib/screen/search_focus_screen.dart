import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
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
import 'package:loopus/widget/tabbar_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../controller/modal_controller.dart';

class SearchFocusScreen extends StatelessWidget {
  final SearchController _searchController = Get.find();

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width,
            height: 36,
            child: Row(
              children: [
                Expanded(
                    child: SearchTextFieldWidget(
                  hinttext: '검색',
                  ontap: () {},
                  readonly: false,
                  controller: _searchController.searchtextcontroller,
                )),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: AppController.to.willPopAction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    child: Text(
                      '취소',
                      style: kmainbold.copyWith(color: mainblue),
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
                        flexibleSpace: TabBarWidget(
                            tabController: _searchController.tabController,
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
                                              vertical: 16),
                                          itemBuilder: (context, index) {
                                            return SearchUserWidget(
                                                user: _searchController
                                                    .searchUserList[index]);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 24,
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
                                      child: ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          itemBuilder: (context, index) {
                                            return PostingWidget(
                                              item: _searchController
                                                  .searchPostList[index],
                                              type: PostingWidgetType.search,
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
                                              vertical: 16),
                                          itemBuilder: (context, index) {
                                            return SearchTagWidget(
                                                tag: _searchController
                                                    .searchTagList[index]);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 16,
                                            );
                                          },
                                          itemCount: _searchController
                                              .searchTagList.length),
                                    ),
                                  ),
                      ),
                      Obx(
                        () => _searchController.isSearchLoadingList[3].value
                            ? const LoadingWidget()
                            : _searchController.isSearchEmptyList[3].value ==
                                    true
                                ? const SearchEmptyWidget()
                                : Obx(
                                    () => SmartRefresher(
                                      physics: const BouncingScrollPhysics(),
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      controller: _searchController
                                          .refreshControllerList[3],
                                      footer: const MyCustomFooter(),
                                      onLoading:
                                          _searchController.onSearchLoading,
                                      child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          itemBuilder: (context, index) {
                                            return SearchUserWidget(
                                                user: _searchController
                                                    .searchCompanyList[index]);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 24,
                                            );
                                          },
                                          itemCount: _searchController
                                              .searchCompanyList.length),
                                    ),
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
