// class SocketMessage{
//   String type;
//   List<Chat> message;

// }

import 'package:get/get.dart';
import 'package:loopus/model/user_model.dart';

class Chat {
  String? type;
  int? messageId;
  String content;
  DateTime date;
  int? sender;
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
      messageId: json['id'],
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'],
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: json['room_id']);

  factory Chat.fromMsg(Map<String, dynamic> json, int roomId) => Chat(
      type: json['type'],
      messageId: json['id'],
      content: json['content'],
      date: DateTime.parse(json["date"]),
      sender: json['sender'],
      isRead: json['is_read'] != null ? RxBool(json['is_read']) : null,
      roomId: roomId);
  Map<String, dynamic> toMap() {
    return {
      'msg_id': messageId,
      'type': type,
      'sender': sender,
      'date': date.toString(),
      'is_read': isRead != null ? isRead.toString() : true,
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
      required this.roomId,
      required this.delId});

  Rx<Chat> message;
  int user;
  RxInt notread;
  int roomId;
  int delId;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
      message: Chat.fromJson(json["message"]).obs,
      user: json['profile'],
      notread: RxInt(json["not_read"]),
      roomId: json['room_id'],
      delId: json['del_id']);

  Map<String, dynamic> toJson() => {
        "message": message,
        "profile": user,
        "not_read": notread,
        'room_ id': roomId,
        'del_id': delId
      };
}
