import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/contact_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScoutScreen extends StatelessWidget {
  ScoutScreen({Key? key}) : super(key: key);

  final ScoutReportController _controller = Get.put(ScoutReportController());

  // Widget _scoutCompany() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(
  //         height: 24,
  //       ),
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Text(
  //           "스카우트 중인 기업",
  //           style: kmainbold,
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 14,
  //       ),
  //       SizedBox(
  //         height: 100,
  //         child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             shrinkWrap: true,
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             itemBuilder: (context, index) {
  //               return CompanyWidget(company: _controller.companyList[index]);
  //             },
  //             separatorBuilder: (context, index) {
  //               return const SizedBox(
  //                 width: 14,
  //               );
  //             },
  //             itemCount: _controller.companyList.length),
  //       ),
  //       const SizedBox(
  //         height: 24,
  //       ),
  //     ],
  //   );
  // }

  // Widget _scouterContact() {
  //   return Column(
  //     children: [
  //       const SizedBox(
  //         height: 12,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Row(
  //           children: [
  //             const Text(
  //               "스카우트 컨택",
  //               style: kmainbold,
  //             ),
  //             const Spacer(),
  //             GestureDetector(
  //               onTap: () {},
  //               child: SvgPicture.asset(
  //                 "assets/icons/search_inactive.svg",
  //                 width: 20,
  //                 height: 20,
  //                 color: mainblack,
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 24,
  //       ),
  //       Obx(
  //         () => ListView.separated(
  //             primary: false,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return ContactWidget(contact: _controller.contactList[index]);
  //             },
  //             separatorBuilder: (context, index) => DivideWidget(
  //                   height: 24,
  //                 ),
  //             itemCount: _controller.contactList.length),
  //       ),
  //       const SizedBox(
  //         height: 12,
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              titleSpacing: 20,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 14),
                child: Row(
                  children: [
                    const Text(
                      '스카우트 리포트',
                      style: ktitle,
                    ),
                    const SizedBox(width: 7),
                    SvgPicture.asset('assets/icons/information.svg')
                  ],
                ),
              ),
              excludeHeaderSemantics: false,
              actions: [
                Stack(children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => HomeController.to.goMyProfile(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Center(
                          child: Obx(
                            () => UserImageWidget(
                              imageUrl: HomeController
                                  .to.myProfile.value.profileImage,
                              height: 36,
                              width: 36,
                              userType:
                                  HomeController.to.myProfile.value.userType,
                            ),
                          ),
                        ),
                      ))
                ]),
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
                children: List.generate(_controller.careerField.length,
                    (index) => tabViews(_controller.careerFieldList[index])),
              ),
            )),
      ),
    );
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

  Widget _searchView(MapEntry<String, String> currentField) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: SearchTextFieldWidget(
                      ontap: () {},
                      hinttext: "기업 이름을 검색하세요",
                      readonly: false,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {},
                      controller: _controller.searchContactController),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: GestureDetector(
                    onTap: () {
                      _controller.isSearchFocusMap[currentField.key]!(false);
                      _controller.searchContactController.clear();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: Center(
                        child: Text(
                          '취소',
                          style: kmain.copyWith(color: mainblue),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_controller.isSearchLoading.value == true)
            const LoadingWidget()
          else if (_controller.searchContactMap[currentField.key]!.isEmpty &&
              _controller.searchContactController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                  child: Text(
                "'${_controller.searchContactController.text}' 검색 결과가 없습니다",
                style: kmain,
              )),
            )
          else
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ContactWidget(
                      contact: _controller
                          .searchContactMap[currentField.key]![index]);
                },
                separatorBuilder: (context, index) => DivideWidget(
                      height: 24,
                    ),
                itemCount:
                    _controller.searchContactMap[currentField.key]!.length),
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
                      // _controller.careerBoardLoad(currentField.key);
                    })
                  : _controller.screenStateMap[currentField.key]!.value ==
                          ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          // _controller.careerBoardLoad(currentField.key);
                        })
                      : Obx(
                          () => _controller.isSearchFocusMap[currentField.key]!
                                      .value ==
                                  true
                              ? _searchView(currentField)
                              : SmartRefresher(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _controller
                                      .refreshControllerMap[currentField.key]!,
                                  header: const MyCustomHeader(),
                                  footer: const MyCustomFooter(),
                                  onRefresh: _controller.onRefresh,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 24),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            '스카우트 중인 기업',
                                            style: kmainbold,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        SizedBox(
                                          height: 100,
                                          child: _controller
                                                  .companyMap[currentField.key]!
                                                  .isEmpty
                                              ? Center(
                                                  child: Text(
                                                  "${currentField.value} 분야 스카우트 중인 기업이 없습니다",
                                                  style: kmain,
                                                ))
                                              : ScrollNoneffectWidget(
                                                  child: ListView.separated(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
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
                                        const SizedBox(height: 26),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "스카우트 컨택",
                                                style: kmainbold,
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  _controller.isSearchFocusMap[
                                                      currentField.key]!(true);
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/search_inactive.svg",
                                                  width: 20,
                                                  height: 20,
                                                  color: mainblack,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 26),
                                        if (_controller
                                            .companyMap[currentField.key]!
                                            .isEmpty)
                                          Center(
                                              child: Text(
                                            "${currentField.value} 분야 스카우트 컨택이 없습니다",
                                            style: kmain,
                                          ))
                                        else
                                          ListView.separated(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return ContactWidget(
                                                    contact:
                                                        _controller.contactMap[
                                                            currentField
                                                                .key]![index]);
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      DivideWidget(
                                                        height: 24,
                                                      ),
                                              itemCount: _controller
                                                  .contactMap[currentField.key]!
                                                  .length),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
    );
  }
}
