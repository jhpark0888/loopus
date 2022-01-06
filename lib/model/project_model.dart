import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';

class Project {
  Project({
    required this.id,
    required this.projectName,
    this.thumbnail,
    this.introduction,
    this.startDate,
    this.endDate,
    this.post,
    required this.projectTag,
    this.looper,
    this.post_count,
    this.like_count,
  });

  int id;
  String projectName;
  String? thumbnail;
  String? introduction;
  DateTime? startDate;
  DateTime? endDate;
  List<Post>? post;
  List<Tag> projectTag;
  List<dynamic>? looper;
  int? post_count;
  int? like_count;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["project_id"] ?? json["id"],
        projectName: json["project_name"],
        thumbnail: json["pj_thumbnail"],
        introduction: json["introduction"],
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"])
            : null,
        endDate:
            json["end_date"] != null ? DateTime.parse(json["end_date"]) : null,
        post: json["post"] != null
            ? List<Post>.from(json["post"].map((x) => Post.fromJson(x)))
            : null,
        projectTag:
            List<Tag>.from(json["project_tag"].map((x) => Tag.fromJson(x))),
        looper: json["looper"],
        post_count: json["project_post"] != null
            ? json["project_post"]["post_count"]
            : 0,
        like_count: json["project_post"] != null
            ? json["project_post"]["like_count"]
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "thumbnail": thumbnail,
        "introduction": introduction,
        "start_date": startDate,
        "end_date": endDate,
        "post": post != null
            ? List<dynamic>.from(post!.map((x) => x.toJson()))
            : null,
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
        "post_count": post_count,
        "like_count": like_count,
      };
}
