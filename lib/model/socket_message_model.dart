// class SocketMessage{
//   String type;
//   List<Chat> message;

// }

import 'package:get/get.dart';
import 'package:loopus/model/user_model.dart';

class Chat {
  String? type;
  String? messageId;
  String content;
  DateTime date;
  String? sender;
  RxBool? isRead;
  int? roomId;

  Chat(
      {required this.content,
      required this.date,
      required this.sender,
      required this.isRead,
      required this.messageId,
      required this.type,
      required this.roomId});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
      type: json['type'],
      messageId: json['id'].toString(),
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'].toString(),
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: json['room_id']);

  factory Chat.fromMsg(Map<String, dynamic> json, int roomId) => Chat(
      type: json['type'],
      messageId: json['id'].toString(),
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'].toString(),
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: roomId);
  Map<String, dynamic> toMap() {
    return {
      'msg_id': messageId,
      'type': type,
      'sender': sender,
      'date': date.toString(),
      'is_read': isRead != null ? isRead.toString() : false.toString(),
      'message': content,
      'room_id': roomId
    };
  }
}

class ChatRoom {
  ChatRoom(
      {required this.message,
      required this.user,
      required this.notread,
      required this.roomId,});

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
      message: Chat(content: json['content'], date: DateTime.parse(json['date']), sender: json['sender'], isRead: false.obs, messageId: json['id'], type: null, roomId: int.parse(json['room_id'])).obs,
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