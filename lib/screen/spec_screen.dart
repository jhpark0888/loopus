import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/spec_api.dart';
import 'package:loopus/controller/spec_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/activity_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/school_class_info_screen.dart';
import 'package:loopus/screen/copt_notice_info_screen.dart';
import 'package:loopus/screen/realtime_rank_screen.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/career_widget.dart';
import 'package:loopus/widget/careerborad_post_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/duedate_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/hot_user_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/member_list_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math';
import '../constant.dart';

class SpecScreen extends StatelessWidget {
  SpecScreen({Key? key}) : super(key: key);
  final SpecController _controller = Get.put(SpecController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.mainWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Obx(
              () => Text(
                _controller.univName.replaceAll("학교", ""),
                style: MyTextTheme.title(context),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 21,
              width: 20,
              child: IconButton(
                  padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                  // padding: EdgeInsets.zero,
                  onPressed: () {
                    showPopUpDialog(
                      '교내, 교외 활동',
                      '교내와 교외에서 진행하는\n공모전들을 보여줘요\n교내 탭에는 학교에서 듣는 강의 목록이 있어\n커리어에 학교 강의를 추가할 수 있어요',
                    );
                  },
                  icon: SvgPicture.asset('assets/icons/information.svg')),
            )
          ],
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
                    child: Obx(
                      () => UserImageWidget(
                        imageUrl:
                            HomeController.to.myProfile.value.profileImage,
                        height: 36,
                        width: 36,
                        userType: HomeController.to.myProfile.value.userType,
                      ),
                    ),
                  ))
            ]),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                controller: _controller.tabController,
                indicatorColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                labelColor: AppColors.mainblack,
                labelStyle: MyTextTheme.navigationTitle(context)
                    .copyWith(fontWeight: FontWeight.bold),
                isScrollable: true,
                unselectedLabelColor: AppColors.dividegray,
                tabs: [
                  _tabWidget(context, "교내"),
                  _tabWidget(context, "교외", right: false)
                ]),
          ),
        ),
      ),
      backgroundColor: AppColors.cardGray,
      body: TabBarView(
          controller: _controller.tabController,
          children: [InnerSchoolScreen(), ExternalSchoolScreen()]),
    );
  }

  Widget _tabWidget(BuildContext context, String title, {bool right = true}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Tab(
            text: title,
          ),
          if (right)
            VerticalDivider(
              thickness: 1,
              width: 32,
              indent: 14,
              endIndent: 14,
              color: AppColors.dividegray,
            )
        ],
      ),
    );
  }
}

