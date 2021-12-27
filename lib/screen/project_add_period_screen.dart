// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/datefield_end_widget.dart';
import 'package:loopus/widget/datefield_start_widget.dart';

class ProjectAddPeriodScreen extends StatelessWidget {
  ProjectAddPeriodScreen({Key? key}) : super(key: key);

  ProjectAddController projectaddcontroller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Get.to(() => ProjectAddTagScreen());
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: projectaddcontroller.ondatebutton.value
                      ? mainblue
                      : mainblack.withOpacity(0.38),
                ),
              ),
            ),
          ),
        ],
        title: '활동 기간',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    '언제부터 언제까지 진행하셨나요?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    '아직 종료되지 않은 활동이어도 괜찮아요',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StartDateTextFormField(
                        validator: (value) => validateDate(value!, 4),
                        controller: projectaddcontroller.startyearcontroller,
                        hinttext: '2021',
                        maxLenght: 4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '년',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      StartDateTextFormField(
                        validator: (value) => validateDate(value!, 2),
                        controller: projectaddcontroller.startmonthcontroller,
                        focusNode: projectaddcontroller.startmonthFocusNode,
                        hinttext: '08',
                        maxLenght: 2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '월',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      StartDateTextFormField(
                        validator: (value) => validateDate(value!, 2),
                        controller: projectaddcontroller.startdaycontroller,
                        focusNode: projectaddcontroller.startdayFocusNode,
                        hinttext: '08',
                        maxLenght: 2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '일 부터',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EndDateTextFormField(
                        validator: (value) => validateDate(value!, 4),
                        controller: projectaddcontroller.endyearcontroller,
                        focusNode: projectaddcontroller.endyearFocusNode,
                        hinttext: '2021',
                        maxLenght: 4,
                        isongoing: projectaddcontroller.isongoing,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          '년',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: projectaddcontroller.isongoing.value
                                ? mainblack.withOpacity(0.38)
                                : mainblack,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      EndDateTextFormField(
                        validator: (value) => validateDate(value!, 2),
                        controller: projectaddcontroller.endmonthcontroller,
                        focusNode: projectaddcontroller.endmonthFocusNode,
                        hinttext: '08',
                        maxLenght: 2,
                        isongoing: projectaddcontroller.isongoing,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          '월',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: projectaddcontroller.isongoing.value
                                ? mainblack.withOpacity(0.38)
                                : mainblack,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      EndDateTextFormField(
                        validator: (value) => validateDate(value!, 2),
                        controller: projectaddcontroller.enddaycontroller,
                        focusNode: projectaddcontroller.enddayFocusNode,
                        hinttext: '08',
                        maxLenght: 2,
                        isongoing: projectaddcontroller.isongoing,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          '일 까지',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: projectaddcontroller.isongoing.value
                                ? mainblack.withOpacity(0.38)
                                : mainblack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Checkbox(
                            activeColor: mainblue,
                            checkColor: mainWhite,
                            value: projectaddcontroller.isongoing.value,
                            onChanged: (bool? value) {
                              projectaddcontroller.isongoing(value);
                              projectaddcontroller.endyearcontroller.clear();
                              projectaddcontroller.endmonthcontroller.clear();
                              projectaddcontroller.enddaycontroller.clear();
                            }),
                      ),
                      Text(
                        '아직 진행 중이에요',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: mainblack),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validateDate(String value, int maxlenght) {
  if (value.isEmpty) {
    return '';
  } else {
    Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
    RegExp regExp = new RegExp(pattern.toString());
    if (regExp.hasMatch(value) || value.length != maxlenght) {
      return '';
    } else {
      return null;
    }
  }
}
