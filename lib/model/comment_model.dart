import 'package:get/get.dart';
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
    required this.replycount,
  });

  int id;
  String content;
  User user;
  DateTime date;
  RxInt likecount;
  RxInt isLiked;
  RxList<Reply> replyList;
  RxInt replycount;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] ?? 0,
      content: json['content'],
      user: User.fromJson(json["profile"]),
      date:
          json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
      likecount:
          json['like_count'] != null ? RxInt(json["like_count"]) : RxInt(0),
      isLiked: json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
      replyList: json['cocomments'] != null
          ? List.from(json['cocomments']["cocomment"])
              .map((reply) => Reply.fromJson(reply, json['id'] ?? 0))
              .toList()
              .obs
          : <Reply>[].obs,
      replycount: json['cocomments'] != null
          ? RxInt(json["cocomments"]["count"])
          : RxInt(0));
}

class Reply implements PostComment {
  Reply({
    required this.id,
    required this.commentId,
    required this.content,
    required this.user,
    required this.taggedUser,
    required this.date,
    required this.likecount,
    required this.isLiked,
  });

  int id;
  int commentId;
  String content;
  User user;
  User taggedUser;
  DateTime date;
  RxInt likecount;
  RxInt isLiked;

  factory Reply.fromJson(Map<String, dynamic> json, int commentId) => Reply(
        id: json['id'] ?? 0,
        commentId: commentId,
        content: json['content'] ?? '',
        user: User.fromJson(json["profile"]),
        taggedUser: User.fromJson(json["tagged_user"]),
        date: json["date"] != null
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        likecount:
            json['like_count'] != null ? RxInt(json['like_count']) : 0.obs,
        isLiked: json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
      );
}
