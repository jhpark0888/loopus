import 'package:get/get.dart';
import 'package:loopus/model/enterprise_model.dart';
import 'package:loopus/model/user_model.dart';

abstract class PostComment {}

class Comment implements PostComment {
  Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.date,
    required this.likecount,
    required this.isLiked,
    required this.replyList,
  });

  int id;
  String content;
  User user;
  DateTime date;
  RxInt likecount;
  RxInt isLiked;
  RxList<Reply> replyList;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] ?? 0,
        content: json['content'],
        user: User.fromJson(json["profile"]),
        date: json["date"] != null
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        likecount: json['likecount'] ?? 0.obs,
        isLiked: json['isliked'] ?? 0.obs,
        replyList: json['cocomments'] != null
            ? List.from(json['cocomments'])
                .map((reply) => Reply.fromJson(reply, json['id'] ?? 0))
                .toList()
                .obs
            : <Reply>[].obs,
      );
}

class Reply implements PostComment {
  Reply({
    required this.id,
    required this.commentId,
    required this.content,
    required this.user,
    required this.date,
    required this.likecount,
    required this.isLiked,
  });

  int id;
  int commentId;
  String content;
  User user;
  DateTime date;
  RxInt likecount;
  RxInt isLiked;

  factory Reply.fromJson(Map<String, dynamic> json, int commentId) => Reply(
        id: json['id'] ?? 0,
        commentId: commentId,
        content: json['content'] ?? '',
        user: User.fromJson(json["profile"]),
        date: json["date"] != null
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        likecount: json['likecount'] != null ? RxInt(json['likecount']) : 0.obs,
        isLiked: json['isliked'] != null ? RxInt(json['likecount']) : 0.obs,
      );
}
