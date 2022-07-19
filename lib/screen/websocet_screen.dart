import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:web_socket_channel/io.dart';

class WebsoketScreen extends StatelessWidget {
  WebsoketScreen({Key? key, required this.partnerId}) : super(key: key);
  int partnerId;
  late WebsoketController controller =
      Get.put(WebsoketController(partnerId: partnerId));
  Key centerKey = const ValueKey('QueryList');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
          appBar: AppBarWidget(
            title: '한근형',
            bottomBorder: false,
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Center(
                    child: SvgPicture.asset('assets/icons/Arrow_left.svg'))),
            actions: [
              GestureDetector(
                onTap: () async {
                  // Get.to(() => DatabaseList());
                  deleteDatabase(
                                  join(await getDatabasesPath(), 'MY_database.db'));
                },
                child: SizedBox(
                    height: 44,
                    width: 44,
                    child: Center(
                        child: SvgPicture.asset('assets/icons/More.svg'))),
              )
            ],
          ),
          body: Obx(
            () => controller.screenState.value == ScreenState.loading
                ? const Center(child: LoadingWidget())
                : controller.screenState.value == ScreenState.success
                    ? Column(
                        children: [
                          Expanded(
                            child: ScrollNoneffectWidget(
                                // child: SmartRefresher(
                                //   controller: controller.refreshController,
                                //   enablePullUp: false,
                                //   enablePullDown:
                                //       controller.refreshEnablePullUp.value,
                                //   onRefresh: controller.onLoading,
                                //   physics: const BouncingScrollPhysics(),
                                //   footer: const MyCustomFooter(),
                                //   header: ClassicHeader(
                                //     releaseIcon: Container(),
                                //     releaseText: '',
                                //     refreshingIcon: Container(),
                                //     refreshingText: '',
                                //     idleIcon: Container(),
                                //     idleText: '',
                                //     completeIcon: Container(),
                                //     completeText: '',
                                //   ),
                                // child: ListView(
                                //     controller: controller.scrollController,
                                //     // reverse: true,
                                //     children: controller.messageList
                                //         .map((element) {
                                //           if (element ==
                                //               controller.messageList.first) {
                                //             return MessageWidget(
                                //               message: element,
                                //               isLast: true.obs,
                                //               partnerId: partnerId,
                                //               myId: controller.myId!,
                                //             );
                                //           }
                                //           return MessageWidget(
                                //             message: element,
                                //             isLast: false.obs,
                                //             partnerId: partnerId,
                                //             myId: controller.myId!,
                                //           );
                                //         })
                                //         .toList()
                                //         .reversed
                                //         .toList()),
                                child: SizedBox(
                              key: Get.put(KeyController(
                                      isTextField: false.obs,
                                      isMessageBox: true))
                                  .viewKey,
                              child: CustomScrollView(
                                  key: centerKey,
                                  reverse: controller
                                          .checkFirstScreenPosition()
                                          .value
                                      ? true
                                      : false,
                                  controller: controller.scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  slivers: messageBox()),
                            )),
                          ),
                          // ),
                          sendField()
                        ],
                      )
                    : controller.screenState.value == ScreenState.normal
                        ? Container()
                        : Container(),
          )),
    );
  }

  List<Widget> messageBox() {
    return [
      SliverList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate((context, index) {
            if (controller.checkFirstScreenPosition().value == true) {
              if (controller.messageList[index] ==
                  controller.messageList.first) {
                return MessageWidget(
                    key: Get.put(
                            KeyController(
                                isTextField: false.obs, ismessage: true),
                            tag: index.toString())
                        .viewKey,
                    message: controller.messageList[index],
                    isLast: true.obs,
                    partnerId: partnerId,
                    myId: controller.myId!);
              } else {
                if (index < 9) {
                  return MessageWidget(
                      key: Get.put(
                              KeyController(
                                  isTextField: false.obs, ismessage: true),
                              tag: index.toString())
                          .viewKey,
                      message: controller.messageList[index],
                      isLast: false.obs,
                      partnerId: partnerId,
                      myId: controller.myId!);
                } else {
                  return MessageWidget(
                      message: controller.messageList[index],
                      isLast: false.obs,
                      partnerId: partnerId,
                      myId: controller.myId!);
                }
              }
            } else {
              if (controller.messageList[index] ==
                  controller.messageList.last) {
                return MessageWidget(
                    message: controller.messageList.reversed.toList()[index],
                    isLast: true.obs,
                    partnerId: partnerId,
                    myId: controller.myId!);
              } else {
                return MessageWidget(
                    message: controller.messageList.reversed.toList()[index],
                    isLast: false.obs,
                    partnerId: partnerId,
                    myId: controller.myId!);
              }
            }
          }, childCount: controller.messageList.length)),
      SliverList(
          delegate: SliverChildBuilderDelegate(((context, index) {
        return MessageWidget(
            message: controller.refreshList[index],
            isLast: false.obs,
            partnerId: partnerId,
            myId: controller.myId!);
      }), childCount: controller.refreshList.length)),
    ];
  }

  Widget sendField() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                keyboardType: TextInputType.multiline,
                controller: controller.sendText,
                minLines: 1,
                maxLines: 3,
                autocorrect: false,
                readOnly: false,
                style: k16Normal,
                cursorColor: mainblack,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),
                autofocus: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cardGray,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  isDense: true,
                  hintText: '메세지 입력',
                  hintStyle: k16Normal.copyWith(color: maingray),
                )),
          ),
          const SizedBox(width: 14),
          GestureDetector(
              onTap: () async {
                if (controller.sendText.text.isNotEmpty) {
                  controller.channel.sink.add(jsonEncode({
                    'content': controller.sendText.text,
                    'type': 'msg',
                    'token': controller.token,
                    'name': '김원우'
                  }));
                  controller.sendText.clear();
                }
              },
              child: SvgPicture.asset('assets/icons/Enter_Icon.svg'))
        ],
      ),
    );
  }
}

