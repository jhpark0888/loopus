import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/select_project_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

import '../widget/custom_expanded_button.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key? key}) : super(key: key);

  SelectProjectController controller = Get.put(SelectProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '포스팅 작성하기',
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.selectprojectlist.value.isNotEmpty)
                  Text(
                    '어떤 활동에 대한 포스팅인가요?',
                    style: kSubTitle2Style,
                    textAlign: TextAlign.center,
                  ),
                if (controller.selectprojectlist.value.isNotEmpty)
                  SizedBox(
                    height: 28,
                  ),
                Column(
                  children: controller.selectprojectlist.value.isNotEmpty
                      ? controller.selectprojectlist.value
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
