import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  NotificationDetailController notificationDetailController =
      Get.put(NotificationDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '알림',
      ),
      body: Obx(
        () => notificationDetailController.isNotificationloading.value
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/loading.gif',
                        scale: 5,
                      ),
                    ]),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        "루프 요청",
                        style: kSubTitle2Style,
                      ),
                    ),
                    Obx(
                      () => Column(
                        children:
                            notificationDetailController.followalarmlist.value,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        "알림",
                        style: kSubTitle2Style,
                      ),
                    ),
                    Obx(
                      () => Column(
                        children: notificationDetailController.alarmlist.value,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
