import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/message_widget.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = <String, dynamic>{}.obs;

  @override
  void onInit() {
    _initNotification();
    getToken();
    //Foreground 상태에서 알림을 받았을 때
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      print(event.data["type"]);
      if (event.data["type"] == "msg") {
        try {
          String? myid = await const FlutterSecureStorage().read(key: 'id');
          Get.find<MessageDetailController>(tag: event.data["id"].toString())
              .messagelist
              .insert(
                  0,
                  MessageWidget(
                      message: Message(
                          roomId: 0,
                          receiverId: int.parse(myid!),
                          date: DateTime.now(),
                          message: event.notification!.body!,
                          isRead: true,
                          issender: 0,
                          issending: true.obs),
                      user: Get.find<MessageDetailController>(
                              tag: event.data["id"].toString())
                          .user!
                          .value));
        } catch (e) {
          ModalController.to.showCustomSnackbar(
            event.notification!.title,
            event.notification!.body,
          );
        }
      } else {
        ModalController.to.showCustomSnackbar(
          event.notification!.title,
          event.notification!.body,
        );
      }

      print(event.notification!.body);
    });
    //Background, Killed 상태에서 알림을 받고, 그 알림을 클릭해서 앱에 접근했을 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      print('a');
      return;
    });

    super.onInit();
  }

  //사용자 고유의 알림 토근 가져오기
  Future<String?> getToken() async {
    try {
      String? userMessageToken = await messaging.getToken(
          //TODO: WEB KEY 추가
          // vapidKey:
          //     'BCLIUKVcUhNC9-qwvJ01m_YQ3l46lrehYmmBVcXOtMp21iwY6x-EKTOLg8v4wNPNRcjrLMReFfAq0ohfvHjWZOw',
          );
      // messaging.deleteToken();
      print('token : $userMessageToken');
      return userMessageToken ?? '';
    } catch (e) {
      print(e);
    }
  }

  //알림 권한 요청
  void _initNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      if (Platform.isIOS) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //특정 질문에 알림을 설정한 사람들 그룹 지정
  void fcmQuestionSubscribe(String id) async {
    await messaging.subscribeToTopic('question$id');
  }

  //특정 질문에 알림을 해제한 사람들 또는 만료된 그룹 해제
  void fcmQuestionUnSubscribe(String id) async {
    await messaging.unsubscribeFromTopic('question$id');
  }
}
