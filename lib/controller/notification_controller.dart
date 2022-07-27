import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/before_message_detail_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/firebase_options.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/before_message_detail_screen.dart';
import 'package:loopus/screen/notification_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:loopus/trash_bin/question_detail_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await const FlutterSecureStorage().write(key: "login detect", value: 'true');
  // if (message.data["type"] == 'logout') {
  //   showoneButtonDialog(
  //     title: '로그인 감지',
  //     content: '다른 기기에서 해당 계정으로 로그인 하여 로그아웃합니다',
  //     oneFunction: () {
  //       AppController.to.currentIndex.value = 0;
  //       FlutterSecureStorage().delete(key: "token");
  //       FlutterSecureStorage().delete(key: "id");

  //       Get.delete<AppController>();
  //       Get.delete<HomeController>();
  //       Get.delete<SearchController>();
  //       Get.delete<ProfileController>();
  //       Get.offAll(() => StartScreen());
  //     },
  //     oneText: '확인',
  //   );
  // }
}

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
          getPartnerToken(partnerId).then((token) {
            Get.to(() => MessageDetatilScreen(
                  partner: user.data[0],
                  myProfile: HomeController.to.myProfile.value,
                  partnerToken: token.data,
                  enterRoute: EnterRoute.popUp,
                ));
            HomeController.to.enterMessageRoom.value = user.data.first.userid;
          });
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
        if (Get.isRegistered<MessageDetailController>(
            tag: event.data['sender'].toString())) {
          String? myid = await const FlutterSecureStorage().read(key: 'id');
          // Get.find<MessageDetailController>(tag: event.data["id"].toString())
          //     .messagelist
          //     .add(
          //       MessageWidget(
          //         message: Message(
          //             id: 0,
          //             roomId: 0,
          //             receiverId: int.parse(myid!),
          //             date: DateTime.now(),
          //             message: event.notification!.body!,
          //             isRead: true,
          //             issender: 0,
          //             issending: true.obs),
          //         user: Get.find<MessageDetailController>(
          //                 tag: event.data["id"].toString())
          //             .user!
          //             .value)
          //             );
          // 새로 추가
          // putonmessagescreen(event.data["id"].toString());

          if (Get.isRegistered<MessageController>()) {
            // MessageRoomWidget messageroomwidget = MessageController
            //     .to.chattingroomlist
            //     .where((messageroomwidget) =>
            //         messageroomwidget.messageRoom.value.user.userid ==
            //         int.parse(event.data["id"]))
            //     .first;
            // messageroomwidget.messageRoom.value.message.value = Message(
            //     id: 0,
            //     roomId: 0,
            //     receiverId: int.parse(myid),
            //     date: DateTime.now(),
            //     message: event.notification!.body!,
            //     isRead: false,
            //     issender: 0,
            //     issending: true.obs);
            // MessageController.to.chattingroomlist.remove(messageroomwidget);
            // MessageController.to.chattingroomlist.insert(0, messageroomwidget);

          }
        } else {
          if (Get.isRegistered<MessageController>()) {
            String? myid = await const FlutterSecureStorage().read(key: 'id');
            HomeController.to.isNewMsg(true);
            SQLController.to.updateNotReadCount(int.parse(event.data['room_id']),1);
            showCustomSnackbar(
                event.notification!.title, event.notification!.body,
                (snackbar) async {
              Get.back();
              int partnerId = int.parse(event.data['sender']);
              getUserProfile([partnerId]).then((user) async {
                if (user.isError == false) {
                  getPartnerToken(partnerId).then((token) {
                    if (Get.isRegistered<MessageDetailController>(
                        tag: HomeController.to.enterMessageRoom.value
                            .toString())) {
                      Get.delete<MessageDetailController>(
                          tag: HomeController.to.enterMessageRoom.value
                              .toString());
                      Future.delayed(const Duration(milliseconds: 100));
                      Get.off(
                          () => MessageDetatilScreen(
                                partner: user.data[0],
                                myProfile: HomeController.to.myProfile.value,
                                partnerToken: token.data,
                                enterRoute: EnterRoute.popUp,
                              ),
                          preventDuplicates: false);
                    } else {
                      Get.to(
                          () => MessageDetatilScreen(
                                partner: user.data[0],
                                myProfile: HomeController.to.myProfile.value,
                                partnerToken: token.data,
                                enterRoute: EnterRoute.popUp,
                              ),
                          preventDuplicates: true);
                    }

                    HomeController.to.enterMessageRoom.value =
                        user.data.first.userid;
                  });
                }
              });
            });

            // MessageRoomWidget messageroomwidget = MessageController
            //     .to.chattingroomlist
            //     .where((messageroomwidget) =>
            //         messageroomwidget.messageRoom.value.user.userid ==
            //         int.parse(event.data["id"]))
            //     .first;
            // messageroomwidget.messageRoom.value.notread.value += 1;
            // messageroomwidget.messageRoom.value.message.value = Message(
            //     id: 0,
            //     roomId: 0,
            //     receiverId: int.parse(myid!),
            //     date: DateTime.now(),
            //     message: event.notification!.body!,
            //     isRead: false,
            //     issender: 0,
            //     issending: true.obs);
            // MessageController.to.chattingroomlist.remove(messageroomwidget);
            // MessageController.to.chattingroomlist.insert(0, messageroomwidget);
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
                await getUserProfile([chatRoom.user]).then((value) {
                  if (value.isError == false) {
                    MessageController.to.searchRoomList.add(MessageRoomWidget(
                        chatRoom: chatRoom.obs,
                        userid: chatRoom.user,
                        user: value.data[0]));
                    MessageController.to.chattingRoomList.add(MessageRoomWidget(
                        chatRoom: chatRoom.obs,
                        userid: chatRoom.user,
                        user: value.data[0]));
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
          } else {
            HomeController.to.isNewMsg(true);
            SQLController.to.updateNotReadCount(int.parse(event.data['room_id']),1);
            Map<String, dynamic> json = event.data;
            json["date"] = DateTime.now().toString();
            json["content"] = event.notification!.body;
            Chat chat = Chat.fromMsg(json, int.parse(json['room_id']));
            SQLController.to.insertmessage(chat);
            SQLController.to.updateLastMessage(
                chat.content, chat.date.toString(), chat.roomId!);
            showCustomSnackbar(
                event.notification!.title, event.notification!.body,
                (snackbar) async {
              Get.back();
              int partnerId = int.parse(event.data['sender']);
              getUserProfile([partnerId]).then((user) async {
                if (user.isError == false) {
                  getPartnerToken(partnerId).then((token) {
                    Get.to(() => MessageDetatilScreen(
                          partner: user.data[0],
                          myProfile: HomeController.to.myProfile.value,
                          partnerToken: token.data,
                          enterRoute: EnterRoute.popUp,
                        ));
                    HomeController.to.enterMessageRoom.value =
                        user.data.first.userid;
                  });
                  await SQLController.to.findMessageRoom(
                      roomid: int.parse(json['room_id']),
                      chatRoom: ChatRoom.fromMsg(json).toJson());
                  // Get.put(MessageController());
                }
              });
            });
          }
        }
      } else if (event.data["type"] == "logout") {
        showoneButtonDialog(
          title: '로그인 감지',
          content: '다른 기기에서 해당 계정으로 로그인 하여 로그아웃합니다',
          oneFunction: () {
            AppController.to.currentIndex.value = 0;
            const FlutterSecureStorage().delete(key: "token");
            const FlutterSecureStorage().delete(key: "id");
            const FlutterSecureStorage().delete(key: "login detect");
            Get.delete<AppController>();
            Get.delete<HomeController>();
            Get.delete<SearchController>();
            Get.delete<ProfileController>();
            Get.offAll(() => StartScreen());
          },
          oneText: '확인',
        );
      } else {
        ProfileController.to.isnewalarm(true);

        showCustomSnackbar(event.notification!.title, event.notification!.body,
            (snackbar) {
          print('눌림');
        });
      }

      // print(event.notification!.body);
    });

    //Background, Killed 상태에서 알림을 받고, 그 알림을 클릭해서 앱에 접근했을 때
    setupInteractedMessage();

    // Background, Killed 상태에서 알림을 받았을 때
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      provisional: false,
      announcement: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      try {
        if (Platform.isIOS) {
          await messaging.setForegroundNotificationPresentationOptions(
            alert: false, // Required to display a heads up notification
            badge: false,
            sound: false,
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
}