class InnerSchoolScreen extends StatelessWidget {
  InnerSchoolScreen({Key? key}) : super(key: key);
  final SpecController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.scStateList[0].value == ScreenState.loading
          ? const Center(child: LoadingWidget())
          : _controller.scStateList[0].value == ScreenState.normal
              ? Container()
              : _controller.scStateList[0].value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {})
                  : _controller.scStateList[0].value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {})
                      : SmartRefresher(
                          physics: const BouncingScrollPhysics(),
                          controller: _controller.rfControllerList[0],
                          header: MyCustomHeader(),
                          footer: const MyCustomFooter(),
                          onRefresh: _controller.onRefresh,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildGroupCareerView(context),
                                  const NewDivider(),
                                  _buildClassListView(context),
                                  const NewDivider(),
                                  _buildActivityListView(context)
                                ]),
                          ),
                        ),
    );
  }

  Widget _buildGroupCareerView(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "이제는 함께 성장하세요 🤝🏻",
                    style: MyTextTheme.navigationTitle(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "전체보기",
                  style: MyTextTheme.main(context)
                      .copyWith(color: AppColors.mainblue),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            NewCareerImage(
              ispublic: true,
            )
          ],
        ));
  }

  Widget _buildClassListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "내 포트폴리오의 시작 ‘수업’ 📚",
                  style: MyTextTheme.navigationTitle(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset('assets/icons/appbar_back.svg'))
            ],
          ),
          const SizedBox(height: 16),
          SearchTextFieldWidget(
            ontap: () {},
            hinttext: "검색",
            readonly: true,
            controller: TextEditingController(),
            fillColor: AppColors.mainWhite,
          ),
          const SizedBox(height: 16),
          Obx(
            () => ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Get.to(() => SchoolClassScreen(
                            schoolClass: _controller.classLsit[index]));
                      },
                      child: SchoolClassWidget(
                          schoolClass: _controller.classLsit[index]),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: _controller.classLsit.length),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "교내에 공지된 다양한 활동을 찾아보세요 🔭",
                  style: MyTextTheme.navigationTitle(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset('assets/icons/appbar_back.svg'))
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) => _coptInnerSchoolWidget(
                    context, _controller.scActiList[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: _controller.scActiList.length),
          ),
        ],
      ),
    );
  }

  Widget _coptInnerSchoolWidget(BuildContext context, SchoolActi schoolActi) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CoptNoticeScreen(
              activity: schoolActi,
            ));
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 99,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: schoolActi.image,
              width: 70,
              height: 99,
              fit: BoxFit.fill,
              placeholder: (context, string) {
                return Container(
                  color: AppColors.maingray,
                );
              },
              errorWidget: (context, string, widget) {
                return Container(
                  color: AppColors.maingray,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schoolActi.title,
                    style: MyTextTheme.mainbold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    schoolActi.category,
                    style: MyTextTheme.main(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "공지 날짜 ",
                        style: MyTextTheme.main(context)
                            .copyWith(color: AppColors.maingray)),
                    TextSpan(
                        text: DateFormat('yyyy-MM-dd')
                            .format(schoolActi.uploadDate),
                        style: MyTextTheme.main(context))
                  ])),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/view_count_icon.svg'),
                          const SizedBox(width: 8),
                          Text(
                            schoolActi.viewCount.toString(),
                            style: MyTextTheme.main(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const Spacer(),
                      CareerMemberListWidget(
                        members: schoolActi.member,
                        membersCount: schoolActi.memberCount,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExternalSchoolScreen extends StatelessWidget {
  ExternalSchoolScreen({Key? key}) : super(key: key);
  final SpecController _controller = Get.find();
  RxInt activeIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.scStateList[1].value == ScreenState.loading
          ? const Center(child: LoadingWidget())
          : _controller.scStateList[1].value == ScreenState.normal
              ? Container()
              : _controller.scStateList[1].value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {})
                  : _controller.scStateList[1].value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {})
                      : SmartRefresher(
                          physics: const BouncingScrollPhysics(),
                          controller: _controller.rfControllerList[1],
                          header: MyCustomHeader(),
                          footer: const MyCustomFooter(),
                          onRefresh: _controller.onRefresh,
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildCategoryToggleButtons(context),
                                  Obx(
                                    () => [
                                      0,
                                      1
                                    ].contains(_controller.curCatIndex.value)
                                        ? Column(
                                            children: [
                                              _buildPopularNoticeView(context),
                                              _buildCategoryNoticeView(context),
                                            ],
                                          )
                                        : EmptyContentWidget(text: "준비중이에요."),
                                  ),
                                ]),
                          ),
                        ),
    );
  }

  Widget _buildCategoryToggleButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _toggleButton(context, "공모전", "competition", 0)),
          const SizedBox(width: 8),
          Expanded(child: _toggleButton(context, "대외활동 인턴", "out_activity", 1)),
          const SizedBox(width: 8),
          Expanded(child: _toggleButton(context, "교육", "education", 2)),
          const SizedBox(width: 8),
          Expanded(child: _toggleButton(context, "그룹", "group", 3)),
        ],
      ),
    );
  }

  Widget _toggleButton(
      BuildContext context, String title, String imageName, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          _controller.curCatIndex.value = index;
          _controller.curGroupIndex.value = 0;
          if ([0, 1].contains(_controller.curCatIndex.value)) {
            if (_controller.curPopActiListLength == 0) {
              _controller.outPopNotiLoad();
            }
            if (_controller.curGroupActiListLength == 0) {
              _controller.outGroupNotiLoad();
            }
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 66,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _controller.curCatIndex.value == index
                  ? AppColors.mainblue
                  : AppColors.mainWhite),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/${imageName}_image.png",
                width: 40,
                height: 25,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: MyTextTheme.caption(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: _controller.curCatIndex.value == index
                        ? AppColors.mainWhite
                        : AppColors.maingray),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularNoticeView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "인기있는 공고를 소개할게요 🔥",
            style: MyTextTheme.navigationTitle(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Obx(
          () => _controller.curPopActiListLength != 0
              ? Column(
                  children: [
                    CarouselSlider.builder(
                        carouselController: CarouselController(),
                        itemCount: _controller.curPopActiListLength,
                        itemBuilder: (context, index, realIndex) {
                          return _popNotice(
                              context,
                              _controller.popActiListMap[
                                  _controller.curCatIndex.value]![index]);
                        },
                        options: CarouselOptions(
                            height: 382,
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              activeIndex.value = index;
                            },
                            // autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            enlargeStrategy: CenterPageEnlargeStrategy.height)),
                    const SizedBox(height: 16),
                    Obx(
                      () => Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: activeIndex.value,
                          count: _controller.curPopActiListLength,
                          effect: ScrollingDotsEffect(
                            dotColor: AppColors.maingray,
                            activeDotColor: AppColors.mainblue,
                            spacing: 8,
                            dotWidth: 7,
                            dotHeight: 7,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : EmptyContentWidget(text: "인기있는 공고가 없습니다."),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _popNotice(
    BuildContext context,
    OutActi outActi,
  ) {
    double width = 270;
    return GestureDetector(
      onTap: () {
        Get.to(() => CoptNoticeScreen(
              activity: outActi,
            ));
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: width,
            height: 382,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // boxShadow: [
              //   BoxShadow(
              //       color: const Color(0xFF000000).withOpacity(0.4),
              //       blurRadius: 30,
              //       offset: const Offset(0, -100),
              //       blurStyle: BlurStyle.inner,
              //       spreadRadius: 30)
              // ],
              image: DecorationImage(
                image: CachedNetworkImageProvider(outActi.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 150,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF000000).withOpacity(0.4),
                      Colors.transparent
                    ])),
          ),
          Container(
            width: width,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DueDateWidget(dueDate: outActi.endDate),
                    const Spacer(),
                    Text(
                      "공모전",
                      style: MyTextTheme.main(context)
                          .copyWith(color: AppColors.mainWhite),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Text(
                    outActi.title,
                    style: MyTextTheme.mainbold(context)
                        .copyWith(color: AppColors.mainWhite),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${outActi.viewCount}회",
                        style: MyTextTheme.main(context)
                            .copyWith(color: AppColors.mainWhite),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CareerMemberListWidget(
                      members: outActi.member,
                      membersCount: outActi.memberCount,
                      textColor: AppColors.mainWhite,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryNoticeView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchTextFieldWidget(
            ontap: () {},
            hinttext: "검색",
            readonly: true,
            controller: TextEditingController(),
            fillColor: AppColors.mainWhite,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 34,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (contenxt, index) => _categoryItem(contenxt, index,
                  schoolOutCatMap[_controller.curCatIndex.value]![index]),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount:
                  schoolOutCatMap[_controller.curCatIndex.value]!.length),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "전체보기",
              style:
                  MyTextTheme.main(context).copyWith(color: AppColors.mainblue),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 550,
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.vertical,
              itemBuilder: (contenxt, index) => _noticeCard(
                  context,
                  _controller.catActiListMap[_controller.curCatIndex.value]![
                      _controller.curGroupIndex.value]![index]),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: min(4, _controller.curGroupActiListLength)),
        ),
      ],
    );
  }

  Widget _categoryItem(
    BuildContext context,
    int index,
    String text,
  ) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          _controller.curGroupIndex.value = index;
          if (_controller.curGroupActiListLength == 0) {
            _controller.outGroupNotiLoad();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: index == _controller.curGroupIndex.value
                ? AppColors.mainblue
                : AppColors.mainWhite,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            text,
            style: MyTextTheme.main(context).copyWith(
                color: index == _controller.curGroupIndex.value
                    ? AppColors.mainWhite
                    : null),
          ),
        ),
      ),
    );
  }

  Widget _noticeCard(BuildContext context, OutActi outActi) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CoptNoticeScreen(
              activity: outActi,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.2),
              offset: const Offset(0, 1),
              blurRadius: 4,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: outActi.image,
              width: 70,
              height: 99,
              fit: BoxFit.fill,
              placeholder: (context, string) {
                return Container(
                  color: AppColors.maingray,
                );
              },
              errorWidget: (context, string, widget) {
                return Container(
                  color: AppColors.maingray,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outActi.title,
                    style: MyTextTheme.mainbold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "공모전",
                        style: MyTextTheme.mainbold(context),
                      ),
                      const Spacer(),
                      DueDateWidget(dueDate: outActi.endDate)
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(outActi.organizer,
                      style: MyTextTheme.main(context)
                          .copyWith(color: AppColors.maingray)),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/view_count_icon.svg'),
                          const SizedBox(width: 8),
                          Text(
                            "${outActi.viewCount}회",
                            style: MyTextTheme.main(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const Spacer(),
                      CareerMemberListWidget(
                        members: outActi.member,
                        membersCount: outActi.memberCount,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class PopNoticePageView extends StatefulWidget {
//   PopNoticePageView({Key? key, required this.child}) : super(key: key);
//   Widget child;

//   @override
//   State<PopNoticePageView> createState() => _PopNoticePageViewState();
// }

// class _PopNoticePageViewState extends State<PopNoticePageView> {
//   final _popPageController = PageController(viewportFraction: 0.8);

//   double _currentPage = 0;

//   void _popScrollListener() {
//     setState(() {
//       _currentPage = _popPageController.page!;
//     });
//   }

//   @override
//   void initState() {
//     _popPageController.addListener(_popScrollListener);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _popPageController.removeListener(_popScrollListener);
//     _popPageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           // padding: const EdgeInsets.symmetric(horizontal: 16),
//           height: 382,
//           child: Transform(
//             alignment: FractionalOffset.center,
//             transform: Matrix4.identity()..setEntry(3, 2, 0.001),
//             child: PageView.builder(
//               controller: _popPageController,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 double result = (_currentPage - index).abs();
//                 int integer = result.toInt();
//                 result -= integer;
//                 final dx = 225 * (_currentPage - index);
//                 final dz = integer == 0 ? 0.0 : -200.0;
//                 final scale = 0.8 + (0.2 - result / 5) * (integer == 0 ? 1 : 0);

//                 // final result = _currentPage - index + 1;
//                 // final value = -0.8 * result + 1;
//                 // final opacity = value.clamp(0.0, 1.0);

//                 return Transform(
//                     alignment: FractionalOffset.center,
//                     transform: Matrix4.identity()
//                       // ..setEntry(3, 2, 0.001)
//                       // ..setEntry(3, 0, 0.001)
//                       ..translate(dx)
//                       // ..setEntry(0, 3, dx)
//                       ..setEntry(2, 3, dz)
//                       ..scale(scale),
//                     child: widget.child);
//               },
//               itemCount: 6,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Center(
//           child: SmoothPageIndicator(
//             controller: _popPageController,
//             count: 6,
//             effect: ScrollingDotsEffect(
//               dotColor: AppColors.maingray,
//               activeDotColor: AppColors.mainblue,
//               spacing: 8,
//               dotWidth: 7,
//               dotHeight: 7,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
