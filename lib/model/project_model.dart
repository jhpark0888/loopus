import 'dart:collection';

import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

class Project {
  Project(
      {required this.id,
      required this.userid,
      required this.fieldIds,
      this.postRatio,
      required this.careerName,
      this.startDate,
      this.endDate,
      required this.posts,
      required this.members,
      this.post_count,
      required this.is_user,
      this.isTop,
      required this.user,
      this.updateTime});

  int id;
  int? userid;
  double? postRatio;
  String careerName;
  List<String> fieldIds;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? updateTime;
  RxList<Post> posts;
  List<User> members;
  RxInt? post_count;
  User? user;
  bool? isTop;
  int is_user;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
      id: json['project_id'] != null
          ? json["project_id"]
          : json['id'] != null
              ? json["id"]
              : 0,
      userid: json["user_id"],
      careerName: json["project_name"],
      startDate: json["start_date"] != null
          ? DateTime.parse(json["start_date"])
          : null,
      endDate:
          json["end_date"] != null ? DateTime.parse(json["end_date"]) : null,
      posts: json["post"] != null
          ? RxList<Post>.from(json["post"].map((x) => Post.fromJson(x)))
          : <Post>[].obs,
      fieldIds: json["group"] != null
          ? [json["group"].toString()]
          // SplayTreeMap<String, int>.from(
          //             (json["group"] as Map<String, dynamic>),
          //             (keys1, keys2) => keys1.compareTo(keys2))
          //         .keys
          //         .toList()
          //         .isNotEmpty
          //     ? SplayTreeMap<String, int>.from(
          //         (json["group"] as Map<String, dynamic>),
          //         (keys1, keys2) => keys1.compareTo(keys2)).keys.toList()
          //     : ["10"]
          : ["10"],
      members: json["looper"] != null
          ? List<User>.from(
              json["looper"].map((x) => User.fromJson(x["profile"])))
          : [],
      postRatio:
          json['ratio'] != null ? double.parse(json['ratio'].toString()) : 0.0,
      post_count:
          json["post_count"] != null ? RxInt(json["post_count"]) : RxInt(0),
      is_user: json['is_user'] ?? 0,
      user: json["profile"] != null ? User.fromJson(json["profile"]) : null,
      updateTime: json['post_update_date'] != null ? DateTime.parse(json['post_update_date']) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
        "careerName": careerName,
        "start_date": startDate,
        "end_date": endDate,
        "posts": posts != null
            ? List<dynamic>.from(posts.map((x) => x.toJson()))
            : [],
        "members": members != null
            ? List<dynamic>.from(posts.map((x) => x.toJson()))
            : [],
        "post_count": post_count,
        "is_user": is_user,
      };
}
