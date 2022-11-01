// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/contact_content_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/contact_finish_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class ContactContentScreen extends StatelessWidget {
  ContactContentScreen({Key? key}) : super(key: key);
  final ContactContentController _contactContentController =
      Get.put(ContactContentController());
  final ProfileController _profileController = Get.find();
  bool isBlue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '문의',
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              await inquiryRequest(InquiryType.normal).then((value) {
                if (value.isError == false) {
                  showCustomDialog("문의가 접수되었습니다", 1000);
                  Get.to(ContactFinishScreen());
                } else {
                  errorSituation(value);
                }
              });
            },
            child: Text(
              '확인',
              style: kNavigationTitle.copyWith(
                  color: isBlue ? rankblue : maingray),
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
              style: kmainbold.copyWith(height: 1.5),
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: _contactContentController.emailcontroller,
              hintText: '답변 받으실 이메일 주소를 입력해 주세요',
              validator: null,
              obscureText: false,
              maxLines: 5,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              '문의 내용',
              style: kmainbold.copyWith(height: 1.5),
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: _contactContentController.contentcontroller,
              hintText: '문의 내용을 입력해주세요',
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
            // Text(_profileController.myUserInfo.value.name),
            // Text(_profileController.myUserInfo.value.department),
            // Text(_profileController.myUserInfo.value.userid.toString()),
          ],
        ),
      ),
    );
  }
}
