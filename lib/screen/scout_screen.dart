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
  PageController _pController =
      PageController(viewportFraction: 0.7, initialPage: 0);

  RxList<String> images = <String>[].obs;
  RxList<PaletteColor> colors = <PaletteColor>[].obs;
  RxInt _currentIndex = 0.obs;

  _updatePalettes() async {
    for (String image in images) {
      final PaletteGenerator generator =
          await PaletteGenerator.fromImageProvider(
        AssetImage(image),
        size: Size(200, 100),
      );
      colors.add(generator.lightMutedColor ?? PaletteColor(Colors.blue, 2));
    }
  }

  Widget companyRecImages(Contact contact) {
    List<String> images = _scontroller.recommandCompList
        .map((company) => company.companyImage)
        .toList();
    // print(images);
    // print(contact!.recommendation);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: colors.isNotEmpty
              ? colors[_currentIndex.value].color
              : Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 70,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  child: Obx(
                    () => PageView(
                      controller: _pController,
                      onPageChanged: (index) {
                        _currentIndex.value = index;
                      },
                      children: images
                          .map((image) => Container(
                                width: 321,
                                height: 120,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                      image: AssetImage(image),
                                      fit: BoxFit.cover),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colors.isNotEmpty
                  ? colors[_currentIndex.value].color
                  : Theme.of(context).primaryColor,
            ),
            elevation: 0,
            centerTitle: false,
            titleSpacing: 20,
            backgroundColor: colors.isNotEmpty
                ? colors[_currentIndex.value].color
                : Theme.of(context).primaryColor,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
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
                    onTap: () {
                      Get.to(() => MyProfileScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
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
                    ))
              ]),
            ],
          ),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 14),
            Text(_scontroller.recommandCompList[_currentIndex.value].slogan),
            Text("당신에게 '집-중'하고 있는 추천 기업",
                style: kmainbold.copyWith(color: mainWhite)),
            const SizedBox(height: 14),
            Text(_scontroller.recommandCompList[_currentIndex.value].slogan,
                style: kNavigationTitle.copyWith(color: mainWhite)),
            const SizedBox(height: 14),
            Text(
                _scontroller
                    .recommandCompList[_currentIndex.value].recommendation,
                style: kmain.copyWith(color: mainWhite)),
            const SizedBox(height: 24),
            companyRecImages(_scontroller.recommandCompList.first),
            const SizedBox(height: 24),
            _searchScreen(context),
            const SizedBox(height: 14.5),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              child: TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                controller: _scontroller.tabController,
                indicatorColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                labelColor: mainblack,
                labelStyle: ktitle,
                isScrollable: true,
                unselectedLabelColor: dividegray,
                tabs: List.from(_scontroller.careerField.values).map((field) {
                  if (field ==
                      List.from(_scontroller.careerField.values).last) {
                    return _tabWidget(field, right: false);
                  } else {
                    return _tabWidget(field);
                  }
                }).toList(),
                onTap: (index) {
                  _scontroller.currentField.value = index;
                  _scontroller.currentFieldMap({
                    _scontroller
                            .careerFieldList[_scontroller.currentField.value]
                            .key:
                        _scontroller
                            .careerFieldList[_scontroller.currentField.value]
                            .value
                  });
                },
              ),
            ),
            // TabBarView(controller: _scontroller.tabController, children: [
            //   SizedBox(height: 20),
            //   ListView(
            //     scrollDirection: Axis.vertical,
            //     children: [CompanyListWidget(
            //       contact: _scontroller. , user: , isFollow: true,)
            //     )],
            //   )
          ]),
        ));
  }
}

// @override
// void initState() {
//   super.initState();
//   colors = [];
//   _currentIndex = 0;
//   _updatePalettes();
// }

// TabBarView(
//                 controller: _controller.tabController,
//                 children: List.generate(_controller.careerField.length,
//                     (index) => tabViews(_controller.careerFieldList[index])),
//               ),
// Widget tabViews(MapEntry<String, String> currentField) {
//   return Obx(() => Container(
//         width: 100,
//         height: 100,
//         color: Colors.blue,
//       ));
// }

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
