import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/select_project_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/project_add_company_screen.dart';
import 'package:loopus/trash_bin/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';

import '../utils/check_form_validate.dart';

class ProjectAddTitleScreen extends StatelessWidget {
  ProjectAddTitleScreen({
    Key? key,
    // this.career,
    required this.screenType,
  }) : super(key: key);

  final Screentype screenType;
  final ProjectAddController _controller = Get.put(ProjectAddController());
  // Rx<Project>? career;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          leading: IconButton(onPressed: (){Get.back();}, icon: SvgPicture.asset('assets/icons/appbar_exit.svg'), padding: EdgeInsets.zero,),
          bottomBorder: false,
          actions: [
            screenType == Screentype.add
                ? TextButton(
                    onPressed: () async {
                      if (_controller.onTitleButton.value) {
                        _controller.selectedStartDateTime.value =
                            DateTime.parse(DateTime.now().toString())
                                .toString();
                        _controller.isEndedProject(false);
                        loading();

                        await addproject().then((value) async {
                          Get.back();
                          final LocalDataController _localDataController =
                              Get.put(LocalDataController());
                          final GAController _gaController =
                              Get.put(GAController());
                          if (value.isError == false) {
                            await _gaController.logProjectCreated(true);

                            Project project = Project.fromJson(value.data);
                            project.is_user = 1;
                            SelectProjectController.to.selectprojectlist.insert(0, project);
                            if (Get.isRegistered<ProfileController>()) {
                              ProfileController.to.myProjectList.add(project);
                              // ProfileController.to.careerPagenums.add(1);
                            }
                            Get.back();

                            SchedulerBinding.instance!
                                .addPostFrameCallback((_) {
                              showCustomDialog('활동이 성공적으로 만들어졌어요!', 1000);
                            });

                            if (_localDataController.isAddFirstProject ==
                                true) {
                              final InAppReview inAppReview =
                                  InAppReview.instance;

                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              }
                            }
                            _localDataController.firstProjectAdd();
                          } else {
                            await _gaController.logProjectCreated(false);
                            errorSituation(value);
                          }
                        });
                      } else {
                        if (_controller.projectnamecontroller.text
                            .trim()
                            .isEmpty) {
                          showCustomDialog("커리어 이름을 입력해주세요", 1000);
                        } else {
                          showCustomDialog("특수문자를 제거해주세요", 1000);
                        }
                      }
                    },
                    child: Obx(
                      () => Text(
                        '확인',
                        style: kNavigationTitle.copyWith(
                          color: _controller.onTitleButton.value
                              ? mainblue
                              : mainblack.withOpacity(0.38),
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      if (_controller.onTitleButton.value) {
                        loading();
                        updateCareer(
                                CareerDetailController.to.career.value.id,
                                null,
                                _controller.projectnamecontroller.text,
                                ProjectUpdateType.project_name)
                            .then((value) {
                          if (value.isError == false) {
                            Get.back();
                            CareerDetailController.to.career.value.careerName =
                                _controller.projectnamecontroller.text;
                            CareerDetailController.to.career.refresh();
                            if (Get.isRegistered<ProfileController>()) {
                              ProfileController.to.myProjectList
                                      .where(
                                          (p0) =>
                                              p0.id ==
                                              CareerDetailController
                                                  .to.career.value.id)
                                      .first
                                      .careerName =
                                  _controller.projectnamecontroller.text;
                              ProfileController.to.myProjectList.refresh();
                            }
                            Get.back();
                            showCustomDialog('커리어가 수정됐어요', 1400);
                          }
                        });
                      }
                    },
                    icon: Obx(
                      () => Text('확인',
                          style: kNavigationTitle.copyWith(
                              color: _controller.onTitleButton.value
                                  ? mainblue
                                  : mainblack.withOpacity(0.38))),
                    ),
                    padding: EdgeInsets.all(0),
                  )
          ],
          // leading: IconButton(
          //   onPressed: () {
          //     Get.back();
          //   },
          //   icon: SvgPicture.asset('assets/icons/appbar_exit.svg'),
          // ),
          title: screenType == Screentype.add ? '커리어 추가' : '커리어 수정',
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (screenType == Screentype.add)
              Text(
                "본인의 새로운 경험을 추가해보세요",
                style: kmain.copyWith(color: maingray),
              ),
            const SizedBox(
              height: 16,
            ),
            LabelTextFieldWidget(
                label: "커리어 이름",
                hintText: "커리어 이름을 입력하세요(최대 20글자)",
                maxLength: 20,
                textController: _controller.projectnamecontroller),
            const SizedBox(
              height: 18,
            ),
            if (screenType == Screentype.add)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      _controller.isPublic(!_controller.isPublic.value);
                    },
                    child: Row(
                      children: [
                        _controller.isPublic.value ?
                        SvgPicture.asset(
                          "assets/icons/uncheck_icon.svg",
                          width: 18,
                          height: 18,
                        ) : SvgPicture.asset(
                          "assets/icons/check_icon.svg",
                          width: 18,
                          height: 18,
                        ) ,
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "그룹 커리어에요",
                          style: kmain.copyWith(
                              color:
                                  _controller.isPublic.value ? null : maingray),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 18,
            ),
            Obx(() => _controller.selectCompany.value.name == ""
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => ProjectAddCompanyScreen());
                      _controller.compSearchInit();
                    },
                    child: Text(
                      "기업과 연계된 인턴/채용 커리어세요?",
                      style: kmain.copyWith(color: mainblue),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "함께한 기업",
                          style: kmain,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CompanyTileWidget(
                        company: _controller.selectCompany.value,
                        onCancelTap: () {
                          _controller.selectCompany(Company.defaultCompany());
                        },
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
