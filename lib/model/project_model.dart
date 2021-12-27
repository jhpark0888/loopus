import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';

class Project {
  Project({
    required this.id,
    required this.projectName,
    this.introduction,
    this.startDate,
    this.endDate,
    this.post,
    required this.projectTag,
    this.looper,
    this.isliked,
    this.like_count,
  });

  int id;
  String projectName;
  String? introduction;
  String? startDate;
  String? endDate;
  List<Post>? post;
  List<Tag> projectTag;
  List<dynamic>? looper;
  RxBool? isliked;
  int? like_count;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["project_id"],
        projectName: json["project_name"],
        introduction: json["introduction"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        post: json["post"] != null
            ? List<Post>.from(json["post"].map((x) => Post.fromJson(x)))
            : null,
        projectTag:
            List<Tag>.from(json["project_tag"].map((x) => Tag.fromJson(x))),
        looper: json["looper"],
        isliked: false.obs,
        like_count: json["like_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "introduction": introduction,
        "start_date": startDate,
        "end_date": endDate,
        "post": post != null
            ? List<dynamic>.from(post!.map((x) => x.toJson()))
            : null,
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
        "like_count": like_count,
      };
}
