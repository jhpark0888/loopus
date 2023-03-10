import 'dart:io';

import 'package:get/get.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/my_company_controller.dart';
import 'package:loopus/controller/other_company_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
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
      required this.files,
      required this.fileCount,
      required this.tags,
      required this.date,
      required this.project,
      required this.comments,
      required this.commentCount,
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
  List<String> files;
  int fileCount;
  RxList<Comment> comments; //댓글
  RxList<Tag> tags;
  DateTime date;
  Project? project;
  RxInt commentCount;
  RxInt likeCount;
  RxInt isLiked;
  RxInt isMarked;
  int isuser;
  User user;

  factory Post.defaultPost({
    int? id,
    int? userid,
    RxString? content,
    List<String>? images,
    List<String>? links,
    List<String>? files,
    int? fileCount,
    RxList<Comment>? comments,
    RxList<Tag>? tags,
    DateTime? date,
    Project? project,
    RxInt? commentCount,
    RxInt? likeCount,
    RxInt? isLiked,
    RxInt? isMarked,
    int? isuser,
    User? user,
  }) =>
      Post(
          id: id ?? 0,
          userid: userid ?? 0,
          content: content ?? "".obs,
          images: images ?? [],
          links: links ?? [],
          files: files ?? [],
          fileCount: fileCount ?? 0,
          comments: comments ?? <Comment>[].obs,
          tags: tags ?? <Tag>[].obs,
          date: date ?? DateTime.now(),
          project: project ?? Project.defaultProject(),
          commentCount: commentCount ?? 0.obs,
          likeCount: likeCount ?? 0.obs,
          isLiked: isLiked ?? 0.obs,
          isMarked: isMarked ?? 0.obs,
          isuser: isuser ?? 0,
          user: user ?? User.defaultuser());

  factory Post.fromJson(Map<String, dynamic> json) =>
      Get.isRegistered<PostingDetailController>(tag: json["id"].toString())
          ? Get.find<PostingDetailController>(tag: json["id"].toString())
              .post
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
              files: json["contents_file"] != null
                  ? List<Map<String, dynamic>>.from(json["contents_file"])
                      .map((map) => map["file"].toString())
                      .toList()
                  : [],
              fileCount: json["file_count"] ?? 0,
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
              commentCount: json['comment_count'] != null
                  ? RxInt(json['comment_count'])
                  : RxInt(0),
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
    files = json["contents_file"] != null
        ? List<Map<String, dynamic>>.from(json["contents_file"])
            .map((map) => map["file"].toString())
            .toList()
        : files;
    fileCount = json["file_count"] ?? fileCount;
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
    likeCount.value = json["like_count"] ?? likeCount.value;
    isLiked.value = json["is_liked"] ?? isLiked.value;
    isMarked.value = json["is_marked"] ?? isMarked.value;
    isuser = json["is_user"] ?? isuser;
    user = json["profile"] != null ? User.fromJson(json["profile"]) : user;
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

  void _tapLikeOrBookMark(Post? post, bool isTapLike) {
    if (post != null && hashCode != post.hashCode) {
      if (isTapLike) {
        if (post.isLiked.value == 0) {
          post.isLiked.value = 1;
          post.likeCount.value += 1;
        } else {
          post.isLiked.value = 0;
          post.likeCount.value -= 1;
        }
      } else {
        if (post.isMarked.value == 0) {
          post.isMarked.value = 1;
        } else {
          post.isMarked.value = 0;
        }
      }
    }
  }

  // isTapLike = 1 : Like ,  isTapLike = 0 : Like
  void otherPageLikeOrBookMark(bool isTapLike) {
    if (isTapLike) {
      if (isLiked.value == 0) {
        isLiked.value = 1;
        likeCount.value += 1;
      } else {
        isLiked.value = 0;
        likeCount.value -= 1;
      }
    } else {
      if (isMarked.value == 0) {
        isMarked.value = 1;
      } else {
        isMarked.value = 0;
      }
    }

    Post? homePost =
        HomeController.to.posts.firstWhereOrNull((post) => post.id == id);
    _tapLikeOrBookMark(homePost, isTapLike);

    Post? searchPost = SearchController.to.searchPostList
        .firstWhereOrNull((post) => post.id == id);
    _tapLikeOrBookMark(searchPost, isTapLike);

    Post? careerBoardPost = CareerBoardController
        .to.popPostMap[CareerBoardController.to.currentFieldMap.keys.first]!
        .firstWhereOrNull((post) => post.id == id);
    _tapLikeOrBookMark(careerBoardPost, isTapLike);

    if (Get.isRegistered<BookmarkController>()) {
      Post? bookMarkPost =
          BookmarkController.to.posts.firstWhereOrNull((post) => post.id == id);
      print(hashCode == bookMarkPost.hashCode);

      _tapLikeOrBookMark(bookMarkPost, isTapLike);
    }

    if (Get.isRegistered<CareerDetailController>(tag: project!.id.toString())) {
      Post? careerPost =
          Get.find<CareerDetailController>(tag: project!.id.toString())
              .postList
              .firstWhereOrNull((post) => post.id == id);
      _tapLikeOrBookMark(careerPost, isTapLike);
    }

    if (user.userType == UserType.student) {
      if (Get.isRegistered<ProfileController>()) {
        Post? myProfilePost = ProfileController.to.allPostList
            .firstWhereOrNull((post) => post.id == id);
        print(hashCode == myProfilePost.hashCode);
        _tapLikeOrBookMark(myProfilePost, isTapLike);
      }

      if (Get.isRegistered<OtherProfileController>(tag: userid.toString())) {
        Post? otherProfilePost =
            Get.find<OtherProfileController>(tag: userid.toString())
                .allPostList
                .firstWhereOrNull((post) => post.id == id);
        _tapLikeOrBookMark(otherProfilePost, isTapLike);
      }
    } else if (user.userType == UserType.company) {
      if (Get.isRegistered<MyCompanyController>()) {
        Post? myCompProfilePost = MyCompanyController.to.allPostList
            .firstWhereOrNull((post) => post.id == id);
        _tapLikeOrBookMark(myCompProfilePost, isTapLike);
      }

      if (Get.isRegistered<OtherCompanyController>(tag: userid.toString())) {
        Post? otherCompProfilePost =
            Get.find<OtherCompanyController>(tag: userid.toString())
                .allPostList
                .firstWhereOrNull((post) => post.id == id);
        _tapLikeOrBookMark(otherCompProfilePost, isTapLike);
      }
    }

    for (Tag tag in tags) {
      if (Get.isRegistered<TagDetailController>(tag: tag.tagId.toString())) {
        Post? tagNewPost =
            Get.find<TagDetailController>(tag: tag.tagId.toString())
                .tagNewPostList
                .firstWhereOrNull((post) => post.id == id);

        _tapLikeOrBookMark(tagNewPost, isTapLike);

        Post? tagPopPost =
            Get.find<TagDetailController>(tag: tag.tagId.toString())
                .tagPopPostList
                .firstWhereOrNull((post) => post.id == id);
        _tapLikeOrBookMark(tagPopPost, isTapLike);
      }
    }

    if (Get.isRegistered<PostingDetailController>(tag: id.toString())) {
      Post? detailPost =
          Get.find<PostingDetailController>(tag: id.toString()).post.value;
      _tapLikeOrBookMark(detailPost, isTapLike);
    }
  }
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