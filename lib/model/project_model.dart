import 'dart:collection';

import 'package:get/get.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

class Project {
  Project(
      {required this.id,
      required this.userid,
      required this.fieldId,
      this.postRatio,
      required this.careerName,
      required this.thumbnail,
      required this.updateDate,
      required this.posts,
      required this.members,
      this.post_count,
      required this.is_user,
      this.isTop,
      required this.user,
      required this.isPublic,
      this.company,
      this.managerId});

  int id;
  int? userid;
  double? postRatio;
  String careerName;
  String thumbnail;
  String fieldId;
  DateTime? updateDate;
  RxList<Post> posts;
  List<Person> members;
  RxInt? post_count;
  Person user;
  bool? isTop;
  int is_user;
  bool isPublic;
  int? managerId;
  Company? company;

  factory Project.defaultProject(
          {int? id,
          int? userid,
          double? postRatio,
          String? careerName,
          String? thumbnail,
          String? fieldId,
          DateTime? updateDate,
          RxList<Post>? posts,
          List<Person>? members,
          RxInt? post_count,
          Person? user,
          bool? isTop,
          int? is_user,
          bool? isPublic,
          int? managerId,
          Company? company}) =>
      Project(
          id: id ?? 0,
          userid: userid ?? 0,
          careerName: careerName ?? "",
          thumbnail: thumbnail ?? "",
          updateDate: updateDate ?? DateTime.now(),
          posts: posts ?? <Post>[].obs,
          fieldId: fieldId ?? "16",
          members: members ?? [],
          postRatio: postRatio ?? 0.0,
          post_count: post_count ?? RxInt(0),
          is_user: is_user ?? 0,
          user: user ?? Person.defaultuser(),
          isPublic: isPublic ?? false,
          managerId: managerId ?? 0,
          company: company);
  void copyWith(Map<String, dynamic> json) {
    bool isProject = json["project"] != null;
    bool isCompany = isProject && json['project']['thumbnail'] != null
        ? json['project']['thumbnail'].runtimeType != String
        : false;

    id = isProject
        ? json["project"]['project_id'] != null
            ? json["project"]["project_id"]
            : json["project"]['id'] != null
                ? json["project"]["id"]
                : id
        : json["id"] ?? id;
    userid = json["user_id"] ?? userid;
    careerName = isProject
        ? json["project"]["project_name"] ?? careerName
        : json["project_name"] ?? careerName;
    thumbnail = isCompany
        ? json['project']['thumbnail']['company_logo'] ?? thumbnail
        : isProject
            ? json["project"]["thumbnail"] ?? thumbnail
            : json["thumbnail"] ?? thumbnail;
    updateDate = isProject
        ? json["project"]["post_update_date"] != null
            ? DateTime.parse(json["project"]["post_update_date"])
            : updateDate
        : json["post_update_date"] != null
            ? DateTime.parse(json["post_update_date"])
            : updateDate;
    posts = json["post"] != null
        ? RxList<Post>.from(json["post"].map((x) => Post.fromJson(x)))
        : posts;
    fieldId = isProject
        ? json["project"]["group"] != null
            ? json["project"]["group"].toString()
            : fieldId
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

        : json["group"] != null
            ? json["group"].toString()
            : fieldId;
    members = json["member"] != null
        ? List<Person>.from(json["member"].map((x) => x['profile'] != null
            ? Person.fromJson(x["profile"])
            : Person.fromJson(x)))
        : members;
    postRatio = json['ratio'] != null
        ? double.parse(json['ratio'].toString())
        : postRatio;
    post_count =
        json["post_count"] != null ? RxInt(json["post_count"]) : post_count;
    is_user = json['is_user'] ?? is_user;
    user = json["profile"] != null ? Person.fromJson(json["profile"]) : user;
    isPublic =
        json["project"] != null ? json["project"]["is_public"] : isPublic;
    managerId = isProject
        ? json['manager']
        : json['member'] != null
            ? (List.from(json['member'])
                    .where((element) => element['is_manager'] != null))
                .first['profile']['user_id']
            : managerId;
    company =
        isCompany ? Company.fromJson(json['project']['thumbnail']) : company;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    bool isProject = json["project"] != null;
    bool isCompany = isProject && json['project']['thumbnail'] != null
        ? json['project']['thumbnail'].runtimeType != String
        : false;
    return Project(
        id: isProject
            ? json["project"]['project_id'] != null
                ? json["project"]["project_id"]
                : json["project"]['id'] != null
                    ? json["project"]["id"]
                    : 0
            : json["id"] ?? 0,
        userid: json["user_id"],
        careerName: isProject
            ? json["project"]["project_name"] ?? ""
            : json["project_name"] ?? "",
        thumbnail: isCompany
            ? json['project']['thumbnail']['company_logo'] ?? ""
            : isProject
                ? json["project"]["thumbnail"] ?? ""
                : json["thumbnail"] ?? "",
        updateDate: isProject
            ? json["project"]["post_update_date"] != null
                ? DateTime.parse(json["project"]["post_update_date"])
                : null
            : json["post_update_date"] != null
                ? DateTime.parse(json["post_update_date"])
                : null,
        posts: json["post"] != null
            ? RxList<Post>.from(json["post"].map((x) => Post.fromJson(x)))
            : <Post>[].obs,
        fieldId: isProject
            ? json["project"]["group"] != null
                ? json["project"]["group"].toString()
                : "16"
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

            : json["group"] != null
                ? json["group"].toString()
                : "16",
        members: json["member"] != null
            ? List<Person>.from(json["member"].map((x) => x['profile'] != null
                ? Person.fromJson(x["profile"])
                : Person.fromJson(x)))
            : [],
        postRatio: json['ratio'] != null
            ? double.parse(json['ratio'].toString())
            : 0.0,
        post_count:
            json["post_count"] != null ? RxInt(json["post_count"]) : RxInt(0),
        is_user: json['is_user'] ?? 0,
        user: json["profile"] != null
            ? Person.fromJson(json["profile"])
            : Person.defaultuser(),
        isPublic:
            json["project"] != null ? json["project"]["is_public"] : false,
        managerId: isProject
            ? json['manager']
            : json['member'] != null
                ? (List.from(json['member'])
                        .where((element) => element['is_manager'] != null))
                    .first['profile']['user_id']
                : 0,
        company:
            isCompany ? Company.fromJson(json['project']['thumbnail']) : null);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
        "careerName": careerName,
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
