import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class SearchTagDetailScreen extends StatelessWidget {
  ModalController _modalController = Get.find();
  SearchController searchController = Get.find();
  String title;
  var count;
  SearchTagDetailScreen({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBarWidget(
            title: "$title",
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            "$title",
                            style: kHeaderH2Style,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "관심도 $count ",
                                style: kSubTitle4Style.copyWith(
                                  fontSize: 16,
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _modalController.showCustomDialog(
                                      '관심도는 어찌어찌 된 것이요.', 1);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/Question.svg',
                                  width: 20,
                                  height: 20,
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 17.5),
                        AppBar(
                          automaticallyImplyLeading: false,
                          toolbarHeight: 43,
                          elevation: 0,
                          flexibleSpace: Theme(
                            data: ThemeData().copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: TabBar(
                              controller: searchController.tagtabController,
                              labelStyle: TextStyle(
                                color: mainblack,
                                fontSize: 14,
                                fontFamily: 'Nanum',
                                fontWeight: FontWeight.bold,
                              ),
                              labelColor: mainblack,
                              unselectedLabelStyle: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                                fontFamily: 'Nanum',
                                fontWeight: FontWeight.normal,
                              ),
                              unselectedLabelColor: mainblack.withOpacity(0.6),
                              indicator: UnderlineIndicator(
                                strokeCap: StrokeCap.round,
                                borderSide: BorderSide(width: 2),
                              ),
                              indicatorColor: mainblack,
                              tabs: [
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "활동",
                                  ),
                                ),
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "질문",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
                controller: searchController.tagtabController,
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: searchController.searchtagprojectlist.value,
                  )),
                  SingleChildScrollView(
                      child: Column(
                    children: searchController.searchtagquestionlist.value,
                  ))
                ]),
          ),
        ));
  }
}
