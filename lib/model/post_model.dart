import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    required this.id,
    required this.userId,
    required this.project,
    required this.thumbnail,
    required this.title,
    required this.date,
    required this.like,
    required this.contents,
  });

  int id;
  int userId;
  int project;
  String? thumbnail;
  String title;
  DateTime date;
  List<dynamic> like;
  List<Map<String, dynamic>>? contents;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["user_id"],
        project: json["project"],
        thumbnail: json["thumbnail"],
        title: json["title"].toString().trim(),
        date: DateTime.parse(json["date"]),
        like: List<dynamic>.from(json["like"].map((x) => x)),
        contents: json["contents"] != null
            ? List<Map<String, dynamic>>.from(json["contents"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "project": project,
        "thumbnail": thumbnail,
        "title": title,
        "date": date.toIso8601String(),
        "like": List<dynamic>.from(like.map((x) => x)),
        "contents": contents,
      };
}
