import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/paper_controller.dart';
import 'package:loopus/widget/paper_competition_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class PaperScreen extends StatelessWidget {
  // const BookmarkScreen({Key? key}) : super(key: key);
  PaperController paperController = Get.put(PaperController());
  ModalController _modalController = Get.put(ModalController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: const Text(
            '추천 공고',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  _modalController.showCustomDialog(
                      '관심 태그와 학과를 기반으로 공고를 추천해드리고 있어요', 2);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: Center(
                    child: Text(
                      "어떻게 추천되나요?",
                      style: TextStyle(
                          color: mainblue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Theme(
                          data: ThemeData().copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: TabBar(
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
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              isScrollable: true,
                              indicatorColor: mainblack,
                              tabs: [
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "대외활동",
                                  ),
                                ),
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "공모전",
                                  ),
                                ),
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "인턴쉽",
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffe7e7e7),
                    )
                  ],
                ),
              ),
              // SliverToBoxAdapter(child: de\,)
            ];
          },
          body: TabBarView(physics: PageScrollPhysics(), children: [
            SingleChildScrollView(
              key: const PageStorageKey("key1"),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 80,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: PaperController.to.posting,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              key: const PageStorageKey("key2"),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 80,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: PaperController.to.posting,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 80,
              ),
              child: SingleChildScrollView(
                key: const PageStorageKey("key3"),
                child: Column(
                  children: PaperController.to.posting_internship,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
