import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post(
      {required this.id,
      required this.userId,
      required this.project_id,
      required this.thumbnail,
      required this.title,
      required this.date,
      required this.like_count,
      required this.contents,
      this.content_summary});

  int id;
  int userId;
  int project_id;
  String? thumbnail;
  String title;
  DateTime date;
  int like_count;
  List<Map<String, dynamic>>? contents;
  String? content_summary;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["user_id"],
        project_id: json["project_id"],
        thumbnail: json["thumbnail"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        like_count: json["like_count"],
        contents: json["contents"] != null
            ? List<Map<String, dynamic>>.from(json["contents"].map((x) => x))
            : null,
        content_summary: json["contents"] != null
            ? contentsummary(
                List<Map<String, dynamic>>.from(json["contents"].map((x) => x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "project_id": project_id,
        "thumbnail": thumbnail,
        "title": title,
        "date": date.toIso8601String(),
        "like": like_count,
        "contents": contents,
      };
}

String contentsummary(List<Map<String, dynamic>> json) {
  String summary = '';
  json.forEach((map) {
    if (map['insert'] is String) {
      summary = summary + map['insert'];
    }
  });
  summary.replaceAll('\n', '');
  return summary;
}
