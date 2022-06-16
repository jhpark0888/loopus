import 'package:get/get.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

import '../constant.dart';

class Post {
  Post(
      {required this.id,
      required this.userid,
      required this.content,
      required this.images,
      required this.tags,
      required this.date,
      required this.project,
      required this.likeCount,
      required this.isLiked,
      required this.isMarked,
      required this.isuser,
      required this.user});

  int id;
  int userid;
  String content;
  List<String> images;
  // List<Scrap> scraps 입력값 10개까지
  // List<Comment> comments 댓글
  List<Tag> tags;
  DateTime date;
  Project? project;
  RxInt likeCount;
  RxInt isLiked;
  RxInt isMarked;
  int isuser;
  User user;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userid: json["user_id"],
        content: json["contents"],
        images: json["contents_image"] != null
            ? List<Map<String, dynamic>>.from(json["contents_image"])
                .map((map) => map['image'].toString())
                .toList()
            : [],
        tags: json['post_tag'] != null
            ? List<Map<String, dynamic>>.from(json['post_tag'])
                .map((tag) => Tag.fromJson(tag))
                .toList()
            : [],
        date: DateTime.parse(json["date"]),
        project:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        likeCount: RxInt(json["like_count"]),
        isLiked: json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
        isMarked:
            json["is_marked"] != null ? RxInt(json["is_marked"]) : RxInt(0),
        isuser: json["is_user"] ?? 0,
        user: User.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
        "title": content,
        "date": date.toIso8601String(),
        "project": project!.toJson(),
        "like_count": likeCount,
        "is_liked": isLiked,
        "is_marked": isMarked,
      };
}

String contentsummary(List<Map<String, dynamic>> json) {
  String summary = '';
  for (var map in json) {
    if (["T", "H1", "H2", "QUOTE", "BULLET", "LINK"].contains(map['type'])) {
      summary = summary + map['content'];
    }
  }
  // summary.replaceAll('\n', '');
  return summary;
}

// String type = "T";
// SmartTextType smartTextType =
//     SmartTextType.values.firstWhere((e) => e.name == type);
// print(smartTextType.name);

class PostContent {
  PostContent({
    required this.type,
    required this.content,
    this.url,
  });

  SmartTextType type;
  String content;
  String? url;

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        type: SmartTextType.values.firstWhere((e) => e.name == json["type"]),
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
