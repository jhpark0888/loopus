// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectAddPeriodScreen extends StatelessWidget {
  ProjectAddPeriodScreen({Key? key}) : super(key: key);

  ProjectAddController projectmakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ProjectAddTagScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainblue,
              ),
            ),
          ),
        ],
        title: '활동 추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
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
                      Container(
                        child: TextFormField(
                          controller: projectmakecontroller.startyearcontroller,
                          cursorColor: mainblack,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            hintText: '2021',
                          ),
                          textAlign: TextAlign.center,
                          maxLength: 4,
                        ),
                        height: 24,
                        width: 48,
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
                      Container(
                        child: TextFormField(
                          focusNode: projectmakecontroller.startmonthFocusNode,
                          controller:
                              projectmakecontroller.startmonthcontroller,
                          cursorColor: mainblack,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            hintText: '08',
                          ),
                          textAlign: TextAlign.center,
                          maxLength: 2,
                        ),
                        height: 24,
                        width: 48,
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
                      Container(
                        child: TextFormField(
                          focusNode: projectmakecontroller.startdayFocusNode,
                          controller: projectmakecontroller.startdaycontroller,
                          cursorColor: mainblack,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainblack, width: 2),
                            ),
                            hintText: '08',
                          ),
                          textAlign: TextAlign.center,
                          maxLength: 2,
                        ),
                        height: 24,
                        width: 48,
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
                      Container(
                        child: Obx(
                          () => TextFormField(
                            focusNode: projectmakecontroller.endyearFocusNode,
                            readOnly: projectmakecontroller.isongoing.value,
                            controller: projectmakecontroller.endyearcontroller,
                            cursorColor: mainblack,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                hintText: '2021',
                                hintStyle: TextStyle(
                                    color: projectmakecontroller.isongoing.value
                                        ? mainblack.withOpacity(0.38)
                                        : null)),
                            textAlign: TextAlign.center,
                            maxLength: 4,
                          ),
                        ),
                        height: 24,
                        width: 48,
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
                            color: projectmakecontroller.isongoing.value
                                ? mainblack.withOpacity(0.38)
                                : mainblack,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Obx(
                          () => TextFormField(
                            focusNode: projectmakecontroller.endmonthFocusNode,
                            readOnly: projectmakecontroller.isongoing.value,
                            controller:
                                projectmakecontroller.endmonthcontroller,
                            cursorColor: mainblack,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                hintText: '11',
                                hintStyle: TextStyle(
                                    color: projectmakecontroller.isongoing.value
                                        ? mainblack.withOpacity(0.38)
                                        : null)),
                            textAlign: TextAlign.center,
                            maxLength: 2,
                          ),
                        ),
                        height: 24,
                        width: 48,
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
                            color: projectmakecontroller.isongoing.value
                                ? mainblack.withOpacity(0.38)
                                : mainblack,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Obx(
                          () => TextFormField(
                            focusNode: projectmakecontroller.enddayFocusNode,
                            readOnly: projectmakecontroller.isongoing.value,
                            controller: projectmakecontroller.enddaycontroller,
                            cursorColor: mainblack,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          projectmakecontroller.isongoing.value
                                              ? mainblack.withOpacity(0.38)
                                              : mainblack,
                                      width: 2),
                                ),
                                hintText: '11',
                                hintStyle: TextStyle(
                                    color: projectmakecontroller.isongoing.value
                                        ? mainblack.withOpacity(0.38)
                                        : null)),
                            textAlign: TextAlign.center,
                            maxLength: 2,
                          ),
                        ),
                        height: 24,
                        width: 48,
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
                            color: projectmakecontroller.isongoing.value
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Checkbox(
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            value: projectmakecontroller.isongoing.value,
                            onChanged: (bool? value) {
                              projectmakecontroller.isongoing(value);
                              projectmakecontroller.endyearcontroller.clear();
                              projectmakecontroller.endmonthcontroller.clear();
                              projectmakecontroller.enddaycontroller.clear();
                            }),
                      ),
                      Text(
                        '아직 진행 중이에요',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
