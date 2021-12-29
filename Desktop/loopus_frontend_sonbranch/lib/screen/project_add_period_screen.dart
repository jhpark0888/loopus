// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';

class ProjectAddPeriodScreen extends StatelessWidget {
  ProjectAddPeriodScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: Color(0xffe7e7e7),
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/icons/Arrow.svg'),
        ),
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
        title: const Text(
          '활동 기간',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Center(
          child: Form(
            child: Column(
              children: [
                Text(
                  '언제부터 언제까지 진행하셨나요?',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '아직 종료되지 않은 활동이어도 괜찮아요',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autocorrect: false,
                        cursorWidth: 1.5,
                        cursorHeight: 16,
                        cursorRadius: Radius.circular(2),
                        controller: projectmakecontroller.startyearcontroller,
                        cursorColor: mainblack,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainblack, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainblack, width: 1),
                          ),
                          hintText: '2022',
                          hintStyle: TextStyle(
                            color: mainblack.withOpacity(0.38),
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        maxLength: 4,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '년',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: TextFormField(
                        focusNode: projectmakecontroller.startmonthFocusNode,
                        controller: projectmakecontroller.startmonthcontroller,
                        cursorColor: mainblack,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainblack, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainblack, width: 2),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            borderSide: BorderSide(color: mainblack, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainblack, width: 2),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                                borderSide:
                                    BorderSide(color: mainblack, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainblack, width: 2),
                              ),
                              hintText: '11',
                            ),
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
                      Text(
                        '월',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                                borderSide:
                                    BorderSide(color: mainblack, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainblack, width: 2),
                              ),
                              hintText: '11',
                            ),
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
                      Text(
                        '일 까지',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
