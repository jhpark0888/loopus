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
      // required this.content,
      required this.date,
      required this.isread,
      required this.contents,
      this.looped});

  int id;
  int userId;
  User user;
  NotificationType type;
  int targetId;
  // String? content;
  String contents;
  DateTime date;
  RxBool isread;
  Rx<FollowState>? looped;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json["id"] ?? 0,
          userId: json["user_id"],
          user: User.fromJson(json["profile"]),
          type: json["type"] == 2
              ? NotificationType.follow
              : json["type"] == 3
                  ? NotificationType.careerTag // 타겟 아이디: 커리어
                  : json['type'] == 4
                      ? NotificationType.postLike
                      : json['type'] == 5
                          ? NotificationType.commentLike
                          : json['type'] == 6
                              ? NotificationType.replyLike
                              : json['type'] == 7
                                  ? NotificationType.comment
                                  : json['type'] == 8
                                      ? NotificationType.reply
                                      : json['type'] == 9
                                          ? NotificationType
                                              .schoolNoti // 타겟 아이디: 포스팅
                                          : json['type'] == 10
                                              ? NotificationType
                                                  .rankUpdate // 타겟 아이디: 포스팅
                                              : json['type'] == 11
                                                  ? NotificationType
                                                      .groupCareerPost
                                                  : NotificationType.empty1,
          targetId: json["target_id"],
          // content: json['type'] <= 4 ? json["content"] : '',
          // contents: json['type'] > 4
          //     ? json['content'] != null
          //         ? Content.fromJson(json["content"])
          //         : Content(content: '', postId: json["target_id"])
          //     : null,
          contents: json['content'] ?? "",
          // ? Content.fromJson(json)
          // : json['content'] != null
          //     ? Content.fromJson(json['content'])
          //     : null,
          date: DateTime.parse(json["date"]),
          isread: RxBool(json["is_read"]),
          looped: json["looped"] != null
              ? FollowState.values[json["looped"]].obs
              : null);

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "target_id": targetId,
        "content": contents,
        "date": date.toIso8601String(),
      };
}

// class Content {
//   String content;
//   int postId;
//   Content({required this.content, required this.postId});

//   factory Content.fromJson(Map<String, dynamic> json) =>
//       Content(content: json['content'] ?? '', postId: json['post_id'] ?? 0);
// }