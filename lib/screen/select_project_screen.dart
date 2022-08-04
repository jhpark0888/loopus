import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/select_project_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';

import '../widget/custom_expanded_button.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key? key}) : super(key: key);

  SelectProjectController controller = Get.put(SelectProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset('assets/icons/appbar_exit.svg')),
        title: '커리어 선택',
        bottomBorder: false,
      ),
      body: ScrollNoneffectWidget(
        child: SingleChildScrollView(
          child: Obx(
            () => Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.selectprojectlist.value.isNotEmpty)
                      Text(
                        '포스트를 작성할 커리어를 선택해주세요',
                        style: kmain.copyWith(color: maingray),
                        textAlign: TextAlign.center,
                      ),
                    if (controller.selectprojectlist.isNotEmpty)
                      SizedBox(
                        height: 24,
                      ),
                    if (controller.selectprojectlist.value.isNotEmpty)
                      ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProjectWidget(
                              project: controller.selectprojectlist[index].obs,
                              type: ProjectWidgetType.addposting);
                        },
                        itemCount: controller.selectprojectlist.length,
                        separatorBuilder: (context, index) {
                          return Divider(thickness: 0.5, color: dividegray);
                        },
                      ),
                    Divider(thickness: 0.5, color: dividegray),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            ProjectAddTitleScreen(screenType: Screentype.add));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/career_add.svg'),
                          const SizedBox(width: 14),
                          Text('커리어 추가하기',
                              style: kmain.copyWith(color: mainblue))
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
