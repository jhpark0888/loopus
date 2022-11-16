import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/utils/footer_reorder_listview.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_widget.dart';

class CareerArrangeScreen extends StatelessWidget {
  CareerArrangeScreen({Key? key}) : super(key: key);

  final CareerArrangeController _controller = CareerArrangeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "커리어 리스트 수정",
        bottomBorder: false,
        actions: [
          TextButton(
              onPressed: () async {
                loading();
                await postProjectArrange(_controller.careerList).then((value) {
                  if (value.isError == false) {
                    if (Get.isRegistered<ProfileController>()) {
                      ProfileController.to
                          .myProjectList(_controller.careerList);
                    }
                    if (Get.isRegistered<OtherProfileController>(
                        tag: HomeController.to.myId)) {
                      Get.find<OtherProfileController>(
                              tag: HomeController.to.myId)
                          .otherProjectList(_controller.careerList);
                    }
                    getbacks(2);
                  } else {
                    Get.back();
                    errorSituation(value);
                  }
                });
              },
              child: Text(
                "확인",
                style: MyTextTheme.navigationTitle(context)
                    .copyWith(color: AppColors.mainblue),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => CustomReorderableListView(
                  // primary: false,
                  // shrinkWrap: true,
                  // itemCount: _controller.careerList.length,
                  header: Column(
                    children: [
                      Text(
                        "커리어를 선택해 원하는 위치로 변경할 수 있어요",
                        style: MyTextTheme.main(context)
                            .copyWith(color: AppColors.maingray),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  footer: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ProjectAddTitleScreen(
                              screenType: Screentype.add));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                    'assets/icons/career_add.svg')),
                            const SizedBox(width: 8),
                            Text('커리어 추가하기',
                                style: MyTextTheme.main(context)
                                    .copyWith(color: AppColors.mainblue))
                          ],
                        ),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onReorder: _controller.onReorder,
                  children: _controller.careerList
                      .map((career) => Padding(
                            key: UniqueKey(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            child: CareerArrangeWidget(
                              career: career,
                            ),
                          ))
                      .toList()
                  // itemBuilder: (BuildContext context, int index) {
                  //   return Padding(
                  //     key: UniqueKey(),
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 20),
                  //     child: CareerWidget(
                  //       career: _controller.careerList[index],
                  //     ),
                  //   );
                  // },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class CareerArrangeController {
  // CareerArrangeController({});

  RxList<Project> careerList =
      List<Project>.from(ProfileController.to.myProjectList).obs;

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    Project row = careerList.removeAt(oldIndex);
    careerList.insert(newIndex, row);
  }

  void careerMove(int index, Project career) {
    careerList.insert(index, career);
  }

  void careerRemove(int index) {
    careerList.removeAt(index);
  }
}

class CareerArrangeWidget extends StatelessWidget {
  CareerArrangeWidget({Key? key, required this.career}) : super(key: key);

  Project career;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
                color: career.thumbnail == "" ? AppColors.cardGray : null,
                borderRadius: BorderRadius.circular(8),
                image: career.thumbnail == ""
                    ? null
                    : DecorationImage(
                        image: NetworkImage(career.thumbnail),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            const Color(0x00000000).withOpacity(0.4),
                            BlendMode.srcOver))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.careerName,
                  style: MyTextTheme.mainbold(context).copyWith(
                      color: career.thumbnail == ""
                          ? AppColors.mainblack
                          : AppColors.mainWhite),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    career.isPublic
                        ? SvgPicture.asset('assets/icons/group_career.svg',
                            color: career.thumbnail == ""
                                ? AppColors.mainblack
                                : AppColors.mainWhite)
                        : SvgPicture.asset('assets/icons/single_career.svg',
                            color: career.thumbnail == ""
                                ? AppColors.mainblack
                                : AppColors.mainWhite),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      career.isPublic ? "그룹 커리어" : "개인 커리어",
                      style: MyTextTheme.main(context).copyWith(
                          color: career.thumbnail == ""
                              ? AppColors.mainblack
                              : AppColors.mainWhite),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        SvgPicture.asset('assets/icons/reorder.svg')
      ],
    );
  }
}
