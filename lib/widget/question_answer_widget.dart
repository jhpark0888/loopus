import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';

class QuestionAnswerWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  Answer answer;

  QuestionAnswerWidget({
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: tapProfile,
                      child: ClipOval(
                        child: answer.user.profileImage == null
                            ? Image.asset(
                                "assets/illustrations/default_profile.png",
                                height: 32,
                                width: 32,
                              )
                            : CachedNetworkImage(
                                height: 32,
                                width: 32,
                                imageUrl: answer.user.profileImage!,
                                placeholder: (context, url) =>
                                    kProfilePlaceHolder(),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: tapProfile,
                      child: Text(
                        "${answer.user.realName}",
                        style: kButtonStyle,
                      ),
                    ),
                    Text(
                      " · ${DurationCaculator().messagedurationCaculate(startDate: answer.date, endDate: DateTime.now())}",
                      style: kBody2Style.copyWith(
                          color: mainblack.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => showModal(context),
                child: SvgPicture.asset("assets/icons/More.svg"),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Text(
                  "${answer.content}",
                  style: kBody1Style,
                ),
              ),
              SizedBox(
                width: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showModal(BuildContext context) {
    if (answer.isuser == 1) {
      showModalIOS(context, func1: () {
        showButtonDialog(
            leftText: '취소',
            rightText: '삭제',
            title: '정말 답변을 삭제하시겠어요?',
            content: '삭제한 답변은 복구할 수 없어요',
            leftFunction: () => Get.back(),
            rightFunction: () {
              deleteanswer(answer.questionid, answer.id);
            });
      },
          func2: () {},
          value1: '답글 삭제하기',
          value2: 'value2',
          isValue1Red: true,
          isValue2Red: true,
          isOne: true);
    } else {
      showModalIOS(context, func1: () {
        showButtonDialog(
            leftText: '취소',
            rightText: '신고',
            title: '정말 이 답변을 신고하시겠어요?',
            content: '관리자가 검토 절차를 거칩니다',
            leftFunction: () => Get.back(),
            rightFunction: () {
              answerreport(answer.id);
            });
      },
          func2: () {},
          value1: '답글 신고하기',
          value2: 'value2',
          isValue1Red: true,
          isValue2Red: true,
          isOne: true);
    }
  }

  void tapProfile() {
    print(answer.content.toString());
    // profileController.isProfileLoading(true);

    Get.to(() => OtherProfileScreen(
          userid: answer.userid,
          isuser: answer.isuser,
          realname: answer.user.realName,
        ));
  }
}