class WebsoketController extends GetxController with WidgetsBindingObserver {
  WebsoketController({required this.partnerId});
  late IOWebSocketChannel channel;
  late int roomid;
  late RxBool hasInternet;
  late var listener;
  String? token;
  int partnerId;
  int? myId;

  TextEditingController sendText = TextEditingController();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();

  RxList<Chat> messageList = <Chat>[].obs;
  RxList<Chat> refreshList = <Chat>[].obs;
  Rx<ScreenState> screenState = ScreenState.normal.obs;
  RxBool isFirst = true.obs;
  RxBool refreshEnablePullUp = true.obs;
  RxInt lastid = 0.obs;
  RxDouble messageHeight = 0.0.obs;
  RxDouble messagesBoxPositionHeight = 0.0.obs;
  @override
  void onInit() async {
    scrollController.addListener(() {
      if (refreshEnablePullUp.value == true) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print('실행되었습니다.');
          onLoading();
        }
      }
    });
    screenState.value = ScreenState.loading;
    print('${partnerId}파트너아이디입니다.');
    WidgetsBinding.instance!.addObserver(this);
    token = await const FlutterSecureStorage().read(key: "token");
    myId = int.parse(
        (await const FlutterSecureStorage().read(key: "id")).toString());
    print('${myId}자기아이디입니다.');
    listener = InternetConnectionChecker().onStatusChange.listen((event) {
      bool connection =
          event == InternetConnectionStatus.connected ? true : false;
      hasInternet = connection.obs;
      if (connection == false) {
        channel.sink.close();
        print('웹소켓 연결이 해제되었습니다.');
      } else {
        // if (isFirst.value == false) {
        channel = IOWebSocketChannel.connect(
            Uri.parse(
                'ws://192.168.35.12:8000/ws/chat/${partnerId.toString()}/'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'id': '$myId'
            });
        channel.stream.listen((event) {
          print(event);
          messageTypeCheck(jsonDecode(event));
        }, onError: (error) {
          print(error);
        }, onDone: () {
          print('끊김');
          channel.sink.close();
        });
        // }
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:

      case AppLifecycleState.detached:

      case AppLifecycleState.paused:
        print(state);
        break;
    }
  }

  @override
  void onClose() {
    channel.sink.close();
    listener.cancel();
    print('웹소켓 연결 해제');
    messageList.clear();
    super.onClose();
  }

  void onLoading() async {
    print(lastid);
    List<Chat> list =
        (await SQLController.to.getDBMessage(roomid, lastid.value));
    print(list);
    if (list.isNotEmpty) {
      refreshList.addAll(list);
      lastid.value = refreshList.last.messageId!;
      refreshEnablePullUp(true);
    } else {
      refreshEnablePullUp.value = false;
    }
  }

  void messageTypeCheck(Map<String, dynamic> json) async {
    print(json['type']);
    switch (json['type']) {
      case ('user_join'):
        if (json['user_id'] == myId) {
          print('내가 접속함');
          roomid = int.parse(json['room_id']);
          messageList.addAll(
              await SQLController.to.getDBMessage(roomid, lastid.value));
          screenState.value = ScreenState.success;
          checkRoomId(roomid).then((value) {
            if (value.isNotEmpty) {
              print(messageList[0].messageId);
              sendLastView(messageList.first.messageId!);
            } else {
              sendLastView(0);
            }
          });
          lastid.value = messageList.last.messageId!;
        } else {
          print('상대가 접속함');
          changeReadMessage(roomid, null);
        }
        break;
      case ('user_leave'):
        print('상대가 나감');
        break;
      case ('msg'):
        SQLController.to.insertmessage(Chat.fromMsg(json, roomid));
        messageList.insert(0, Chat.fromJson(json));
        await Future.delayed(const Duration(milliseconds: 100));
        scrollController.jumpTo(scrollController.position.minScrollExtent);
        break;
      case 'chat_log':
        json['content'].forEach((element) {
          SQLController.to.insertmessage(Chat.fromJson(element));
          messageList.add(Chat.fromJson(element));
        });
        print('저장완료');
        await Future.delayed(const Duration(milliseconds: 100));
        scrollController.jumpTo(scrollController.position.minScrollExtent);
        break;
      case 'other_view':
        if (json['content'] != null) {
          changeReadMessage(roomid, json['content']);
        }
        break;
    }
  }

  Future<void> sendLastView(int id) async {
    channel.sink.add(jsonEncode({'id': id, 'type': 'update'}));
    print('보냈다.');
  }

  Future<List<Map<String, dynamic>>> checkRoomId(int id) async {
    List<Map<String, dynamic>> list;
    list = (await SQLController.to.database!
        .rawQuery('SELECT * FROM chatting WHERE room_id = $id'));
    return list;
  }

  Future<void> changeReadMessage(int roomid, int? msgid) async {
    if (msgid != null) {
      SQLController.to.database!.rawUpdate(
          'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ? and msg_id <= ?',
          ['true', 'false', roomid, msgid]);
    } else {
      SQLController.to.database!.rawUpdate(
          'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ?',
          ['true', 'false', roomid]);
      if (messageList
          .where((p0) => p0.isRead!.value == false)
          .toList()
          .isNotEmpty) {
        print('실행되는중');
        if (checkFirstScreenPosition().value == true) {
          messageList.first.isRead!.value = true;
        } else {
          messageList.last.isRead!.value = true;
        }
      }
      messageList.refresh();
    }
    print('업데이트 성공!');
  }

  RxBool checkFirstScreenPosition() {
    if (messageHeight.value >= messagesBoxPositionHeight.value) {
      return true.obs;
    } else {
      return false.obs;
    }
  }
}
