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
import 'package:loopus/screen/post_add_test.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/careerborad_post_widget.dart';
import 'package:loopus/widget/company_image_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../constant.dart';

class CareerBoardScreen extends StatelessWidget {
  final CareerBoardController _controller = Get.put(CareerBoardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
          child: Text(
            '커리어 보드',
            style: ktitle,
          ),
        ),
        excludeHeaderSemantics: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("ddd");
              },
              child: SvgPicture.asset(
                'assets/icons/Question_copy.svg',
              ),
            ),
          ),
        ],
        bottom: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          controller: _controller.tabController,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.zero,
          labelColor: mainblack,
          labelStyle: ktitle,
          isScrollable: true,
          unselectedLabelColor: dividegray,
          tabs: List.from(_controller.careerField.values).map((field) {
            if (field == List.from(_controller.careerField.values).last) {
              return _tabWidget(field, right: false);
            } else {
              return _tabWidget(field);
            }
          }).toList(),
          // onTap: (index) {
          //   controller.currentField.value = index;
          //   controller.currentFieldMap({
          //     controller
          //             .careerFieldList[controller.currentField.value].key:
          //         controller
          //             .careerFieldList[controller.currentField.value]
          //             .value
          //   });
          // },
        ),
      ),
      body: ScrollNoneffectWidget(
          child: TabBarView(
              controller: _controller.tabController,
              children: List.generate(
                  _controller.careerField.length,
                  (index) => tabViews(
                        _controller.careerFieldList[index],
                      )))),
    ));
  }

  Widget _tabWidget(String field, {bool right = true}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Tab(
            text: field,
          ),
          if (right)
            VerticalDivider(
              thickness: 1,
              width: 28,
              indent: 14,
              endIndent: 14,
              color: dividegray,
            )
        ],
      ),
    );
  }

  Widget tabViews(MapEntry<String, String> currentField) {
    return Obx(
      () => _controller.screenStateMap[currentField.key]!.value ==
              ScreenState.loading
          ? const LoadingWidget()
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
                          header: const MyCustomHeader(),
                          footer: const MyCustomFooter(),
                          onRefresh: _controller.onRefresh,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 24),
                                    child: Text(
                                      '${currentField.value} 분야 실시간 순위',
                                      style: k18semiBold,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 360,
                                    child: ScrollNoneffectWidget(
                                      child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return CareerRankWidget(
                                              isUniversity:
                                                  index == 0 ? true : false,
                                              ranker: index == 0
                                                  ? _controller.campusRankerMap[
                                                      currentField.key]!
                                                  : _controller
                                                      .koreaRankerMap[
                                                          currentField.key]!
                                                      .value,
                                              currentField: currentField,
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 14);
                                          },
                                          itemCount: 2),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      '${currentField.value} 분야 최근 인기 기업',
                                      style: k18semiBold,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 100,
                                    child: _controller
                                            .companyMap[currentField.key]!
                                            .isEmpty
                                        ? const Center(
                                            child: Text(
                                            "최근 인기 기업이 없습니다",
                                            style: kmain,
                                          ))
                                        : ScrollNoneffectWidget(
                                            child: ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return CompanyWidget(
                                                      company: _controller
                                                              .companyMap[
                                                          currentField
                                                              .key]![index]);
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      width: 14);
                                                },
                                                itemCount: _controller
                                                    .companyMap[
                                                        currentField.key]!
                                                    .length),
                                          ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child:
                                        Text('실시간 인기 포스트', style: k18semiBold),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 430,
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
                                                      horizontal: 20),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CareerBoardPostWidget(
                                                  post: _controller.popPostMap[
                                                      currentField.key]![index],
                                                );
                                              },
                                              itemCount: _controller
                                                  .popPostMap[currentField.key]!
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
                                  const SizedBox(height: 24),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child:
                                          Text('해시태그 분석', style: k18semiBold)),
                                  const SizedBox(height: 14),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
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
                                                    height: 14);
                                              },
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text('포스트 분석', style: k18semiBold),
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
                                            decoration: BoxDecoration(
                                                color: myPostColor)),
                                        const SizedBox(width: 4),
                                        Text('내 포스트 수',
                                            style: k13midum.copyWith(
                                                color: myPostColor)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, bottom: 34),
                                    child: Container(
                                      height: 172,
                                      width: 295,
                                      child: Obx(
                                        () => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children:
                                                _controller
                                                    .postUsageTrendNum.entries
                                                    .map((e) => Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(_controller.postGraphMap[currentField
                                                                            .key
                                                                            .toString()]![
                                                                        'teptNumMap'] !=
                                                                    null
                                                                ? _controller
                                                                    .postGraphMap[
                                                                        currentField
                                                                            .key
                                                                            .toString()]![
                                                                        'teptNumMap']![
                                                                        e.key]!
                                                                    .toInt()
                                                                    .toString()
                                                                : _controller
                                                                    .teptNumMap[
                                                                        e.key]!
                                                                    .toInt()
                                                                    .toString()),
                                                            const SizedBox(
                                                                height: 3),
                                                            AnimatedSize(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                child:
                                                                    Container(
                                                                  height: _controller.postGraphMap[currentField.key.toString()]![
                                                                              'postUsageTrendNum'] !=
                                                                          null
                                                                      ? _controller
                                                                          .postGraphMap[
                                                                              currentField.key.toString()]![
                                                                              'postUsageTrendNum']![
                                                                              e
                                                                                  .key]!
                                                                          .toDouble()
                                                                      : _controller
                                                                              .postUsageTrendNum[
                                                                          e.key],
                                                                  width: 20,
                                                                  decoration: const BoxDecoration(
                                                                      color:
                                                                          mainblue,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              16),
                                                                          topRight:
                                                                              Radius.circular(16))),
                                                                )),
                                                            const SizedBox(
                                                                height: 12),
                                                            Text(
                                                              '${e.key}월',
                                                              style:
                                                                  kButtonStyle,
                                                            )
                                                          ],
                                                        ))
                                                    .toList()),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
    );
  }

  // Widget topPost(Post post) {

  // }

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
