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
import 'package:loopus/widget/company_image_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/contact_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:palette_generator/palette_generator.dart';

import '../model/company_model.dart';

class ScoutScreen extends StatelessWidget {
  ScoutScreen({Key? key}) : super(key: key);

  final ScoutReportController _controller = Get.put(ScoutReportController());
  // final List<String> images = [
  //   'images/pic1.png',
  //   'images/pic3.png',
  //   'images/pic4.png',
  //   'images/pic5.png',
  //   'images/pic6.png',
  //   'image/pic7.png'
  // ];
  // late List<PaletteColor> colors;
  // late int _currentIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   colors = [];
  //   _currentIndex = 0;
  //   _updatePalettes();
  // }

  // _updatePalettes() async {
  //   for (String image in images) {
  //     final PaletteGenerator generator =
  //         await PaletteGenerator.fromImageProvider(
  //       AssetImage(image),
  //       size: Size(200, 100),
  //     );
  //     colors.add(generator.lightMutedColor ?? PaletteColor(Colors.blue, 2));
  //   }
  //   setState(() {});
  // }

  // final _controller = PageController(viewportFraction: 0.7);

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
                  hinttext: '지역 또는 직무별 검색',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutSearchFocusScreen()));
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

  // Widget _scoutReport(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Positioned(
  //           child: Container(width: 375, height: 200, color: maingray), top: 0),
  //       Positioned(
  //           child: ListView.separated(
  //               itemBuilder: (context, index) {
  //                 return Container(width: 321, height: 120);
  //               },
  //               separatorBuilder: (context, index) {
  //                 return const SizedBox(
  //                   width: 14,
  //                 );
  //               },
  //               itemCount: 10)),
  //       SizedBox(
  //         height: 14,
  //       )
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
          // backgroundColor: colors.isNotEmpty
          //     ? colors[_currentIndex].color
          //     : Theme.of(context).primaryColor,
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
                            imageUrl: HomeController
                                    .to.myProfile.value.profileImage ??
                                "",
                            height: 36,
                            width: 36),
                      ),
                    ),
                  ))
            ]),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  color: Colors.blue,
                  height: 200,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(color: Colors.white
                          // colors.isNotEmpty
                          //     ? colors[_currentIndex].color
                          //     : Colors.white
                          ),
                      Positioned(
                          top: 113,
                          child: SizedBox(
                            width: 375,
                            height: 120,
                            child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 321,
                                    child: Card(
                                        elevation: 3,
                                        child: Image.network(
                                            'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_960_720.jpg')),
                                  );
                                }),
                          ))
                    ],
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  _searchScreen(
                    context,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "환경을 생각한다면",
                      style: kmainbold,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CompanyFollowWidget(
                    company: Company(
                      companyImage: 'images/pic1.png',
                      contactField: 'It, 컨텐츠',
                      companyName: '당근마켓',
                      id: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
