import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = Map<String, dynamic>().obs;

  @override
  void onInit() {
    _initNotification();
    getToken();
    //Foreground 상태에서 알림을 받았을 때
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    //Background, Killed 상태에서 알림을 받고, 그 알림을 클릭해서 앱에 접근했을 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('a');
    //   return
    // });

    super.onInit();
  }

  //사용자 고유의 알림 토근 가져오기
  Future<String?> getToken() async {
    try {
      String? userMessageToken = await messaging.getToken();
      // messaging.deleteToken();
      print('token : $userMessageToken');
      return userMessageToken;
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

  void fcmSubscribe(String id) async {
    await messaging.subscribeToTopic(id);
  }

  //특정 질문 등에 알림을 해제한 사람들 또는 만료된 그룹 해제
  void fcmUnSubscribe(String id) async {
    await messaging.unsubscribeFromTopic(id);
  }
}
