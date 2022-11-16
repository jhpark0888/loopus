import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/select_project_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/project_add_company_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/label_textfield_widget.dart';

class ProjectAddTitleScreen extends StatelessWidget {
  ProjectAddTitleScreen({
    Key? key,
    // this.career,
    this.careerId,
    required this.screenType,
  }) : super(key: key);

  final Screentype screenType;
  final ProjectAddController _controller = Get.put(ProjectAddController());

  // 커리어 수정일 때는 커리어 아이디 받아야 함
  int? careerId;

  // Rx<Project>? career;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/appbar_exit.svg'),
            padding: EdgeInsets.zero,
          ),
          bottomBorder: false,
          actions: [
            screenType == Screentype.add
                ? TextButton(
                    onPressed: () async {
                      if (_controller.onTitleButton.value) {
                        loading();

                        await addproject().then((value) async {
                          final LocalDataController _localDataController =
                              Get.put(LocalDataController());
                          final GAController _gaController =
                              Get.put(GAController());
                          if (value.isError == false) {
                            await _gaController.logProjectCreated(true);
                            Project project = Project.fromJson(value.data);
                            if (_controller.selectCompany.value.userId != 0) {
                              // addCompany(project.id, _controller.selectCompany.value.userId);
                            }
                            project.is_user = 1;
                            SelectProjectController.to.selectprojectlist
                                .insert(0, project);
                            if (Get.isRegistered<ProfileController>()) {
                              ProfileController.to.myProjectList.add(project);
                              // ProfileController.to.careerPagenums.add(1);
                            }
                            getbacks(3);
                            Future.delayed(const Duration(milliseconds: 1000));

                            goCareerScreen(
                              project,
                              HomeController.to.myProfile.value.name,
                            );

                            Future.delayed(const Duration(milliseconds: 1000));
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
                            Get.back();
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
                        style: MyTextTheme.navigationTitle(context).copyWith(
                          color: _controller.onTitleButton.value
                              ? AppColors.mainblue
                              : AppColors.maingray,
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      if (_controller.onTitleButton.value) {
                        loading();
                        CareerDetailController careerDetailController =
                            Get.find<CareerDetailController>(
                                tag: careerId.toString());
                        updateCareer(careerDetailController.career.value.id,
                                ProjectUpdateType.project_name,
                                title: _controller.projectnamecontroller.text,
                                companyName: careerDetailController
                                            .career.value.company !=
                                        null
                                    ? careerDetailController
                                        .career.value.company!.name
                                    : null,
                                companyId:
                                    _controller.selectCompany.value.userId)
                            .then((value) {
                          if (value.isError == false) {
                            print(value.data);
                            careerDetailController.career.value.careerName =
                                _controller.projectnamecontroller.text;
                            if (_controller.selectCompany.value.name != '') {
                              careerDetailController.career.value.company =
                                  _controller.selectCompany.value;
                            }
                            careerDetailController.career.refresh();
                            if (Get.isRegistered<ProfileController>()) {
                              ProfileController.to.myProjectList
                                      .where(
                                          (p0) =>
                                              p0.id ==
                                              careerDetailController
                                                  .career.value.id)
                                      .first
                                      .careerName =
                                  _controller.projectnamecontroller.text;
                              if (_controller.selectCompany.value.name != '') {
                                ProfileController.to.myProjectList
                                    .where((p0) =>
                                        p0.id ==
                                        careerDetailController.career.value.id)
                                    .first
                                    .company = _controller.selectCompany.value;
                                ProfileController.to.myProjectList
                                        .where(
                                            (p0) =>
                                                p0.id ==
                                                careerDetailController
                                                    .career.value.id)
                                        .first
                                        .thumbnail =
                                    _controller
                                        .selectCompany.value.profileImage;
                              }
                              ProfileController.to.myProjectList.refresh();
                            }
                            getbacks(2);
                            showCustomDialog('커리어가 수정됐어요', 1400);
                          } else {
                            Get.back();
                            errorSituation(value);
                          }
                        });
                      }
                    },
                    child: Obx(
                      () => Text('확인',
                          style: MyTextTheme.navigationTitle(context).copyWith(
                              color: _controller.onTitleButton.value
                                  ? AppColors.mainblue
                                  : AppColors.maingray)),
                    ),
                  )
          ],
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
                style: MyTextTheme.main(context)
                    .copyWith(color: AppColors.maingray),
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
                        _controller.isPublic.value
                            ? SvgPicture.asset(
                                "assets/icons/uncheck_icon.svg",
                                width: 18,
                                height: 18,
                              )
                            : SvgPicture.asset(
                                "assets/icons/check_icon.svg",
                                width: 18,
                                height: 18,
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "그룹 커리어에요",
                          style: MyTextTheme.main(context).copyWith(
                              color: _controller.isPublic.value
                                  ? null
                                  : AppColors.maingray),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            Obx(() => _controller.selectCompany.value.name == ""
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => ProjectAddCompanyScreen());
                      _controller.compSearchInit();
                    },
                    child: Text(
                      screenType == Screentype.add
                          ? "기업과 연계된 인턴/채용 커리어세요?"
                          : "연계된 기업 추가하기",
                      style: MyTextTheme.main(context)
                          .copyWith(color: AppColors.mainblue),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "함께한 기업",
                          style: MyTextTheme.main(context),
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
