// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/contact_content_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/contact_finish_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class ContactContentScreen extends StatelessWidget {
  ContactContentScreen({Key? key}) : super(key: key);
  final ContactContentController _contactContentController =
      Get.put(ContactContentController());
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '문의',
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              inquiry();
              Get.to(ContactFinishScreen());
            },
            child: Text(
              '보내기',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '답변 받으실 이메일 주소',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: _contactContentController.emailcontroller,
              hintText: '이메일 주소',
              validator: null,
              obscureText: false,
              maxLines: 5,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              '문의 내용',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: _contactContentController.contentcontroller,
              hintText: '문의 내용',
              validator: null,
              obscureText: false,
              maxLines: 12,
            ),
            //todo: 아래 정보들을 메일에 함께 보내야 함
            // Obx(
            //   () => _userDeviceInfo.deviceData.isNotEmpty
            //       ? Text(
            //           "${_userDeviceInfo.deviceData.keys.first} : ${_userDeviceInfo.deviceData.values.first}\n${_userDeviceInfo.deviceData.keys.last} : ${_userDeviceInfo.deviceData.values.last}")
            //       : Text(''),
            // ),
            // Obx(
            //   () => _userDeviceInfo.appInfoData.isNotEmpty
            //       ? Text(
            //           _userDeviceInfo.appInfoData.keys.first +
            //               ' ' +
            //               _userDeviceInfo.appInfoData.values.first,
            //           style: kCaptionStyle.copyWith(
            //             color: mainblack.withOpacity(0.6),
            //           ),
            //         )
            //       : Text(''),
            // ),
            // Text(_profileController.myUserInfo.value.realName),
            // Text(_profileController.myUserInfo.value.department),
            // Text(_profileController.myUserInfo.value.userid.toString()),
          ],
        ),
      ),
    );
  }
}
