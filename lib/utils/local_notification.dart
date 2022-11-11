import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart' as person;
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';

LocalNotificaition localNotificaition = LocalNotificaition();

class LocalNotificaition {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initLocalNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/launcher_icon');
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: darwinInitializationSettings,
            macOS: darwinInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);

    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'high_importance_channel', // 임의의 id
      'High Importance Notifications', // 설정에 보일 채널명
      importance: Importance.high,
    );

    // Notification Channel을 디바이스에 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void requestPermission() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true,critical: true);
  }

  void onSelectNotification(NotificationResponse? payload) {
    try {
      print('눌림');
      print(payload!.payload);
      Map<String, dynamic> json = jsonDecode(payload.payload!);
      if (json['type'] == 'msg') {
        print('눌림');
        HomeController.to.isNewMsg(true);
        int partnerId = int.parse(json['sender']);
        getUserProfile([partnerId]).then((user) async {
          if (user.isError == false) {
            Get.to(() => MessageDetatilScreen(
                  partner: person.Person.fromJson(user.data['profile'].first),
                  myProfile: HomeController.to.myProfile.value,
                  enterRoute: EnterRoute.popUp,
                ));
            HomeController.to.enterMessageRoom.value =
                user.data['profile'].first['user_id'];

            await SQLController.to.findMessageRoom(
                roomid: int.parse(json['room_id']),
                chatRoom: ChatRoom.fromMsg(json).toJson());
          }
        });
      } else {
        int id = int.parse(json['id']);
        int type = int.parse(json['type']);
        int senderId = int.parse(json['sender_id']);
        if (type == 4 || type == 7) {
          Get.to(() => PostingScreen(postid: id));
        } else if (type == 5 || type == 6 || type == 8) {
          int? postId =
              json['post_id'] != null ? int.parse(json['post_id']) : null;
          Get.to(() => PostingScreen(postid: postId!),
              preventDuplicates: false);
        } else if (type == 2) {
          Get.to(() => OtherProfileScreen(userid: senderId, realname: '김원우'));
        }
        isNotiRead(id);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sampleNotification(
      String title, String body, Map<String, dynamic> noti) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.max,
            playSound: true,
            //sound:
            showWhen: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(presentSound: true));
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: jsonEncode(noti));
  }

  NotificationType convertType(int type) {
    NotificationType notiType = type == 2
        ? NotificationType.follow
        : type == 3
            ? NotificationType.careerTag
            : type == 4
                ? NotificationType.postLike
                : type == 5
                    ? NotificationType.commentLike
                    : type == 6
                        ? NotificationType.replyLike
                        : type == 7
                            ? NotificationType.comment
                            : NotificationType.reply;
    return notiType;
  }
}
