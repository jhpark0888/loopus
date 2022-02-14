import 'dart:convert';

import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class NotificationModel {
  NotificationModel({
    required this.userId,
    required this.user,
    required this.type,
    required this.targetId,
    required this.content,
    required this.date,
  });

  int userId;
  User user;
  NotificationType type;
  int targetId;
  String? content;
  DateTime date;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
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
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "target_id": targetId,
        "content": content,
        "date": date.toIso8601String(),
      };
}
