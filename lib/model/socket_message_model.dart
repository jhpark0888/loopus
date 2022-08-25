// class SocketMessage{
//   String type;
//   List<Chat> message;

// }

import 'package:get/get.dart';
import 'package:loopus/model/user_model.dart';

class Chat {
  int? id;
  String? messageId;
  String content;
  DateTime date;
  String? sender;
  RxBool? isRead;
  RxString? sendsuccess;
  int? roomId;
  Chat(
      {this.id,
      required this.content,
      required this.date,
      required this.sender,
      required this.isRead,
      required this.messageId,
      required this.roomId,
      required this.sendsuccess});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
      messageId: json['id'].toString(),
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'].toString(),
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: json['room_id'],
      sendsuccess: 'true'.obs);

  factory Chat.fromMsg(Map<String, dynamic> json, int roomId) => Chat(
      messageId: json['id'].toString(),
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'].toString(),
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: roomId,
      sendsuccess: 'true'.obs);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sender': sender,
      'date': date.toString(),
      'is_read': isRead != null ? isRead.toString() : false.toString(),
      'message': content,
      'room_id': roomId,
      'send_success': sendsuccess!.value.toString(),
      'msg_id': messageId
    };
    return map;
  }
}

class ChatRoom {
  ChatRoom({
    required this.message,
    required this.user,
    required this.notread,
    required this.roomId,
  });

  Rx<Chat> message;
  int user;
  RxInt notread;
  int roomId;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        message: Chat.fromJson(json["message"]).obs,
        user: json['profile'],
        notread: RxInt(json["not_read"]),
        roomId: json['room_id'],
      );

  factory ChatRoom.fromMsg(Map<String, dynamic> json) => ChatRoom(
        message: Chat(
                content: json['content'],
                sendsuccess: 'true'.obs,
                date: DateTime.parse(json['date']),
                sender: json['sender'],
                isRead: false.obs,
                messageId: json['id'],
                roomId: int.parse(json['room_id']))
            .obs,
        user: int.parse(json['sender']),
        notread: RxInt(1),
        roomId: int.parse(json['room_id']),
      );

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        "user_id": user,
        "message": message.value.content.toString(),
        'date': message.value.date.toString(),
        "not_read": notread.value,
      };
}
// room_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, message Text, date Text, not_read INTEGER, del_id INTEGER