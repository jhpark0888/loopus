import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

import '../constant.dart';

class AlertScreen extends StatefulWidget {
  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final LocalDataController _localDataController =
      Get.put(LocalDataController());

  final NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '알림',
        bottomBorder: false,
      ),
      body: Column(
        children: [
          CustomListTile(
              onTap: () {
                AppSettings.openNotificationSettings();
              },
              title: '시스템 알림 설정',
              hoverTag: '시스템 알림 설정'),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('프로모션 알림 설정', style: kSubTitle3Style),
                if (Platform.isAndroid)
                  Switch(
                      activeColor: mainblue,
                      inactiveTrackColor: maingrey,
                      value: _localDataController.isUserAgreeProNoti,
                      onChanged: (bool val) {
                        setState(() {
                          _localDataController.agreeProNoti(val);
                          _notificationController.changePromotionAlarmState(
                              _localDataController.isUserAgreeProNoti);
                          if (_localDataController.isUserAgreeProNoti) {
                            ModalController.to.showCustomDialog(
                                '프로모션 알림 수신에 동의하셨습니다\n' +
                                    '(${DateFormat('yy.MM.dd').format(DateTime.now())})',
                                1000);
                          }
                        });
                      }),
                if (Platform.isIOS)
                  CupertinoSwitch(
                      activeColor: mainblue,
                      value: _localDataController.isUserAgreeProNoti,
                      onChanged: (bool val) {
                        setState(() {
                          _localDataController.agreeProNoti(val);
                          _notificationController.changePromotionAlarmState(
                              _localDataController.isUserAgreeProNoti);
                          if (_localDataController.isUserAgreeProNoti) {
                            ModalController.to.showCustomDialog(
                                '프로모션 알림 수신에 동의하셨습니다\n' +
                                    '(${DateFormat('yy.MM.dd').format(DateTime.now())})',
                                1000);
                          }
                        });
                      }),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '프로모션 알림을 설정해도 알림이 오지 않는다면, 시스템 알림 설정을 확인해보세요.',
              style: kCaptionStyle.copyWith(color: mainblack.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
