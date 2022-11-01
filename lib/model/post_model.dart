import 'package:get/get.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/comment_model.dart';
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
      required this.links,
      required this.tags,
      required this.date,
      required this.project,
      required this.comments,
      required this.likeCount,
      required this.isLiked,
      required this.isMarked,
      required this.isuser,
      required this.user});

  int id;
  int userid;
  RxString content;
  List<String> images;
  List<String> links; //입력값 10개까지
  RxList<Comment> comments; //댓글
  RxList<Tag> tags;
  DateTime date;
  Project? project;
  RxInt likeCount;
  RxInt isLiked;
  RxInt isMarked;
  int isuser;
  User user;

  factory Post.fromJson(Map<String, dynamic> json) =>
      Get.isRegistered<PostingDetailController>(tag: json["id"].toString())
          ? Get.find<PostingDetailController>(tag: json["id"].toString())
                      .post !=
                  null
              ? Get.find<PostingDetailController>(tag: json["id"].toString())
                  .post!
                  .value
              : Post(
                  id: json["id"],
                  userid: json["user_id"],
                  content: RxString(json["contents"]),
                  images: json["contents_image"] != null
                      ? List<Map<String, dynamic>>.from(json["contents_image"])
                          .map((map) => map['image'].toString())
                          .toList()
                      : [],
                  links: json["contents_link"] != null
                      ? List<Map<String, dynamic>>.from(json["contents_link"])
                          .map((map) => map['link'].toString())
                          .toList()
                      : [],
                  tags: json['post_tag'] != null
                      ? List<Map<String, dynamic>>.from(json['post_tag'])
                          .map((tag) => Tag.fromJson(tag))
                          .toList()
                          .obs
                      : <Tag>[].obs,
                  date: DateTime.parse(json["date"]),
                  comments: json["comments"].runtimeType != List
                      ? <Comment>[Comment.fromJson(json["comments"])].obs
                      : List<Map<String, dynamic>>.from(json["comments"])
                          .map((comment) => Comment.fromJson(comment))
                          .toList()
                          .obs,
                  project: json["project"] != null
                      ? Project.fromJson(json["project"])
                      : null,
                  likeCount: json["like_count"] != null
                      ? RxInt(json["like_count"])
                      : RxInt(0),
                  isLiked: json["is_liked"] != null
                      ? RxInt(json["is_liked"])
                      : RxInt(0),
                  isMarked: json["is_marked"] != null
                      ? RxInt(json["is_marked"])
                      : RxInt(0),
                  isuser: json["is_user"] ?? 0,
                  user: User.fromJson(json["profile"]),
                )
          : Post(
              id: json["id"],
              userid: json["user_id"],
              content: RxString(json["contents"]),
              images: json["contents_image"] != null
                  ? List<Map<String, dynamic>>.from(json["contents_image"])
                      .map((map) => map['image'].toString())
                      .toList()
                  : [],
              links: json["contents_link"] != null
                  ? List<Map<String, dynamic>>.from(json["contents_link"])
                      .map((map) => map['link'].toString())
                      .toList()
                  : [],
              tags: json['post_tag'] != null
                  ? List<Map<String, dynamic>>.from(json['post_tag'])
                      .map((tag) => Tag.fromJson(tag))
                      .toList()
                      .obs
                  : <Tag>[].obs,
              date: DateTime.parse(json["date"]),
              comments: json["comments"].runtimeType != List
                  ? <Comment>[Comment.fromJson(json["comments"])].obs
                  : List<Map<String, dynamic>>.from(json["comments"])
                      .map((comment) => Comment.fromJson(comment))
                      .toList()
                      .obs,
              project: json["project"] != null
                  ? Project.fromJson(json["project"])
                  : null,
              likeCount: json["like_count"] != null
                  ? RxInt(json["like_count"])
                  : RxInt(0),
              isLiked:
                  json["is_liked"] != null ? RxInt(json["is_liked"]) : RxInt(0),
              isMarked: json["is_marked"] != null
                  ? RxInt(json["is_marked"])
                  : RxInt(0),
              isuser: json["is_user"] ?? 0,
              user: json['profile'] != null
                  ? User.fromJson(json["profile"])
                  : User.defaultuser(),
            );

  void copywith(Map<String, dynamic> json) {
    id = json["id"] ?? id;
    userid = json["user_id"] ?? userid;
    content.value = json["contents"] ?? content.value;

    images = json["contents_image"] != null
        ? List<Map<String, dynamic>>.from(json["contents_image"])
            .map((map) => map['image'].toString())
            .toList()
        : images;
    links = json["contents_link"] != null
        ? List<Map<String, dynamic>>.from(json["contents_link"])
            .map((map) => map['link'].toString())
            .toList()
        : links;
    tags.assignAll(json['post_tag'] != null
        ? List<Map<String, dynamic>>.from(json['post_tag'])
            .map((tag) => Tag.fromJson(tag))
            .toList()
        : tags);
    date = json["date"] != null ? DateTime.parse(json["date"]) : date;
    comments.assignAll(json["comments"].runtimeType != List
        ? <Comment>[Comment.fromJson(json["comments"])]
        : List<Map<String, dynamic>>.from(json["comments"])
            .map((comment) => Comment.fromJson(comment))
            .toList());

    project =
        json["project"] != null ? Project.fromJson(json["project"]) : project;
    // likeCount =
    //     json["like_count"] != null ? RxInt(json["like_count"]) : likeCount;
    // isLiked = json["is_liked"] != null ? RxInt(json["is_liked"]) : isLiked;
    // isMarked = json["is_marked"] != null ? RxInt(json["is_marked"]) : isMarked;
    isuser = json["is_user"] ?? isuser;
    user = json["profile"] != null ? Person.fromJson(json["profile"]) : user;
  }

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

// String contentsummary(List<Map<String, dynamic>> json) {
//   String summary = '';
//   for (var map in json) {
//     if (["T", "H1", "H2", "QUOTE", "BULLET", "LINK"].contains(map['type'])) {
//       summary = summary + map['content'];
//     }
//   }
//   // summary.replaceAll('\n', '');
//   return summary;
// }

// class PostContent {
//   PostContent({
//     required this.type,
//     required this.content,
//     this.url,
//   });

//   SmartTextType type;
//   String content;
//   String? url;

//   factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
//         type: SmartTextType.values.firstWhere((e) => e.name == json["type"]),
//         content: json["content"],
//         url: json["url"] ?? null,
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "content": content,
//         "url": url ?? null,
//       };
// }

// class PostingModel {
//   RxList<Post> postingitems;
//   PostingModel({required this.postingitems});

//   factory PostingModel.fromJson(List<dynamic> json) {
//     RxList<Post>? items = <Post>[].obs;
//     items.value = json.map((e) => Post.fromJson(e)).toList();
//     return PostingModel(postingitems: items);
//   }
// }
