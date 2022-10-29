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
        leading: IconButton(
          padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/appbar_exit.svg')),
        title: '커리어 선택',
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    controller.selectprojectlist.isNotEmpty
                        ? '포스트를 작성할 커리어를 선택해주세요'
                        : "포스트를 작성하기 위해 커리어를 추가해주세요",
                    style: kmain.copyWith(color: maingray),
                    textAlign: TextAlign.center,
                  ),
                  if (controller.selectprojectlist.isNotEmpty)
                    Column(
                      children: [
                        ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ProjectWidget(
                              project: controller.selectprojectlist[index].obs,
                            );
                          },
                          itemCount: controller.selectprojectlist.length,
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 0.5, color: dividegray);
                          },
                        ),
                        Divider(thickness: 0.5, color: dividegray),
                      ],
                    ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ProjectAddTitleScreen(screenType: Screentype.add));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/career_add.svg'),
                        const SizedBox(width: 8),
                        Text('커리어 추가하기',
                            style: kmainbold.copyWith(color: mainblue))
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
