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
    required this.likeCount,
    required this.isLiked,
    required this.realname,
    required this.department,
    required this.profileimage,
    required this.isMarked,
  });

  int id;
  int userId;
  var thumbnail;
  int? project_id;
  String title;
  String realname;
  String department;
  String? profileimage;
  DateTime date;
  Project project;
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
        project: Project.fromJson(json["project"]),
        likeCount: RxInt(json["like_count"]),
        isLiked: RxInt(json["is_liked"]),
        isMarked: RxInt(json["is_marked"]),
        department: json["department"],
        profileimage: json["profile_image"],
        realname: json["real_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "title": title,
        "date": date.toIso8601String(),
        "project": project.toJson(),
        "like_count": likeCount,
        "is_liked": isLiked,
        "is_marked": isMarked,
        "real_name": realname,
        "profile_image": profileimage,
        "department": department,
      };
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
