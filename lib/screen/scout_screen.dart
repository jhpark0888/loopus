import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/retry.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/scout_comp_all_screen.dart';
import 'package:loopus/screen/scout_search_focus_screen.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/widget/Link_widget.dart';
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

import '../model/company_model.dart';

class ScoutScreen extends StatelessWidget {
  ScoutScreen({Key? key}) : super(key: key);
  final ScoutReportController _scontroller = Get.put(ScoutReportController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(
          () => Stack(
            children: [
              Container(
                height: 250,
                color: _scontroller.colors.isNotEmpty
                    ? _scontroller
                        .colors[_scontroller.curRcmdCompIndex.value].color
                    : mainblue,
              ),
              Scaffold(
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: _scontroller.colors.isNotEmpty
                        ? _scontroller
                            .colors[_scontroller.curRcmdCompIndex.value].color
                        : mainblue,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.light,
                  ),
                  elevation: 0,
                  centerTitle: false,
                  titleSpacing: 16,
                  backgroundColor: _scontroller.colors.isNotEmpty
                      ? _scontroller
                          .colors[_scontroller.curRcmdCompIndex.value].color
                      : mainblue,
                  title: Row(
                    children: [
                      Text(
                        '스카우트 중인 기업',
                        style: ktitle.copyWith(color: mainWhite),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                          height: 16,
                          width: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                              onPressed: () {
                                showPopUpDialog(
                                    '스카우트 중인 기업',
                                    '채용을 진행중이거나\n루프어스에서 활동중인 기업 정보를 보여줘요\n수많은 기업의 정보를 확인하고,\n본인만의 커리어를 통해\n채용의 기회를 얻어보세요',
                                    3000);
                              },
                              icon: SvgPicture.asset(
                                  'assets/icons/information.svg')))
                    ],
                  ),
                  excludeHeaderSemantics: false,
                  actions: [
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          HomeController.to.goMyProfile();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
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
                        )),
                  ],
                ),
                backgroundColor: Colors.transparent,
                body: _scontroller.screenState.value == ScreenState.loading
                    ? const Center(child: LoadingWidget())
                    : SmartRefresher(
                        primary: false,
                        header: MyCustomHeader(
                          color: _scontroller.colors.isNotEmpty
                              ? _scontroller
                                  .colors[_scontroller.curRcmdCompIndex.value]
                                  .color
                              : mainblue,
                        ),
                        footer: const MyCustomFooter(),
                        enablePullUp: true,
                        enablePullDown: true,
                        controller: _scontroller.refreshController,
                        onRefresh: () => _scontroller.onRefresh(),
                        onLoading: () => _scontroller.onLoading(),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                companyRecImages(),
                                Container(
                                  color: mainWhite,
                                  child: ListView.separated(
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 24),
                                    itemBuilder: (context, index) {
                                      if (_scontroller
                                          .companyFieldList[index].isEmpty) {
                                        return Container();
                                      }
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Row(
                                              children: [
                                                Text(
                                                  fieldList[_scontroller
                                                      .fieldIdList[index]]!,
                                                  style: kmainbold,
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => ScoutFieldCompScreen(
                                                        fieldId: _scontroller
                                                            .fieldIdList[index],
                                                        companyList: _scontroller
                                                            .companyFieldList[
                                                                index]
                                                            .obs));
                                                  },
                                                  child: Text(
                                                    "전체보기",
                                                    style: kmain.copyWith(
                                                        color: mainblue),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          SizedBox(
                                            width: Get.width,
                                            height: 216,
                                            child: ListView.separated(
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                itemBuilder: (context,
                                                        compIndex) =>
                                                    SizedBox(
                                                      width: 300,
                                                      height: 216,
                                                      child: CompanyWidget(
                                                          company: _scontroller
                                                                  .companyFieldList[
                                                              index][compIndex]),
                                                    ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                itemCount: _scontroller
                                                    .companyFieldList[index]
                                                    .length),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      if (_scontroller
                                          .companyFieldList[index].isEmpty) {
                                        return Container();
                                      }
                                      return const SizedBox(height: 32);
                                    },
                                    itemCount:
                                        _scontroller.companyFieldList.length,
                                  ),
                                ),
                              ]),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget companyRecImages() {
    return Container(
      color: _scontroller.colors.isNotEmpty
          ? _scontroller.colors[_scontroller.curRcmdCompIndex.value].color
          : mainblue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Text(
                  _scontroller.isCorp.value == 1
                      ? "유저님의 기업과 유사한 다른 기업"
                      : "당신에게 '집중'하고 있는 추천 기업",
                  style: kmainbold.copyWith(color: mainWhite)),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                _scontroller.recommendCompList.isNotEmpty
                    ? _scontroller
                        .recommendCompList[_scontroller.curRcmdCompIndex.value]
                        .slogan
                        .replaceAll('\r\n', " ")
                    : "",
                overflow: TextOverflow.ellipsis,
                style: kNavigationTitle.copyWith(color: mainWhite)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                _scontroller.recommendCompList.isNotEmpty
                    ? _scontroller
                        .recommendCompList[_scontroller.curRcmdCompIndex.value]
                        .name
                    : "",
                maxLines: 1,
                style: kmainbold.copyWith(color: mainWhite)),
          ),
          const SizedBox(height: 16),
          Obx(
            () => SizedBox(
              height: 120,
              child: _scontroller.recommendCompList.isNotEmpty
                  ? PageView.builder(
                      controller: _scontroller.pController,
                      onPageChanged: (index) {
                        _scontroller.curRcmdCompIndex.value =
                            index % _scontroller.recommendCompList.length;
                      },
                      itemBuilder: (context, index) {
                        int compIndex =
                            index % _scontroller.recommendCompList.length;
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                                () => OtherCompanyScreen(
                                      companyId: _scontroller
                                          .recommendCompList[compIndex].userId,
                                      companyName: _scontroller
                                          .recommendCompList[compIndex].name,
                                      company: _scontroller
                                          .recommendCompList[compIndex],
                                    ),
                                preventDuplicates: false);
                          },
                          child: Container(
                            width: 330,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: _scontroller
                                  .recommendCompList[compIndex]
                                  .images
                                  .first
                                  .image,
                              fit: BoxFit.cover,
                              errorWidget: (context, string, widget) {
                                return Container(
                                  color: maingray,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: mainblue,
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
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
}
