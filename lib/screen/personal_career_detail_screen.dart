import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/empty_post_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

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
    careerDetailController = Get.put(CareerDetailController(career: career.obs),
        tag: career.id.toString());
    // copyList = careerList;
    return Scaffold(
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        controller: careerDetailController.scrollController,
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
              ),
            ],
            pinned: true,
            flexibleSpace: Obx(
              () => _MyAppSpace(
                career: careerDetailController.career.value,
              ),
            ),
            expandedHeight: 190,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  joinCompany(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomPieChart(
                          career: career,
                          // careerList: careerList,
                          currentId: career.id,
                        ),
                        const SizedBox(width: 24),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${fieldList[career.fieldId]} ??????',
                                    style: MyTextTheme.mainbold(context)),
                                TextSpan(
                                    text: ' ?????????',
                                    style: MyTextTheme.mainbold(context))
                              ])),
                              const SizedBox(height: 8),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '$name?????? ?????? ????????? ???\n',
                                    style: MyTextTheme.mainheight(context)),
                                TextSpan(
                                    text:
                                        '${(career.postRatio! * 100).toInt()}%',
                                    style: MyTextTheme.mainbold(context)),
                                TextSpan(
                                    text: '??? ???????????? ???????????????',
                                    style: MyTextTheme.mainheight(context))
                              ])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColors.dividegray,
                      )),
                  // const SizedBox(height: 24),
                  Obx(() => careerDetailController.postList.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, postindex) {
                            return PostingWidget(
                              item: careerDetailController.postList[postindex],
                              type: PostingWidgetType.normal,
                            );
                          },
                          itemCount: careerDetailController.postList.length,
                        )
                      // ?????? ??????
                      : HomeController.to.myId ==
                              careerDetailController.career.value.userid
                                  .toString()
                          ? GestureDetector(
                              onTap: () {
                                Get.to(() => PostingAddScreen(
                                      project_id: career.id,
                                      route: PostaddRoute.career,
                                    ));
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height: 24),
                                  EmptyPostWidget(),
                                ],
                              ))
                          : Center(
                              child: EmptyContentWidget(text: "?????? ???????????? ?????????")))
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget joinCompany(BuildContext context) {
    return Obx(() => careerDetailController.career.value.company != null
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (careerDetailController.career.value.company != null) {
                    if (careerDetailController.career.value.company!.userId !=
                        0) {
                      Get.to(() => OtherCompanyScreen(
                          companyId: careerDetailController
                              .career.value.company!.userId,
                          companyName: careerDetailController
                              .career.value.company!.name));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserImageWidget(
                          imageUrl:
                              careerDetailController.career.value.company !=
                                      null
                                  ? careerDetailController
                                      .career.value.company!.profileImage
                                  : '',
                          userType: UserType.company,
                          height: 36,
                          width: 36,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: careerDetailController
                                  .career.value.company!.name,
                              style: MyTextTheme.mainbold(context)),
                          TextSpan(
                              text: '??? ????????? ???????????????',
                              style: MyTextTheme.main(context))
                        ]))
                      ]),
                ),
              ),
              DivideWidget(
                height: 1,
              ),
            ],
          )
        : const SizedBox.shrink());
  }
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({Key? key, required this.career}) : super(key: key);
  Project career;
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
                      context,
                      career.careerName,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: opacity1,
                child: Hero(
                  tag: career.id.toString(),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: career.thumbnail == ""
                                ? const AssetImage(
                                    'assets/illustrations/default_image.png')
                                : NetworkImage(career.thumbnail)
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                const Color(0x00000000).withOpacity(0.4),
                                BlendMode.srcOver))),
                    width: Get.width,
                    height: Get.width,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          16, Platform.isAndroid ? 44 : 60, 16, 26),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 44),
                            getExpendTitle(
                              context,
                              career.careerName,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            career.updateDate != null
                                ? Text(
                                    '?????? ????????? ${calculateDate(career.updateDate!)}',
                                    style: MyTextTheme.main(context)
                                        .copyWith(color: AppColors.mainWhite),
                                  )
                                : Container(
                                    color: AppColors.mainWhite,
                                    height: 2,
                                    width: 6,
                                  ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/single_career.svg'),
                                const SizedBox(width: 8),
                                Text('?????? ?????????',
                                    style: MyTextTheme.main(context)
                                        .copyWith(color: AppColors.mainWhite)),
                                const Spacer(),
                                Text(
                                  '????????? ${career.post_count}',
                                  style: MyTextTheme.main(context)
                                      .copyWith(color: AppColors.mainWhite),
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
                tag: career.id.toString(),
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

  Widget getExpendTitle(BuildContext context, String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: MyTextTheme.navigationTitle(context)
            .copyWith(color: AppColors.mainWhite));
  }

  Widget getCollapseTitle(BuildContext context, String text) {
    return Text(text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: MyTextTheme.navigationTitle(context));
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
      padding: EdgeInsets.zero,
      onPressed: () {
        if (leading) {
          Get.back();
        } else {
          if (career!.managerId == HomeController.to.myProfile.value.userId) {
            showBottomdialog(context, bareerColor: AppColors.popupGray,
                func2: () {
              Get.back();
              showButtonDialog(
                  title: '??? ???????????? ????????? ????????????',
                  startContent: '??? ???????????? ?????????\n',
                  highlightContent: '?????? ???????????? ???????????? ?????? ????????????,\n????????? ???????????????.\n',
                  highlightColor: AppColors.rankred,
                  endContent: '?????? ??????????????????????',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    dialogBack(modalIOS: true);
                    loading();
                    deleteProject(career!.id, DeleteType.del).then((value) {
                      if (value.isError == false) {
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("???????????? ?????????????????????", 1400);
                      } else {
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '??????',
                  leftText: '??????');
            }, func1: () {
              Get.back();
              Get.to(() => ProjectAddTitleScreen(
                    screenType: Screentype.update,
                    careerId: career!.id,
                  ));
            },
                value2: '????????? ????????????',
                value1: '????????? ????????????',
                buttonColor2: AppColors.rankred,
                buttonColor1: AppColors.mainWhite,
                textColor2: AppColors.mainWhite,
                textColor1: AppColors.mainblack,
                isOne: false);
          } else {
            showBottomdialog(context, func1: () {
              showButtonDialog(
                  leftText: '??????',
                  rightText: '??????',
                  title: '?????? ??????',
                  startContent: '${career!.user.name}?????? ??????????????????????',
                  leftFunction: () => Get.back(),
                  rightFunction: () {
                    userban(career!.userid!).then((value) {
                      if (value.isError == false) {
                        dialogBack();
                        if (Get.isRegistered<OtherProfileController>()) {
                          OtherProfileController.to.otherUser.value
                              .banned(BanState.ban);
                        }
                        showCustomDialog("?????? ????????? ?????? ???????????????", 1000);
                      } else {
                        errorSituation(value);
                      }
                    });
                    userResign(HomeController.to.myProfile.value.userId,
                        BanType.ban, career!.userid);
                  });
            }, func2: () {
              TextEditingController reportController = TextEditingController();
              showTextFieldDialog(
                  title: '?????? ??????',
                  hintText:
                      '?????? ????????? ??????????????????. ????????? ?????? ?????? ?????? ????????? ??????????????? ?????? ????????? ?????? ??? ????????????.',
                  rightText: '??????',
                  textEditingController: reportController,
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    userreport(career!.userid!).then((value) {
                      if (value.isError == false) {
                        dialogBack(modalIOS: true);
                        showCustomDialog("????????? ?????????????????????", 1000);
                      } else {
                        errorSituation(value);
                      }
                    });
                  });
            },
                value1: '?????? ????????????',
                value2: '?????? ????????????',
                buttonColor1: AppColors.mainWhite,
                buttonColor2: AppColors.rankred,
                textColor1: AppColors.rankred,
                textColor2: AppColors.mainWhite,
                isOne: false);
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
                color:
                    opacity1 < 1 ? AppColors.mainblack : AppColors.mainWhite));
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
