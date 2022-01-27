import 'package:get/get.dart';
import 'package:loopus/model/project_model.dart';

class Post {
  Post({
    required this.id,
    required this.userid,
    required this.thumbnail,
    required this.title,
    required this.date,
    required this.project,
    required this.contents,
    required this.likeCount,
    required this.isLiked,
    required this.realname,
    this.content_summary,
    required this.department,
    required this.profileimage,
    required this.isMarked,
    required this.isuser,
  });

  int id;
  int userid;
  var thumbnail;
  String title;
  String realname;
  List<PostContent>? contents;
  String department;
  String? profileimage;
  DateTime date;
  Project? project;
  String? content_summary;
  RxInt likeCount;
  RxInt isLiked;
  RxInt isMarked;
  int isuser;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userid: json["user_id"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        project:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        likeCount: RxInt(json["like_count"]),
        isLiked: json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
        contents: json["contents"] != null
            ? List<Map<String, dynamic>>.from(json["contents"])
                .map((content) => PostContent.fromJson(content))
                .toList()
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
        isuser: json["is_user"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
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
  for (var map in json) {
    if ([0, 1, 2, 3, 4].contains(map['type'])) {
      summary = summary + map['content'];
    }
  }
  // summary.replaceAll('\n', '');
  return summary;
}

// String type = "SmartTextType.T";
//     SmartTextType smartTextType =
//         SmartTextType.values.firstWhere((e) => e.toString() == type);
//     print(smartTextType);

class PostContent {
  PostContent({
    required this.type,
    required this.content,
    this.url,
  });

  int type;
  String content;
  String? url;

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        type: json["type"],
        content: json["content"],
        url: json["url"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "content": content,
        "url": url ?? null,
      };
}

class PostingModel {
  RxList<Post> postingitems;
  PostingModel({required this.postingitems});

  factory PostingModel.fromJson(List<dynamic> json) {
    RxList<Post>? items = <Post>[].obs;
    items.value = json.map((e) => Post.fromJson(e)).toList();
    return PostingModel(postingitems: items);
  }
}
