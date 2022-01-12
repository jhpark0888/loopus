import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

class Project {
  Project(
      {required this.id,
      required this.userid,
      this.realname,
      this.profileimage,
      this.department,
      required this.projectName,
      this.thumbnail,
      this.introduction,
      this.startDate,
      this.endDate,
      required this.post,
      required this.projectTag,
      required this.looper,
      this.post_count,
      this.like_count,
      this.is_user});

  int id;
  int? userid;
  String? realname;
  String? profileimage;
  String? department;
  String projectName;
  String? thumbnail;
  String? introduction;
  DateTime? startDate;
  DateTime? endDate;
  List<Post> post;
  List<Tag> projectTag;
  List<User> looper;
  int? post_count;
  int? like_count;
  bool? is_user;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["project_id"] ?? json["id"],
        userid: json["user_id"],
        realname: json["real_name"],
        profileimage: json["profile_image"],
        department: json["department"],
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
            : [],
        projectTag:
            List<Tag>.from(json["project_tag"].map((x) => Tag.fromJson(x))),
        looper: json["looper"] != null
            ? List<User>.from(
                json["looper"].map((x) => User.fromJson(x["profile"])))
            : [],
        post_count: json["count"] != null
            ? json["count"]["post_count"]
            : json["post"] != null
                ? List.from(json["post"]).length
                : 0,
        like_count: json["count"] != null
            ? json["count"]["like_count"]
            : json["like_count"] ?? 0,
        is_user: json['is_user'] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
        "real_name": realname,
        "profile_image": profileimage,
        "project_name": projectName,
        "thumbnail": thumbnail,
        "introduction": introduction,
        "start_date": startDate,
        "end_date": endDate,
        "post":
            post != null ? List<dynamic>.from(post.map((x) => x.toJson())) : [],
        "looper": looper != null
            ? List<dynamic>.from(post.map((x) => x.toJson()))
            : [],
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
        "post_count": post_count,
        "like_count": like_count,
        "is_user": is_user,
      };
}
