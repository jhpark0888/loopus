import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class Message {
  Message({
    required this.id,
    required this.roomId,
    required this.receiverId,
    required this.message,
    required this.date,
    required this.isRead,
    required this.issender,
    required this.issending,
  });

  int id;
  int roomId;
  int receiverId;
  String message;
  DateTime date;
  bool isRead;
  int issender;
  RxBool issending;

  factory Message.fromJson(Map<String, dynamic> json, String? myid) => Message(
        id: json["id"],
        roomId: json["room_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        date: DateTime.parse(json["date"]).add(const Duration()),
        isRead: json["is_read"],
        issender: json["receiver_id"].toString() != myid ? 1 : 0,
        issending: false.obs,
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

  Rx<Message> message;
  User user;
  RxInt notread;

  factory MessageRoom.fromJson(Map<String, dynamic> json, String? myid) =>
      MessageRoom(
        message: Message.fromJson(json["message"], myid).obs,
        user: json["profile"] != null
            ? User.fromJson(json["profile"])
            : User.defaultuser(
                realName: "알 수 없음",
              ),
        notread: RxInt(json["not_read"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "profile": user,
        "not_read": notread,
      };
}
