import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupTypeScreen extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final GAController _gaController = Get.put(GAController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              //TODO: 학교 선택 시 활성화되어야 함
              if (signupController.selectedType.value == UserType.student) {
                Get.to(() => SignupCampusInfoScreen());
              } else if (signupController.selectedType.value ==
                  UserType.professer) {
                // Get.to(() => SignupCompanyScreen());
                ModalController.to.showCustomDialog('추후 업데이트 될 예정입니다', 1000);
              } else {
                // Get.to(() => SignupCompanyScreen());
                ModalController.to.showCustomDialog('추후 업데이트 될 예정입니다', 1000);
              }
              await _gaController.logScreenView('signup_1');
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '가입 유형을 선택해주세요',
                style: kSubTitle1Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserTypeWidget(
                    hoverTag: '대학생',
                    title: '대학생',
                    userType: UserType.student,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  UserTypeWidget(
                    hoverTag: '기업',
                    title: '기업',
                    userType: UserType.company,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  UserTypeWidget(
                    hoverTag: '교직원',
                    title: '교직원',
                    userType: UserType.professer,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserTypeWidget extends StatelessWidget {
  UserTypeWidget({
    Key? key,
    required this.userType,
    required this.title,
    required this.hoverTag,
  }) : super(key: key);

  final SignupController signupController = Get.put(SignupController());
  final UserType userType;
  final String title;
  final String hoverTag;
  late final HoverController _hoverController = Get.put(
    HoverController(),
    tag: hoverTag,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (details) => _hoverController.isHover(true),
        onTapCancel: () => _hoverController.isHover(false),
        onTapUp: (details) => _hoverController.isHover(false),
        onTap: () {
          signupController.selectedType.value = userType;
        },
        child: Obx(
          () => Container(
            decoration: kCardStyle.copyWith(
              color: (signupController.selectedType.value == userType)
                  ? mainblue
                  : mainWhite,
              boxShadow: _hoverController.isHover.value
                  ? [
                      BoxShadow(
                        blurRadius: 1,
                        offset: const Offset(0.0, 0.5),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      BoxShadow(
                        blurRadius: 1,
                        offset: const Offset(0.0, 0.5),
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ]
                  : [
                      BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0.0, 1.0),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      BoxShadow(
                        blurRadius: 2,
                        offset: const Offset(0.0, 1.0),
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ],
            ),
            padding: const EdgeInsets.all(24),
            child: Text(
              title,
              style: kSubTitle3Style.copyWith(
                  color: (signupController.selectedType.value == userType)
                      ? mainWhite
                      : _hoverController.isHover.value
                          ? mainblack.withOpacity(0.6)
                          : mainblack),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
