import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/before_message_detail_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/firebase_options.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/before_message_detail_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/notification_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/screen/signup_email_pw_screen.dart';
import 'package:loopus/screen/signup_fail_screen.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:loopus/trash_bin/question_detail_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/local_notification.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';
import 'package:loopus/widget/notification_widget.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = <String, dynamic>{}.obs;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _backgroundMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_backgroundMessage);
  }

  void _backgroundMessage(RemoteMessage message) {
    int id = int.parse(message.data["id"]);
    if (message.data["type"] == "msg") {
      // Get.put(MessageDetailController(userid: id)).firstmessagesload();
      Map<String, dynamic> json = message.data;
      json["date"] = DateTime.now().toString();
      json["content"] = message.notification!.body;
      int partnerId = int.parse(message.data['sender']);
      getUserProfile([partnerId]).then((user) async {
        if (user.isError == false) {
          Get.to(() => MessageDetatilScreen(
                partner: user.data[0],
                myProfile: HomeController.to.myProfile.value,
                enterRoute: EnterRoute.popUp,
              ));
          HomeController.to.enterMessageRoom.value = user.data.first.userid;

          await SQLController.to.findMessageRoom(
              roomid: int.parse(json['room_id']),
              chatRoom: ChatRoom.fromMsg(json).toJson());
        }
      });
    } else if (message.data["type"] == "like") {
      Get.to(() => NotificationScreen());
    } else if (message.data["type"] == "tag") {
      // Get.to(() => ProjectScreen(projectid: id, isuser: 0));
    } else if (message.data["type"] == "follow") {
      Get.to(() =>
          OtherProfileScreen(userid: id, realname: message.data["real_name"]));
    } else if (message.data["type"] == "answer") {
      // Get.to(() => QuestionDetailScreen(
      //     questionid: id, isuser: 1, realname: message.data["real_name"]));
    }
    print("message: ${message.data["type"]}");
  }

  @override
  void onInit() {
    _initNotification();
    getToken();
    //Foreground 상태에서 알림을 받았을 때
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      print(event);
      print(event.data["type"]);
      print('알림 데이터 : ${event.data}');
      if (event.data["type"] == "msg") {
        HomeController.to.isNewMsg(true);
        localNotificaition.sampleNotification(event.notification!.title!, event.notification!.body!);
        if (Get.isRegistered<MessageController>()) {
          String? myid = await const FlutterSecureStorage().read(key: 'id');
          SQLController.to
              .updateNotReadCount(int.parse(event.data['room_id']), 1);
          Map<String, dynamic> json = event.data;
          json["date"] = DateTime.now().toString();
          json["content"] = event.notification!.body;
          json["not_read"] = 1;
          Chat chat = Chat.fromMsg(json, int.parse(json['room_id']));
          ChatRoom chatRoom = ChatRoom.fromMsg(json);
          SQLController.to
              .findMessageRoom(
                  roomid: chat.roomId!, chatRoom: chatRoom.toJson())
              .then((value) async {
            if (value == false) {
              await getUserProfile([chatRoom.user]).then((value) async {
                if (value.isError == false) {
                  await SQLController.to.insertUser(value.data[0]);
                  MessageController.to.searchRoomList.add(MessageRoomWidget(
                      chatRoom: chatRoom.obs, user: Rx<User>(value.data[0])));
                  MessageController.to.chattingRoomList.add(MessageRoomWidget(
                      chatRoom: chatRoom.obs, user: Rx<User>(value.data[0])));
                }
              });
            } else {
              SQLController.to.updateLastMessage(
                  chat.content, chat.date.toString(), chat.roomId!);
              MessageController.to.searchRoomList
                  .where((p0) => p0.chatRoom.value.roomId == chat.roomId)
                  .first
                  .chatRoom
                  .value
                  .message
                  .value
                  .content = json['content'];
              MessageController.to.searchRoomList
                  .where((p0) => p0.chatRoom.value.roomId == chat.roomId)
                  .first
                  .chatRoom
                  .value
                  .message
                  .value
                  .date = DateTime.parse(json['date']);
              MessageController.to.searchRoomList
                  .where((p0) => p0.chatRoom.value.roomId == chat.roomId)
                  .first
                  .chatRoom
                  .value
                  .notread
                  .value += 1;
              MessageController.to.searchRoomList.refresh();
              MessageController.to.searchRoomList
                  .where((p0) => p0.chatRoom.value.roomId == chat.roomId)
                  .first
                  .chatRoom
                  .refresh();
            }
            MessageController.to.searchRoomList.sort((a, b) => b
                .chatRoom.value.message.value.date
                .compareTo(a.chatRoom.value.message.value.date));
          });
        }
      } else if (event.data["type"] == "certification") {
        if (Get.isRegistered<SignupController>()) {
          SignupController _signupController = Get.find();
          _signupController.signupcertification(Emailcertification.success);
          _signupController.timer
              .timerClose(dialogOn: false, stateChange: false);
          loading();
          await signupRequest().then((value) async {
            final GAController _gaController = GAController();

            if (value.isError == false) {
              await _gaController.logSignup();
              await _gaController.setUserProperties(value.data['user_id'],
                  _signupController.selectDept.value.deptname);
              await _gaController.logScreenView('signup_6');
              Get.back();
              Get.offAll(() => SignupCompleteScreen(
                    emailId: _signupController.emailidcontroller.text +
                        "@" +
                        _signupController.selectUniv.value.email,
                    password: _signupController.passwordcontroller.text,
                  ));
            } else {
              await _gaController.logScreenView('signup_6');
              // errorSituation(value);
              Get.back();
              Get.offAll(
                  () => SignupFailScreen(signupController: _signupController));
            }
          });
        } else if (Get.isRegistered<PwChangeController>()) {
          PwChangeController.to.pwcertification(Emailcertification.success);
          PwChangeController.to.timer
              .timerClose(dialogOn: false, stateChange: false);
          Get.to(() => PwChangeScreen(pwType: PwType.pwfind));
        }
      } else {
        HomeController.to.isNewAlarm(true);
        int type = int.parse(event.data['type']);
        int id = int.parse(event.data['id']);
        int? post_id = event.data['post_id'] != null
            ? int.parse(event.data['post_id'])
            : null;
        int senderId = int.parse(event.data['sender_id']);
        showCustomSnackbar(event.notification!.title, event.notification!.body,
            (snackbar) {
          if (type == 4 || type == 7) {
            Get.to(() => PostingScreen(postid: id));
          } else if (type == 5 || type == 6 || type == 8) {
            Get.to(() => PostingScreen(postid: post_id!));
          } else if (type == 2) {
            Get.to(() => OtherProfileScreen(userid: senderId, realname: '김원우'));
          }
          isRead(id, convertType(type), senderId);
        });
        if (Get.isRegistered<NotificationDetailController>()) {
          NotificationDetailController.to.alarmRefresh();
        }
      }

      // print(event.notification!.body);
    });

    //Background, Killed 상태에서 알림을 받고, 그 알림을 클릭해서 앱에 접근했을 때
    setupInteractedMessage();

    // Background, Killed 상태에서 알림을 받았을 때
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      print(event);
    });
    super.onInit();
  }

  //사용자 고유의 알림 토근 가져오기
  static Future<String?> getToken() async {
    try {
      String? userMessageToken = await FirebaseMessaging.instance.getToken(
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
      provisional: false,
      announcement: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      try {
        if (Platform.isIOS) {
          await messaging.setForegroundNotificationPresentationOptions(
            alert: true, // Required to display a heads up notification
            badge: true,
            sound: true,
          );
        }
      } catch (e) {
        print(e);
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

  void changePromotionAlarmState(bool isSelected) async {
    if (isSelected) {
      await messaging.subscribeToTopic('promotion');
    } else {
//특정 질문에 알림을 해제한 사람들 또는 만료된 그룹 해제

      await messaging.unsubscribeFromTopic('promotion');
    }
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
