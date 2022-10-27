import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/retry.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/scout_search_focus_screen.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/contact_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:loopus/model/contact_model.dart';

import '../model/company_model.dart';

class ScoutScreen extends StatelessWidget {
  ScoutScreen({Key? key}) : super(key: key);
  final ScoutReportController _scontroller = Get.put(ScoutReportController());
  final PageController _pController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(
          () => Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: _scontroller.colors.isNotEmpty
                    ? _scontroller
                        .colors[_scontroller.curRcmdCompIndex.value].color
                    : mainWhite,
              ),
              elevation: 0,
              centerTitle: false,
              titleSpacing: 16,
              backgroundColor: _scontroller.colors.isNotEmpty
                  ? _scontroller
                      .colors[_scontroller.curRcmdCompIndex.value].color
                  : mainWhite,
              title: Row(
                children: [
                  Text(
                    '스카우트 중인 기업',
                    style: ktitle.copyWith(color: mainWhite),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/information.svg')
                ],
              ),
              excludeHeaderSemantics: false,
              actions: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.to(() => MyProfileScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: Obx(
                          () => UserImageWidget(
                            imageUrl:
                                HomeController.to.myProfile.value.profileImage,
                            height: 36,
                            width: 36,
                            userType:
                                HomeController.to.myProfile.value.userType,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            body: _scontroller.screenState.value == ScreenState.loading
                ? const Center(child: LoadingWidget())
                : Container(
                    color: _scontroller.colors.isNotEmpty
                        ? _scontroller
                            .colors[_scontroller.curRcmdCompIndex.value].color
                        : mainWhite,
                    child: SmartRefresher(
                      header: MyCustomHeader(),
                      enablePullUp: false,
                      enablePullDown: true,
                      controller: _scontroller.refreshController,
                      onRefresh: () {
                        _scontroller.refreshController.refreshCompleted();
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            companyRecImages(),
                            Expanded(
                              child: Container(
                                color: mainWhite,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: SearchTextFieldWidget(
                                        ontap: () {},
                                        hinttext: '검색',
                                        textInputAction: TextInputAction.search,
                                        readonly: false,
                                        autofocus: false,
                                        controller:
                                            _scontroller.searchCompController,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 50,
                                      child: TabBar(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        controller: _scontroller.tabController,
                                        indicatorColor: Colors.transparent,
                                        labelPadding: EdgeInsets.zero,
                                        labelColor: mainblack,
                                        labelStyle: ktitle,
                                        isScrollable: true,
                                        unselectedLabelColor: dividegray,
                                        tabs: List.from(
                                                _scontroller.careerField.values)
                                            .map((field) {
                                          if (field ==
                                              List.from(_scontroller
                                                      .careerField.values)
                                                  .last) {
                                            return _tabWidget(field,
                                                right: false);
                                          } else {
                                            return _tabWidget(field);
                                          }
                                        }).toList(),
                                        onTap: (index) {
                                          _scontroller.currentField.value =
                                              index;
                                          _scontroller.currentFieldMap({
                                            _scontroller
                                                    .careerFieldList[
                                                        _scontroller
                                                            .currentField.value]
                                                    .key:
                                                _scontroller
                                                    .careerFieldList[
                                                        _scontroller
                                                            .currentField.value]
                                                    .value
                                          });
                                        },
                                      ),
                                    ),
                                    // TabBarView(controller: _scontroller.tabController, children: [
                                    //   SizedBox(height: 20),
                                    //   ListView(
                                    //     scrollDirection: Axis.vertical,
                                    //     children: [CompanyFollowWidget(
                                    //       contact: _scontroller.getCompanyList())
                                    //     )],
                                    //   )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
          ),
        ));
  }

  Widget companyRecImages() {
    return Container(
      color: _scontroller.colors.isNotEmpty
          ? _scontroller.colors[_scontroller.curRcmdCompIndex.value].color
          : mainWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("당신에게 '집중'하고 있는 추천 기업",
                style: kmainbold.copyWith(color: mainWhite)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                _scontroller
                    .recommandCompList[_scontroller.curRcmdCompIndex.value]
                    .slogan,
                style: kNavigationTitle.copyWith(color: mainWhite)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                _scontroller
                    .recommandCompList[_scontroller.curRcmdCompIndex.value]
                    .name,
                style: kmainbold.copyWith(color: mainWhite)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: PageView(
              controller: _pController,
              onPageChanged: (index) {
                _scontroller.curRcmdCompIndex.value = index;
              },
              children: _scontroller.recommandCompList
                  .map((company) => Container(
                        width: 330,
                        height: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                              image: NetworkImage(company.images.first.image),
                              fit: BoxFit.cover),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _searchScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: 36,
            child: Row(children: [
              Expanded(
                child: SearchTextFieldWidget(
                  hinttext: '기업 검색',
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
            ]),
          ),
        )
      ],
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
}
