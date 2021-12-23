class PostItem {
  PostItem({
    required this.id,
    required this.userId,
    required this.thumbnail,
    required this.title,
    required this.date,
    required this.project,
    required this.likeCount,
    required this.isLiked,
    required this.isMarked,
  });

  int id;
  int userId;
  var thumbnail;
  String title;
  DateTime date;
  Project project;
  int likeCount;
  var isLiked;
  var isMarked;

  factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
        id: json["id"],
        userId: json["user_id"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        project: Project.fromJson(json["project"]),
        likeCount: json["like_count"],
        isLiked: json["is_liked"] == null ? null : json["is_liked"],
        isMarked: json["is_marked"] == null ? null : json["is_marked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "title": title,
        "date": date.toIso8601String(),
        "project": project.toJson(),
        "like_count": likeCount,
        "is_liked": isLiked == null ? null : isLiked,
        "is_marked": isMarked == null ? null : isMarked,
      };
}

class Project {
  Project({
    required this.id,
    required this.projectName,
    required this.projectTag,
  });

  int id;
  String projectName;
  List<ProjectTag> projectTag;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        projectName: json["project_name"],
        projectTag: List<ProjectTag>.from(
            json["project_tag"].map((x) => ProjectTag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
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
  List<PostItem> postingitems;
  PostingModel({required this.postingitems});

  factory PostingModel.fromJson(List<dynamic> json) {
    List<PostItem>? items = [];
    items = json.map((e) => PostItem.fromJson(e)).toList();
    return PostingModel(postingitems: items);
  }
}
