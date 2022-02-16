import 'dart:convert';

import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class NotificationModel {
  NotificationModel(
      {required this.id,
      required this.userId,
      required this.user,
      required this.type,
      required this.targetId,
      required this.content,
      required this.date,
      required this.isread,
      this.looped});

  int id;
  int userId;
  User user;
  NotificationType type;
  int targetId;
  String? content;
  DateTime date;
  RxBool isread;
  Rx<FollowState>? looped;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json["id"] ?? 0,
          userId: json["user_id"],
          user: User.fromJson(json["profile"]),
          type: json["type"] == 1
              ? NotificationType.question
              : json["type"] == 2
                  ? NotificationType.follow
                  : json["type"] == 3
                      ? NotificationType.tag
                      : NotificationType.like,
          targetId: json["target_id"],
          content: json["content"],
          date: DateTime.parse(json["date"]),
          isread: RxBool(json["is_read"]),
          looped: json["looped"] != null
              ? FollowState.values[json["looped"]].obs
              : null);

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "target_id": targetId,
        "content": content,
        "date": date.toIso8601String(),
      };
}
