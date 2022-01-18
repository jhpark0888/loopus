import 'dart:convert';

import 'package:loopus/model/user_model.dart';

class Message {
  Message({
    required this.roomId,
    required this.receiverId,
    required this.message,
    required this.date,
    required this.isRead,
  });

  int roomId;
  int receiverId;
  String message;
  DateTime date;
  bool isRead;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        roomId: json["room_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        date: DateTime.parse(json["date"]),
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "receiver_id": receiverId,
        "message": message,
        "date": date.toIso8601String(),
        "is_read": isRead,
      };
}

class MessageRoom {
  MessageRoom({
    required this.message,
    required this.user,
    required this.notread,
  });

  Message message;
  User user;
  int notread;

  factory MessageRoom.fromJson(Map<String, dynamic> json) => MessageRoom(
        message: Message.fromJson(json["message"]),
        user: User.fromJson(json["profile"]),
        notread: json["not_read"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "profile": user,
        "not_read": notread,
      };
}
