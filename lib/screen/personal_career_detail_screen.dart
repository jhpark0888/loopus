import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';

class PersonalCareerDetailScreen extends StatelessWidget {
  PersonalCareerDetailScreen(
      {Key? key, required this.career, required this.name})
      : super(key: key);
  late CareerDetailController careerDetailController;
  String name;
  Project career;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    careerDetailController =
        Get.put(CareerDetailController(career: Rx(career)));
    // copyList = careerList;
    return Scaffold(
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
                child: Container(
                  color: Color(0xffe7e7e7),
                  height: 1,
                ),
                preferredSize: Size.fromHeight(4.0)),
            automaticallyImplyLeading: false,
            toolbarHeight: 48,
            elevation: 0,
            stretch: true,
            backgroundColor: Colors.white,
            leading: _leading(leading: true),
            actions: [
              _leading(
                leading: false,
                career: careerDetailController.career.value,
              )
            ],
            pinned: true,
            flexibleSpace: _MyAppSpace(
              career: careerDetailController.career,
            ),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 20),
                    child: Row(
                      children: [
                        CustomPieChart(
                          career: career,
                          // careerList: careerList,
                          currentId: career.id,
                        ),
                        const SizedBox(width: 32),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'IT 분야',
                                  style: kmainbold.copyWith(color: mainblue)),
                              const TextSpan(text: '커리어', style: kmainbold)
                            ])),
                            const SizedBox(height: 14),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '$name님의 전체 커리어 중\n',
                                  style: kmainheight),
                              TextSpan(
                                  text: '${career.postRatio! * 100}%',
                                  style: kmainbold),
                              const TextSpan(
                                  text: '를 차지하는 커리어에요', style: kmainheight)
                            ])),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 0.5,
                        color: dividegray,
                      )),
                  // const SizedBox(height: 24),
                  Obx(() => careerDetailController.postList.isNotEmpty
                      ? ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, postindex) {
                            return PostingWidget(
                              item: careerDetailController.postList[postindex],
                              type: PostingWidgetType.profile,
                            );
                          },
                          separatorBuilder: (context, postindex) =>
                              DivideWidget(),
                          itemCount: careerDetailController.postList.length,
                        )
                      : GestureDetector(
                          onTap: () {
                            Get.to(() => PostingAddScreen(
                                  project_id: career.id,
                                  route: PostaddRoute.career,
                                ));
                          },
                          child: EmptyPostWidget(
                            id: career.id,
                          )))
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class EmptyPostWidget extends StatelessWidget {
  EmptyPostWidget({Key? key, required this.id}) : super(key: key);
  int id;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset('assets/icons/career_post_add.svg'),
      const SizedBox(width: 7),
      Text(
        '지금 바로 새로운 포스트를 작성해보세요',
        style: kmainbold.copyWith(color: mainblue),
      )
    ]);
  }
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({Key? key, required this.career}) : super(key: key);
  Rx<Project> career;
  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity1 = 1.0 - Interval(0.0, 0.75).transform(t);
        final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        return Obx(
          () => Stack(
            children: [
              SafeArea(
                child: Center(
                  child: Opacity(
                    opacity: 1 - opacity2,
                    child: getCollapseTitle(
                      career.value.careerName,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: opacity1,
                child: Hero(
                  tag: career.value.id.toString(),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: career.value.thumbnail == ""
                                ? const AssetImage(
                                    'assets/illustrations/default_image.png')
                                : NetworkImage(career.value.thumbnail)
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                const Color(0x00000000).withOpacity(0.4),
                                BlendMode.srcOver))),
                    width: Get.width,
                    height: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 58, 20, 14),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 44),
                            const SizedBox(height: 16),
                            getExpendTitle(
                              career.value.careerName,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (career.value.updateDate != null)
                              Text(
                                '최근 포스트 ${calculateDate(career.value.updateDate!)}',
                                style: kNavigationTitle.copyWith(
                                    color: selectimage),
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/single_career.svg'),
                                const SizedBox(width: 8),
                                Text('개인 커리어',
                                    style: kNavigationTitle.copyWith(
                                        color: selectimage)),
                                const Spacer(),
                                Text(
                                  '포스트 ${career.value.post_count}',
                                  style: kNavigationTitle.copyWith(
                                      color: selectimage),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget getImage(BuildContext context, String? thumbnail) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Opacity(
        opacity: thumbnail != '' ? 0.25 : 1,
        child: thumbnail != ''
            ? Hero(
                tag: career.value.id.toString(),
                child: Image.network(
                  thumbnail!,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                "assets/illustrations/default_image.png",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget getExpendTitle(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: kNavigationTitle.copyWith(color: mainWhite));
  }

  Widget getCollapseTitle(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: kNavigationTitle);
  }
}

class _leading extends StatelessWidget {
  _leading({Key? key, required this.leading, this.career}) : super(key: key);
  bool leading;
  Project? career;
  @override
  Widget build(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () {
        if (leading) {
          Get.back();
        } else {
          if (career!.managerId == HomeController.to.myProfile.value.userId) {
            showBottomdialog(context, bareerColor: dividegray, func1: () {
              Get.back();
              showButtonDialog(
                  title: '이 커리어는 완전히 삭제돼요',
                  startContent: '이 커리어에 작성된\n',
                  highlightContent: '모든 포스트와 데이터는 완전 삭제되며,\n복구가 불가능해요.\n',
                  highlightColor: rankred,
                  endContent: '정말 삭제하시겠어요?',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    dialogBack(modalIOS: true);
                    loading();
                    deleteProject(career!.id, DeleteType.del).then((value) {
                      if (value.isError == false) {
                        Get.back();
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("포스팅이 삭제되었습니다", 1400);
                      } else {
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '삭제',
                  leftText: '취소');
            }, func2: () {
              Get.back();
              Get.to(
                  () => ProjectAddTitleScreen(screenType: Screentype.update));
            },
                value1: '커리어 삭제하기',
                value2: '커리어 수정하기',
                buttonColor1: rankred,
                buttonColor2: maingray,
                isOne: false);
          } else {
            // showModalIOS(context, func1: (){}, func2: (){}, value1: '커리어 신고하기', value2: '', isValue1Red: true, isValue2Red: false, isOne: true);
          }
        }
      },
      icon: Container(
        child: LayoutBuilder(
          builder: (context, c) {
            final settings = context
                .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
            final deltaExtent = settings!.maxExtent - settings.minExtent;
            final t = (1.0 -
                    (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
            final opacity1 = (1.0 - Interval(0.0, 0.75).transform(t)).obs;
            return Obx(() => SvgPicture.asset(
                'assets/icons/${leading ? 'sliver_appbar_back' : 'sliver_appbar_more_option'}.svg',
                color: opacity1 < 1 ? mainblack : mainWhite));
          },
        ),
      ),
    );
  }

  void deleteCareer(Project career) {
    if (Get.isRegistered<ProfileController>()) {
      ProfileController controller = Get.find<ProfileController>();
      controller.myProjectList.removeWhere((element) => element == career);
      controller.myProjectList.refresh();
    }
  }
}
