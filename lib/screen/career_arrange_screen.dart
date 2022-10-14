import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_widget.dart';

class CareerArrangeScreen extends StatelessWidget {
  CareerArrangeScreen({Key? key}) : super(key: key);

  final CareerArrangeController _controller = CareerArrangeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "커리어 정렬",
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
                "수정",
                style: kNavigationTitle.copyWith(color: mainblue),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ReorderableListView(
                  // primary: false,
                  // shrinkWrap: true,
                  // itemCount: _controller.careerList.length,
                  header: Column(
                    children: const [
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "커리어들을 원하는 순서대로 정렬하세요",
                        style: kmainbold,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onReorder: _controller.onReorder,
                  children: _controller.careerList
                      .map((career) => Padding(
                            key: UniqueKey(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: CareerWidget(
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
