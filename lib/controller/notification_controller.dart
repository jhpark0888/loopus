import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/notification_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/certification_controller.dart';
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
import 'package:loopus/main.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/notification_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/before_message_detail_screen.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/notification_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/screen/signup_email_pw_screen.dart';
import 'package:loopus/screen/signup_fail_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/custom_new_version_plus.dart';
import 'package:loopus/utils/error_control.dart';
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
    print('?????? ??? ???????????? ${initialMessage?.data ?? ''}');
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _backgroundMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_backgroundMessage);
  }

  //???????????? ???????????? ???
  void _backgroundMessage(RemoteMessage message) async {
    Map<String, dynamic> json = message.data;

    if (Get.isRegistered<UpdateController>()) {
      if (Get.find<UpdateController>().isRequiredUpdate == false) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
          if (message.data["type"] == "msg") {
            // Get.put(MessageDetailController(us-erid: id)).firstmessagesload();
            json["date"] = DateTime.now().toString();
            json["content"] = message.notification!.body;
            json["not_read"] = 1;
            int partnerId = int.parse(message.data['sender']);
            getUserProfile([partnerId]).then((user) async {
              print('user.data : ${user.data['profile'].first}');
              if (user.isError == false) {
                if (user.data != null) {
                  Get.to(() => MessageDetatilScreen(
                        partner: Person.fromJson(user.data['profile'].first),
                        myProfile: HomeController.to.myProfile.value,
                        enterRoute: EnterRoute.popUp,
                      ));
                  if (Get.isRegistered<HomeController>()) {
                    HomeController.to.enterMessageRoom.value =
                        user.data['profile'].first['user_id'];
                  }

                  if (Get.isRegistered<SQLController>()) {
                    await SQLController.to.findMessageRoom(
                        roomid: int.parse(json['room_id']),
                        chatRoom: ChatRoom.fromMsg(json).toJson());
                  }
                }
              }
            });
          } else if (int.parse(json['type'].toString()) == 10) {
            AppController.to.changeBottomNav(4);
          } else {
            int id = int.parse(json['id']);
            int type = int.parse(json['type'].toString());
            int senderId = int.parse(json['sender_id']);
            if (type == 4 || type == 7 || type == 9 || type == 11) {
              Get.to(() => PostingScreen(postid: id), preventDuplicates: false);
            } else if (type == 5 || type == 6 || type == 8) {
              int? postId =
                  json['post_id'] != null ? int.parse(json['post_id']) : null;
              Get.to(() => PostingScreen(postid: postId!),
                  preventDuplicates: false);
            } else if (type == 2) {
              Get.to(() => OtherProfileScreen(userid: senderId, realname: ''),
                  preventDuplicates: false);
            } else if (type == 3) {
              String? userId = await FlutterSecureStorage().read(key: 'id');
              getproject(id, int.parse(userId!)).then((value) {
                if (value.isError != true) {
                  Project career = Project.fromJson(value.data);
                  String name = career.members
                      .where((element) => element.userId == int.parse(userId))
                      .first
                      .name;
                  Get.to(
                      () => GroupCareerDetailScreen(
                            career: career,
                            name: name,
                          ),
                      preventDuplicates: false);
                }
              });
            }
            isNotiRead(id);
          }
        });
      }
    }

    print("message: ${message.data["type"]}");
  }

  @override
  void onInit() {
    _initNotification();
    getToken();
    setupInteractedMessage();
    //Foreground ???????????? ????????? ????????? ???
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      print(event);
      print(event.data["type"]);
      print('?????? ????????? : ${event.data}');

      if (event.data["type"] == "certification") {
        // certificationFunction();
      } else {
        Map<String, dynamic> json = event.data;
        if (Platform.isAndroid) {
          localNotificaition.sampleNotification(
              event.notification!.title!, event.notification!.body!, json);
        }

        if (event.data["type"] == "msg" || event.data['type'] == 'no_msg') {
          HomeController.to.isNewMsg(true);
          json["date"] = DateTime.now().toString();
          json["content"] = event.notification!.body;
          json["not_read"] = 1;

          if (Get.isRegistered<MessageController>()) {
            String? myid = await const FlutterSecureStorage().read(key: 'id');
            SQLController.to
                .updateNotReadCount(int.parse(event.data['room_id']), 1);

            Chat chat = Chat.fromMsg(json, int.parse(json['room_id']));
            ChatRoom chatRoom = ChatRoom.fromMsg(json);
            SQLController.to
                .findMessageRoom(
                    roomid: chat.roomId!, chatRoom: chatRoom.toJson())
                .then((value) async {
              if (value == false) {
                await getUserProfile([chatRoom.user]).then((value) async {
                  if (value.isError == false) {
                    Person person = Person.fromJson(value.data['profile'][0]);
                    await SQLController.to.insertUser(person);
                    MessageController.to.searchRoomList.add(MessageRoomWidget(
                        chatRoom: chatRoom.obs, user: Rx<Person>(person)));
                    MessageController.to.chattingRoomList.add(MessageRoomWidget(
                        chatRoom: chatRoom.obs, user: Rx<Person>(person)));
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
        } else {
          if (event.data["type"] ==
              NotificationType.careerTag.index.toString()) {
            FlutterSecureStorage secureStorage = const FlutterSecureStorage();
            int careerId = int.parse(event.data["id"]);
            String? strGroupTpList =
                await secureStorage.read(key: "groupTpList");
            List<int> groupTpList = [];

            if (strGroupTpList != null) {
              groupTpList = jsonDecode(strGroupTpList).cast<int>();
            }
            groupTpList.add(careerId);

            secureStorage.write(
                key: "groupTpList", value: jsonEncode(groupTpList));
            await FirebaseMessaging.instance
                .subscribeToTopic("project$careerId");

            // if (event.data["sender_id"] != HomeController.to.myId) {

            // }
          }
          HomeController.to.isNewAlarm(true);
          // int type = int.parse(event.data['type']);
          // int id = int.parse(event.data['id']);
          // int? post_id = event.data['post_id'] != null
          //     ? int.parse(event.data['post_id'])
          //     : null;
          // int senderId = int.parse(event.data['sender_id']);
          // showCustomSnackbar(
          //     event.notification!.title, event.notification!.body, (snackbar) {
          //   if (type == 4 || type == 7) {
          //     Get.to(() => PostingScreen(postid: id));
          //   } else if (type == 5 || type == 6 || type == 8) {
          //     Get.to(() => PostingScreen(postid: post_id!));
          //   } else if (type == 2) {
          //     Get.to(
          //         () => OtherProfileScreen(userid: senderId, realname: '?????????'));
          //   }
          //   isRead(id, convertType(type), senderId);
          // });
          if (Get.isRegistered<NotificationDetailController>()) {
            NotificationDetailController.to.alarmRefresh();
          }
        }
      }

      // print(event.notification!.body);
    });

    //Background, Killed ???????????? ????????? ??????, ??? ????????? ???????????? ?????? ???????????? ???
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {});

    // Background, Killed ???????????? ????????? ????????? ???
    super.onInit();
  }

  //????????? ????????? ?????? ?????? ????????????
  static Future<String?> getToken() async {
    try {
      String? userMessageToken = await FirebaseMessaging.instance.getToken(

          //TODO: WEB KEY ??????
          // vapidKey:
          //     'BCLIUKVcUhNC9-qwvJ01m_YQ3l46lrehYmmBVcXOtMp21iwY6x-EKTOLg8v4wNPNRcjrLMReFfAq0ohfvHjWZOw',
          );
      // showButtonDialog(
      //     title: '',
      //     content: 'token : $userMessageToken',
      //     leftFunction: () {
      //       Get.back();
      //     },
      //     rightFunction: () {},
      //     rightText: '',
      //     leftText: '??????');
      // // messaging.deleteToken();
      // print('token : $userMessageToken');
      return userMessageToken ?? '';
    } catch (e) {
      print(e);
    }
  }

  //?????? ?????? ??????
  void _initNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
      announcement: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Person granted permission');
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
      print('Person granted provisional permission');
    } else {
      print('Person declined or has not accepted permission');
    }
  }

  //?????? ????????? ????????? ????????? ????????? ?????? ??????
  void fcmQuestionSubscribe(String id) async {
    await messaging.subscribeToTopic('question$id');
  }

  //?????? ????????? ????????? ????????? ????????? ?????? ????????? ?????? ??????
  void fcmQuestionUnSubscribe(String id) async {
    await messaging.unsubscribeFromTopic('question$id');
  }

  void changePromotionAlarmState(bool isSelected) async {
    if (isSelected) {
      await messaging.subscribeToTopic('promotion');
    } else {
//?????? ????????? ????????? ????????? ????????? ?????? ????????? ?????? ??????

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
