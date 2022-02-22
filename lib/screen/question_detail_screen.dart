import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/report_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/question_answer_widget.dart';
import 'package:loopus/widget/question_detail_widget.dart';

class QuestionDetailScreen extends StatelessWidget {
  QuestionDetailScreen({
    required this.questionid,
    required this.isuser,
    required this.realname,
    Key? key,
  }) : super(key: key);
  ModalController modalController = Get.put(ModalController());
  // final _formKey = GlobalKey<FormState>();

  late QuestionDetailController questionController = Get.put(
      QuestionDetailController(questionid: questionid),
      tag: questionid.toString());
  int questionid;
  int isuser;
  String realname;
  // RxInt numLines = 0.obs;

  void _handleSubmitted(String text) async {
    if (questionController.isSendButtonon.value) {
      answermake(text, questionController.question.value.id);
    }
  }

  Widget _buildTextComposer() {
    return Container(
      key: questionController.textFieldBoxKey.value,
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
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        cursorWidth: 1.2,
        focusNode: questionController.answerfocus,
        style: const TextStyle(decoration: TextDecoration.none),
        cursorColor: mainblack.withOpacity(0.6),
        controller: questionController.answertextController,
        onFieldSubmitted: _handleSubmitted,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '작성',
                      style: kButtonStyle.copyWith(
                          color: questionController.isSendButtonon.value
                              ? mainblue
                              : mainblack.withOpacity(0.38)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(children: [
        Scaffold(
          bottomNavigationBar: Transform.translate(
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: BottomAppBar(
              elevation: 0,
              child: _buildTextComposer(),
            ),
          ),
          appBar: AppBarWidget(
            bottomBorder: false,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Arrow.svg',
              ),
              onPressed: () {
                questionController.answertextController.clear();
                Get.back();
              },
            ),
            title: "${realname}님의 질문",
            actions: [
              Obx(
                () => IconButton(
                    onPressed: () {
                      if (questionController.checkAlert.value) {
                        questionController.checkAlert.value = false;
                        modalController.showCustomDialog('알림이 취소되었어요', 1000);
                        NotificationController.to.fcmQuestionUnSubscribe(
                            questionController.question.value.id.toString());
                      } else {
                        questionController.checkAlert.value = true;
                        modalController.showCustomDialog(
                            '답글이 달리면 알림을 보내드려요', 1000);
                        print(questionController.question.value.id);
                        NotificationController.to.fcmQuestionSubscribe(
                            questionController.question.value.id.toString());
                      }
                    },
                    icon: questionController.checkAlert.value == false
                        ? SvgPicture.asset(
                            'assets/icons/Bell_Inactive.svg',
                            width: 28,
                          )
                        : SvgPicture.asset(
                            'assets/icons/Alert.svg',
                            width: 28,
                          )),
              ),
              IconButton(
                  onPressed: isuser == 1
                      ? () {
                          modalController.showModalIOS(
                            context,
                            func1: () {
                              modalController.showButtonDialog(
                                  leftText: '취소',
                                  rightText: '삭제',
                                  title: '질문을 삭제하시겠어요?',
                                  content: '삭제한 질문은 복구할 수 없어요',
                                  leftFunction: () => Get.back(),
                                  rightFunction: () {
                                    getbacks(2);
                                    questionController
                                        .isQuestionDeleteLoading(true);
                                    deletequestion(questionController
                                            .question.value.id)
                                        .then((value) {
                                      questionController
                                          .isQuestionDeleteLoading(false);
                                    });
                                  });
                            },
                            func2: () {},
                            value1: '이 질문 삭제하기',
                            value2: '',
                            isValue1Red: true,
                            isValue2Red: false,
                            isOne: true,
                          );
                        }
                      : () {
                          modalController.showModalIOS(
                            context,
                            func1: () {
                              Get.put(
                                      MessageDetailController(
                                        userid: questionController
                                            .question.value.userid,
                                      ),
                                      tag: questionController
                                          .question.value.user.userid
                                          .toString())
                                  .firstmessagesload();
                              Get.to(() => MessageDetailScreen(
                                    userid: questionController
                                        .question.value.userid,
                                    realname: questionController
                                        .question.value.user.realName,
                                    user:
                                        questionController.question.value.user,
                                  ));
                            },
                            func2: () {},
                            value1:
                                '${questionController.question.value.user.realName}님에게 메시지 보내기',
                            value2: '이 질문 신고하기',
                            isValue1Red: false,
                            isValue2Red: true,
                            isOne: false,
                          );
                        },
                  icon: SvgPicture.asset(
                    'assets/icons/More.svg',
                    width: 28,
                  ))
            ],
          ),
          body: Obx(() => questionController.questionscreenstate.value ==
                  ScreenState.loading
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '내용을 받는 중이에요...',
                          style: TextStyle(
                            fontSize: 10,
                            color: mainblue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ]),
                )
              : questionController.questionscreenstate.value ==
                      ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      questionController.loadquestion(questionid);
                    })
                  : questionController.questionscreenstate.value ==
                          ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          questionController.loadquestion(questionid);
                        })
                      : GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            questionController.answerfocus.unfocus();
                          },
                          child: QuestionListView(
                            questionid: questionid,
                          ),
                        )),
        ),
        if (questionController.isQuestionDeleteLoading.value)
          Container(
            height: Get.height,
            width: Get.width,
            color: mainblack.withOpacity(0.3),
            child: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
      ]),
    );
  }
}

class QuestionListView extends StatelessWidget {
  QuestionListView({Key? key, required this.questionid}) : super(key: key);

  int questionid;
  late QuestionDetailController questionController =
      Get.find(tag: questionid.toString());
  late QuestionScrollController questionscrollController =
      Get.put(QuestionScrollController(questionid: questionid));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      controller: questionscrollController.questionscrollController,
      child: Column(
        children: [
          Obx(
            () => Padding(
              padding: EdgeInsets.only(
                  bottom: questionController.keyboardController.isVisible
                      ? questionController.textBoxSize.value.height
                      : 0),
              child: Column(
                children: [
                  QuestionDetailWidget(
                    question: questionController.question.value,
                  ),
                  Container(
                    color: Color(0xffe7e7e7),
                    height: 1,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      right: 16,
                      left: 16,
                      top: 20,
                      bottom: 12,
                    ),
                    child: Obx(
                      () => Text(
                        "답변 ${questionController.answerlist.length}개",
                        style: kSubTitle2Style,
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
                      children: (questionController.answerlist.value.isNotEmpty)
                          ? questionController.answerlist.value
                          : [
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                '아직 답변이 달리지 않았어요',
                                style: kSubTitle3Style.copyWith(
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
