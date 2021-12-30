import 'package:get/get.dart';
import 'package:loopus/model/project_model.dart';

class Post {
  Post({
    required this.id,
    required this.userId,
    required this.thumbnail,
    required this.title,
    required this.date,
    required this.project,
    required this.project_id,
    required this.contents,
    required this.projectname,
    required this.likeCount,
    required this.isLiked,
    required this.realname,
    this.content_summary,
    required this.department,
    required this.profileimage,
    required this.isMarked,
  });

  int id;
  int userId;
  var thumbnail;
  int? project_id;
  String title;
  String? projectname;
  String realname;
  List<Map<String, dynamic>>? contents;
  String department;
  String? profileimage;
  DateTime date;
  Project? project;
  String? content_summary;
  RxInt likeCount;
  RxInt isLiked;
  RxInt isMarked;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        project_id: json["project_id"],
        id: json["id"],
        userId: json["user_id"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        project:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        likeCount: RxInt(json["like_count"]),
        isLiked: json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
        contents: json["contents"] != null
            ? List<Map<String, dynamic>>.from(json["contents"].map((x) => x))
            : null,
        isMarked:
            json["is_marked"] != null ? RxInt(json["is_marked"]) : RxInt(0),
        content_summary: json["contents"] != null
            ? contentsummary(
                List<Map<String, dynamic>>.from(json["contents"].map((x) => x)))
            : null,
        department: json["department"] ?? '',
        profileimage: json["profile_image"],
        realname: json["real_name"] ?? '',
        projectname: json["project_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "title": title,
        "date": date.toIso8601String(),
        "project": project!.toJson(),
        "like_count": likeCount,
        "is_liked": isLiked,
        "is_marked": isMarked,
        "real_name": realname,
        "profile_image": profileimage,
        "department": department,
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

class ProjectTag {
  ProjectTag({
    required this.tagId,
    required this.tag,
  });

  int tagId;
  String tag;

  factory ProjectTag.fromJson(Map<String, dynamic> json) => ProjectTag(
        tagId: json["tag_id"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "tag": tag,
      };
}

class PostingModel {
  List<Post> postingitems;
  PostingModel({required this.postingitems});

  factory PostingModel.fromJson(List<dynamic> json) {
    List<Post>? items = [];
    items = json.map((e) => Post.fromJson(e)).toList();
    return PostingModel(postingitems: items);
  }
}
