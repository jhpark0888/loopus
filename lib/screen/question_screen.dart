import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/report_screen.dart';
import 'package:loopus/widget/alertdialog2_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionScreen extends StatelessWidget {
  ModalController modalController = Get.put(ModalController());
  final _formKey = GlobalKey<FormState>();

  // const QuestionScreen({Key? key}) : super(key: key);

  QuestionController questionController = Get.find();
  late Map data;

  void _handleSubmitted(String text) async {
    print(text);
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
      child: Obx(
        () => Form(
          key: _formKey,
          onChanged: () {
            print(questionController.answertextController.value.text);
            questionController.textBoxSize.value = questionController
                .getSize(questionController.textFieldBoxKey.value);

            print(questionController.textBoxSize.value.height);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  key: questionController.textFieldBoxKey.value,
                  cursorWidth: 1.2,
                  focusNode: questionController.answerfocus,
                  style: TextStyle(decoration: TextDecoration.none),
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
                    suffix: Text('작성'),
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintText: "답변 남기기...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: mainblack.withOpacity(0.38),
                    ),
                    fillColor: mainlightgrey,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Obx(
                () => SizedBox(
                  height: questionController.textBoxSize.value.height > 36
                      ? questionController.textBoxSize.value.height - 16
                      : questionController.textBoxSize.value.height,
                  child: Align(
                    alignment: questionController.textBoxSize.value.height > 36
                        ? Alignment.bottomRight
                        : Alignment.center,
                    child: IgnorePointer(
                      ignoring: questionController.isemptytext.value,
                      child: questionController.answertextController.text == ""
                          ? InkWell(
                              onTap: () {},
                              child: Text(
                                "작성",
                                style: TextStyle(
                                  color: mainblack.withOpacity(0.38),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _handleSubmitted(questionController
                                    .answertextController.text);
                              },
                              child: Text(
                                "작성",
                                style: TextStyle(
                                  color: mainblue,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
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
                    modalController.showCustomDialog('알림이 취소되었어요', 1);
                    NotificationController.to.fcmUnSubscribe(questionController
                        .questionModel2.questions.id
                        .toString());
                  } else {
                    questionController.check_alarm.value = true;
                    modalController.showCustomDialog('답글이 달리면 알림을 보내드려요', 1);
                    print(questionController.questionModel2.questions.id);
                    NotificationController.to.fcmSubscribe(questionController
                        .questionModel2.questions.id
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
                SizedBox(
                  height: 50,
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
