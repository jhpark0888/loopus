import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/report_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionDetailScreen extends StatelessWidget {
  ModalController modalController = Get.put(ModalController());
  final _formKey = GlobalKey<FormState>();

  QuestionController questionController = Get.find();
  late Map data;
  RxInt numLines = 0.obs;

  void _handleSubmitted(String text) async {
    data =
        await answermake(text, questionController.questionModel2.questions.id);
    questionController.messageanswerlist.add(MessageAnswerWidget(
      content: data["content"],
      image: "image",
      name: data["real_name"],
      user: data["user_id"],
    ));
    questionController.answerfocus.unfocus();
    questionController.answertextController.clear();
  }

  Widget _buildTextComposer() {
    return Container(
      decoration: BoxDecoration(
        color: mainWhite,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffe7e7e7),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          cursorWidth: 1.2,
          focusNode: questionController.answerfocus,
          style: const TextStyle(decoration: TextDecoration.none),
          cursorColor: mainblack.withOpacity(0.6),
          controller: questionController.answertextController,
          onFieldSubmitted: _handleSubmitted,
          validator: (value) {
            if (value!.trim().isEmpty) {
              questionController.isemptytext.value = true;
            } else {
              questionController.isemptytext.value = false;
            }
          },
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            suffixIconConstraints: BoxConstraints(minWidth: 24),
            suffixIcon: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      _handleSubmitted(
                          questionController.answertextController.text);
                    },
                    child: Text(
                      '작성',
                      style: kButtonStyle.copyWith(color: mainblue),
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintText: "답변을 작성해주세요...",
            hintStyle: TextStyle(
              fontSize: 14,
              color: mainblack.withOpacity(0.38),
            ),
            fillColor: mainlightgrey,
            filled: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Arrow.svg',
          ),
          onPressed: () {
            questionController.contentcontroller.clear();
            Get.back();
          },
        ),
        title: "${questionController.questionModel2.questions.realname}님의 질문",
        actions: [
          Obx(
            () => IconButton(
                onPressed: () {
                  if (questionController.check_alarm.value) {
                    questionController.check_alarm.value = false;
                    modalController.showCustomDialog('알림이 취소되었어요', 1000);
                    NotificationController.to.fcmQuestionUnSubscribe(
                        questionController.questionModel2.questions.id
                            .toString());
                  } else {
                    questionController.check_alarm.value = true;
                    modalController.showCustomDialog('답글이 달리면 알림을 보내드려요', 1000);
                    print(questionController.questionModel2.questions.id);
                    NotificationController.to.fcmQuestionSubscribe(
                        questionController.questionModel2.questions.id
                            .toString());
                  }
                },
                icon: questionController.check_alarm.value == false
                    ? SvgPicture.asset(
                        'assets/icons/Bell_Inactive.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/Alert.svg',
                      )),
          ),
          IconButton(
              onPressed: () {
                modalController.showModalIOS(
                  context,
                  func1: () {},
                  func2: () {},
                  value1:
                      '${questionController.questionModel2.questions.realname}님에게 메시지 보내기',
                  value2: '이 질문 신고하기',
                  isValue1Red: false,
                  isValue2Red: true,
                  isOne: false,
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/More.svg',
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          questionController.answerfocus.unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: ListView(
                    children: [
                      Column(children: [
                        MessageQuestionWidget(
                          content: questionController
                              .questionModel2.questions.content,
                          image: questionController
                                  .questionModel2.questions.profileimage ??
                              "",
                          name: questionController
                              .questionModel2.questions.realname,
                          user:
                              questionController.questionModel2.questions.user,
                        ),
                        Obx(() => Column(
                              children:
                                  questionController.messageanswerlist.value,
                            )),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 56,
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter, child: _buildTextComposer())
          ],
        ),
      ),
    );
  }
}