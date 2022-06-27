import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/select_project_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';

import '../widget/custom_expanded_button.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key? key}) : super(key: key);

  SelectProjectController controller = Get.put(SelectProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '커리어 선택',
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.selectprojectlist.value.isNotEmpty)
                  Text(
                    '포스트를 추가할 커리어를 선택해주세요',
                    style: kSubTitle3Style.copyWith(
                        color: maingray.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                if (controller.selectprojectlist.value.isNotEmpty)
                  SizedBox(
                    height: 10,
                  ),
                Column(
                  children: [
                    Column(
                      children: controller.selectprojectlist.value.isNotEmpty
                          ? controller.selectprojectlist
                              .map((project) => Column(children: [
                                    const SizedBox(height: 14),
                                    ProjectWidget(
                                        project: project.obs,
                                        type: ProjectWidgetType.addposting),
                                    Divider(
                                      thickness: 0.5,
                                      color: maingray.withOpacity(0.2),
                                    )
                                  ]))
                              .toList()
                          : [
                              Text(
                                '첫번째 활동을 기록해보세요',
                                style: kSubTitle1Style,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '수업, 과제, 스터디 등 학교 생활과 관련있는\n다양한 경험을 남겨보세요',
                                style: kBody1Style.copyWith(
                                  color: mainblack.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomExpandedButton(
                                onTap: () {
                                  Get.to(
                                    () => ProjectAddTitleScreen(
                                      screenType: Screentype.add,
                                    ),
                                  );
                                },
                                isBlue: true,
                                title: '첫번째 활동 추가하기',
                                buttonTag: '첫번째 활동 추가하기',
                                isBig: false,
                              )
                            ],
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> ProjectAddTitleScreen(screenType: Screentype.add));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/career_add.svg'),
                          const SizedBox(width: 14),
                          Text('커리어 추가하기',style: k16Normal.copyWith(color: mainblue))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
