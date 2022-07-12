import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:web_socket_channel/io.dart';

class WebsoketScreen extends StatelessWidget {
  WebsoketScreen({Key? key, required this.roomid, required this.userid})
      : super(key: key);
  int roomid;
  int userid;

  late WebsoketController controller =
      Get.put(WebsoketController(userid: userid, roomid: roomid));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '한근형',
        bottomBorder: false,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child:
                Center(child: SvgPicture.asset('assets/icons/Arrow_left.svg'))),
        actions: [
          SizedBox(
              height: 44,
              width: 44,
              child: Center(child: SvgPicture.asset('assets/icons/More.svg')))
        ],
      ),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: controller.sendText,
              onFieldSubmitted: (string) {
                controller.channel.sink
                    .add(jsonEncode({'content': string, 'type': 'msg'}));
              },
            ),
            Center(
                child: IconButton(
                    onPressed: () {
                      controller.channel.sink.add(jsonEncode({
                        'content': controller.sendText.text,
                        'type': 'msg'
                      }));
                      print('눌림');
                    },
                    icon: Text('보내기'))),
            IconButton(
                onPressed: () {
                  Get.to(() => DatabaseList());
                },
                icon: Text('database')),
            IconButton(
                onPressed: () async {
                  deleteDatabase(
                      join(await getDatabasesPath(), 'MY_database.db'));
                },
                icon: Text('삭제하기 데이터베이스,')),
            IconButton(
                onPressed: () {
                  SQLController.to.insertDog(SQLController.to.fido);
                },
                icon: Text('sssssss')),
            IconButton(
                onPressed: () {
                  SQLController.to.insertDog(SQLController.to.alex);
                },
                icon: Text('sssssss')),
            IconButton(
                onPressed: () {
                  SQLController.to.insertDog(SQLController.to.brodie);
                },
                icon: Text('sssssss')),
            IconButton(
                onPressed: () {
                  print(SQLController.to.getDBMessage(2));
                },
                icon: Text('저장 메세지 리스트 불러오기')),
            Obx(
              () => Column(
                children: controller.messageList
                    .map((element) => MessageWidget(message: element))
                    .toList()
                    .reversed
                    .toList(),
              ),
            )
            // StreamBuilder(
            //     stream: controller.channel.stream,
            //     builder: (context, snapshot) {
            //       SQLController.to.insertmessage(Chat.fromJson(jsonDecode(snapshot.data as String)));
            //       // controller.channel.stream.listen((message){controller.messageTypeCheck(jsonDecode(message));});
            //       print(snapshot.data);
            //               return Padding(
            //           padding: EdgeInsets.all(20),
            //           child: Text(snapshot.hasData ? '${snapshot.data}' : ''));
            //     })
            // CareerRankWidget(isUniversity: true)
          ],
        ),
      ),
    );
  }
}

class WebsoketController extends GetxController {
  WebsoketController({required this.roomid, required this.userid});
  int roomid;
  int userid;
  late var channel;
  RxList<Chat> messageList = <Chat>[].obs;
  TextEditingController sendText = TextEditingController();
  @override
  void onInit() async {
    // channel.stream;
    channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.35.22:8000/ws/chat/${userid.toString()}/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'id': '1'
        });
    messageList.addAll(await SQLController.to.getDBMessage(roomid));
    channel.stream.listen((event) {
      print(event);
      messageTypeCheck(jsonDecode(event));
      // print(Chat.fromJson(jsonDecode(event)).type);
    });
    super.onInit();
  }

  @override
  void onClose() {
    channel.sink.close();
    print('실행되었다');
    super.onClose();
  }

  void messageTypeCheck(Map<String, dynamic> json) {
    print(json['type']);
    switch (json['type']) {
      case ('user_join'):
        if (json['user_id'] == 1) {
          print('내가 접속함');
          checkRoomId(json['room_id']).then((value) {
            if (value.isNotEmpty) {
              sendLastView(messageList.last.messageId!);
            } else {
              sendLastView(0);
            }
          });
        } else {
          print('상대가 접속함');
        }
        break;
      case ('user_leave'):
        print('상대가 나감');
        break;
      case ('msg'):
        SQLController.to.insertmessage(Chat.fromJson(json));
        messageList.add(Chat.fromJson(json));
        break;
      case 'chat_log':
        json['chat_log'].forEach((element) {
          SQLController.to.insertmessage(Chat.fromJson(element));
          messageList.add(Chat.fromJson(element));
        });
        print('저장완료');
        break;
      case 'other_view':
        if (json['msg_id'] != null) {
          changeReadMessage(roomid, json['msg_id']);
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

  Future<void> changeReadMessage(int roomid, int msgid) async {
     SQLController.to.database!.rawUpdate(
        'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ? and msg_id <= ?',
        ['true', 'false', roomid, msgid]);
    print('업데이트 성공!');
  }
}

enum MessageType { user_join, user_leave, chat_log }
