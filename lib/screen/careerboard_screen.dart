import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/realtime_rank_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/careerborad_post_widget.dart';
import 'package:loopus/trash_bin/company_image_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/hot_user_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../constant.dart';

class CareerBoardScreen extends StatelessWidget {
  final CareerBoardController _controller = Get.put(CareerBoardController());

  late bool isUniversity = false;

  @override
  Widget build(BuildContext context) {
    print(_controller.careerFieldList);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 14),
          child: Row(
            children: [
              const Text(
                '커리어 보드',
                style: ktitle,
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 16,
                width: 16,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showPopUpDialog(
                        '커리어보드',
                        '루프어스에서 집계하는 점수를 통해\n커리어 상위권 프로필을 보여줘요\n최근 발전하고 있는 프로필과\n인기 포스트 등을 확인할 수 있어요',
                      );
                    },
                    icon: SvgPicture.asset('assets/icons/information.svg')),
              )
            ],
          ),
        ),
        excludeHeaderSemantics: false,
        actions: [
          Center(
            child: Stack(children: [
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => HomeController.to.goMyProfile(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Obx(
                        () => UserImageWidget(
                          imageUrl:
                              HomeController.to.myProfile.value.profileImage,
                          height: 36,
                          width: 36,
                          userType: HomeController.to.myProfile.value.userType,
                        ),
                      ),
                    ),
                  ))
            ]),
          ),
        ],
        // bottom:
        // TabBar(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   controller: _controller.tabController,
        //   indicatorColor: Colors.transparent,
        //   labelPadding: EdgeInsets.zero,
        //   labelColor: mainblack,
        //   labelStyle: ktitle,
        //   isScrollable: true,
        //   unselectedLabelColor: dividegray,
        //   tabs: List.from(_controller.careerField.values).map((field) {
        //     if (field == List.from(_controller.careerField.values).last) {
        //       return _tabWidget(field, right: false);
        //     } else {
        //       return _tabWidget(field);
        //     }
        //   }).toList(),
        //   // onTap: (index) {
        //   //   controller.currentField.value = index;
        //   //   controller.currentFieldMap({
        //   //     controller
        //   //             .careerFieldList[controller.currentField.value].key:
        //   //         controller
        //   //             .careerFieldList[controller.currentField.value]
        //   //             .value
        //   //   });
        //   // },
        // ),
      ),
      body: tabViews(context, _controller.careerFieldList.last),
    );
  }

  // Widget _tabWidget(String field, {bool right = true}) {
  //   return IntrinsicHeight(
  //     child: Row(
  //       children: [
  //         Tab(
  //           text: field,
  //         ),
  //         if (right)
  //           VerticalDivider(
  //             thickness: 1,
  //             width: 28,
  //             indent: 14,
  //             endIndent: 14,
  //             color: dividegray,
  //           )
  //       ],
  //     ),
  //   );
  // }

  Widget tabViews(BuildContext context, MapEntry<String, String> currentField) {
    return Obx(
      () => _controller.screenStateMap[currentField.key]!.value ==
              ScreenState.loading
          ? const Center(child: LoadingWidget())
          : _controller.screenStateMap[currentField.key]!.value ==
                  ScreenState.normal
              ? Container()
              : _controller.screenStateMap[currentField.key]!.value ==
                      ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      _controller.careerBoardLoad(currentField.key);
                    })
                  : _controller.screenStateMap[currentField.key]!.value ==
                          ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          _controller.careerBoardLoad(currentField.key);
                        })
                      : SmartRefresher(
                          physics: const BouncingScrollPhysics(),
                          controller: _controller
                              .refreshControllerMap[currentField.key]!,
                          header: MyCustomHeader(),
                          footer: const MyCustomFooter(),
                          onRefresh: _controller.onRefresh,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text(
                                          '실시간 커리어 순위',
                                          style: kmainbold,
                                          textAlign: TextAlign.start,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Get.to(() => RealTimeRankScreen(
                                                    currentField: currentField,
                                                    isUniversity: isUniversity,
                                                  ));
                                            },
                                            child: Text('전체보기',
                                                style: kmain.copyWith(
                                                    color: mainblue))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                      height: 276,
                                      child: CareerRankWidget(
                                        isUniversity: false,
                                        ranker: _controller
                                            .koreaRankerMap[currentField.key]!,
                                        currentField: currentField,
                                      )),
                                  const SizedBox(height: 16),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 16),
                                  //   child: Text(
                                  //     '${currentField.value} 분야 최근 인기 기업',
                                  //     style: kmainbold,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 14),
                                  // SizedBox(
                                  //   height: 100,
                                  //   child: _controller
                                  //           .companyMap[currentField.key]!
                                  //           .isEmpty
                                  //       ? const Center(
                                  //           child: Text(
                                  //           "최근 인기 기업이 없습니다",
                                  //           style: kmain,
                                  //         ))
                                  //       : ScrollNoneffectWidget(
                                  //           child: ListView.separated(
                                  //               padding:
                                  //                   const EdgeInsets.symmetric(
                                  //                       horizontal: 20),
                                  //               scrollDirection:
                                  //                   Axis.horizontal,
                                  //               itemBuilder: (context, index) {
                                  //                 return CompanyWidget(
                                  //                     company: _controller
                                  //                             .companyMap[
                                  //                         currentField
                                  //                             .key]![index]);
                                  //               },
                                  //               separatorBuilder:
                                  //                   (context, index) {
                                  //                 return const SizedBox(
                                  //                     width: 14);
                                  //               },
                                  //               itemCount: _controller
                                  //                   .companyMap[
                                  //                       currentField.key]!
                                  //                   .length),
                                  //         ),
                                  // ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text('성장 중인 친구들을 만나보세요',
                                        style: kmainbold),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Obx(
                                    () => ScrollNoneffectWidget(
                                      child: SizedBox(
                                        height: 95,
                                        child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return HotUserWidget(
                                                  person: _controller
                                                          .hotUserListMap[
                                                      currentField
                                                          .key]![index]);
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(width: 10);
                                            },
                                            itemCount: _controller
                                                .hotUserListMap[
                                                    currentField.key]!
                                                .length),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 32,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text('실시간 인기 포스트', style: kmainbold),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => SizedBox(
                                      height: 398,
                                      child: _controller
                                              .popPostMap[currentField.key]!
                                              .isEmpty
                                          ? const Center(
                                              child: Text(
                                              "실시간 포스트가 없습니다",
                                              style: kmain,
                                            ))
                                          : ScrollNoneffectWidget(
                                              child: ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return CareerBoardPostWidget(
                                                    post:
                                                        _controller.popPostMap[
                                                            currentField
                                                                .key]![index],
                                                  );
                                                },
                                                itemCount: _controller
                                                    .popPostMap[
                                                        currentField.key]!
                                                    .length,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const SizedBox(
                                                      width: 14);
                                                },
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  const Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text('인기있는 태그',
                                          // ${currentField.value}분야
                                          style: kmainbold)),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Obx(
                                      () => _controller
                                              .topTagMap[currentField.key]!
                                              .isEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              child: Center(
                                                  child: Text(
                                                "최근 해시태그 분석이 없습니다",
                                                style: kmain,
                                              )),
                                            )
                                          : ListView.separated(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: _controller
                                                  .topTagMap[currentField.key]!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return tagAnalize(
                                                    _controller.topTagMap[
                                                        currentField
                                                            .key]![index],
                                                    index + 1);
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                    height: 16);
                                              },
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ]),
                          ),
                        ),
    );
  }

  // Widget topPost(Post post) {

  // }
  Widget _postAnalysis(MapEntry<String, String> currentField) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text('포스트 분석', style: kmainbold),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.only(right: 46),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                width: 20,
                height: 1,
                decoration: BoxDecoration(color: myPostColor)),
            const SizedBox(width: 4),
            Text('내 포스트 수', style: ktempFont.copyWith(color: myPostColor)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 34),
        child: Container(
          height: 172,
          width: 295,
          child: Obx(
            () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _controller.postUsageTrendNum.entries
                    .map((e) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_controller.postGraphMap[currentField.key
                                        .toString()]!['teptNumMap'] !=
                                    null
                                ? _controller.postGraphMap[currentField.key
                                        .toString()]!['teptNumMap']![e.key]!
                                    .toInt()
                                    .toString()
                                : _controller.teptNumMap[e.key]!
                                    .toInt()
                                    .toString()),
                            const SizedBox(height: 3),
                            AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  height: _controller.postGraphMap[
                                                  currentField.key.toString()]![
                                              'postUsageTrendNum'] !=
                                          null
                                      ? _controller.postGraphMap[
                                              currentField.key.toString()]![
                                              'postUsageTrendNum']![e.key]!
                                          .toDouble()
                                      : _controller.postUsageTrendNum[e.key],
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: mainblue,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16))),
                                )),
                            const SizedBox(height: 12),
                            Text(
                              '${e.key}월',
                              style: ktempFont,
                            )
                          ],
                        ))
                    .toList()),
          ),
        ),
      )
    ]);
  }

  Widget tagAnalize(Tag tag, int index) {
    return Row(children: [
      Text(
        index.toString(),
        style: kmainbold,
      ),
      const SizedBox(width: 14),
      Tagwidget(tag: tag),
      const Spacer(),
      Text(
        '${tag.count.toString()}회',
        style: kmain,
      )
    ]);
  }
}
