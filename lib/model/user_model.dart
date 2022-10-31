import 'dart:convert';

import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/screen/profile_sns_add_screen.dart';
import 'package:path/path.dart';

class User {
  User(
      {required this.userId,
      required this.name,
      required this.fieldId,
      required this.profileImage,
      required this.followed,
      required this.banned,
      required this.followerCount,
      required this.followingCount,
      required this.userType});

  int userId;
  String name;
  String profileImage;
  String fieldId;
  Rx<FollowState> followed;
  Rx<BanState> banned;
  RxInt followerCount;
  RxInt followingCount;
  UserType userType;

  factory User.defaultuser({
    int? userId,
    String? name,
    String? fieldId,
    RxInt? followerCount,
    RxInt? followingCount,
    String? profileImage,
    Rx<FollowState>? followed,
    Rx<BanState>? banned,
    UserType? userType,
  }) =>
      User(
        userId: userId ?? 0,
        name: name ?? "",
        fieldId: fieldId ?? "",
        profileImage: profileImage ?? "",
        followerCount: followerCount ?? 0.obs,
        followingCount: followingCount ?? 0.obs,
        followed: followed ?? FollowState.normal.obs,
        banned: banned ?? BanState.normal.obs,
        userType: userType ?? UserType.student,
      );

  factory User.fromJson(Map<String, dynamic> json) {
    bool isStudent = json["department"] != null;
    if (isStudent == true) {
      return Person.fromJson(json);
    } else {
      return Company.fromJson(json);
    }
  }

  void followClick() {
    if (followed.value == FollowState.normal) {
      // followController.islooped(1);
      followed(FollowState.following);
      followerCount.value += 1;
    } else if (followed.value == FollowState.follower) {
      // followController.islooped(1);

      followed(FollowState.wefollow);
      followerCount.value += 1;
    } else if (followed.value == FollowState.following) {
      // followController.islooped(0);

      followed(FollowState.normal);
      followerCount.value -= 1;
    } else if (followed.value == FollowState.wefollow) {
      // followController.islooped(0);

      followed(FollowState.follower);
      followerCount.value -= 1;
    }
  }

  void banClick() {
    if (banned.value == BanState.normal) {
      banned(BanState.ban);
    } else if (banned.value == BanState.ban) {
      banned(BanState.normal);
    } else if (banned.value == BanState.isbanned) {
      banned(BanState.ban);
    }
  }
}

class Person extends User {
  Person({
    required userId,
    required name,
    required this.type,
    required this.univName,
    required this.univlogo,
    required this.department,
    required followerCount,
    required followingCount,
    required this.totalposting,
    required this.resentPostCount,
    required this.isuser,
    required fieldId,
    required profileImage,
    required this.profileTag,
    required followed,
    required banned,
    required this.rank,
    required this.lastRank,
    required this.schoolRank,
    required this.schoolLastRank,
    required this.groupRatio,
    required this.schoolRatio,
    required this.groupRatioVariance,
    required this.schoolRatioVariance,
    required this.admissionYear,
    required this.snsList,
  }) : super(
            userId: userId,
            name: name,
            fieldId: fieldId,
            profileImage: profileImage,
            followerCount: followerCount,
            followingCount: followingCount,
            banned: banned,
            followed: followed,
            userType: UserType.student);

  int type;
  String univName;
  String univlogo;
  String department;
  int? isuser;
  int totalposting;
  int resentPostCount;
  List<Tag> profileTag;
  int rank;
  int lastRank;
  int schoolRank;
  int schoolLastRank;
  double groupRatio;
  double schoolRatio;
  double groupRatioVariance;
  double schoolRatioVariance;
  String admissionYear;
  RxList<SNS> snsList;

  factory Person.defaultuser({
    int? userId,
    String? name,
    int? type,
    String? univName,
    String? univlogo,
    String? department,
    int? isuser,
    RxInt? followerCount,
    RxInt? followingCount,
    String? fieldId,
    int? totalposting,
    int? resentPostCount,
    int? rank,
    int? lastRank,
    int? schoolRank,
    int? schoolLastRank,
    double? groupRatio,
    double? schoolRatio,
    double? groupRatioVariance,
    double? schoolRatioVariance,
    String? profileImage,
    List<Tag>? profileTag,
    String? admissionYear,
    RxList<SNS>? snsList,
    Rx<FollowState>? followed,
    Rx<BanState>? banned,
  }) =>
      Person(
          userId: userId ?? 0,
          name: name ?? "",
          profileImage: profileImage ?? "",
          type: type ?? 0,
          univName: univName ?? '',
          univlogo: univlogo ?? '',
          department: department ?? "",
          followerCount: followerCount ?? 0.obs,
          followingCount: followingCount ?? 0.obs,
          totalposting: totalposting ?? 0,
          fieldId: fieldId ?? "16",
          isuser: isuser ?? 0,
          rank: rank ?? 0,
          lastRank: lastRank ?? 0,
          schoolRank: schoolRank ?? 0,
          schoolLastRank: schoolLastRank ?? 0,
          resentPostCount: resentPostCount ?? 0,
          groupRatio: groupRatio ?? 0,
          schoolRatio: schoolRatio ?? 0,
          groupRatioVariance: groupRatioVariance ?? 0,
          schoolRatioVariance: schoolRatioVariance ?? 0,
          profileTag: profileTag ?? [],
          admissionYear: admissionYear ?? "2000",
          snsList: snsList ?? <SNS>[].obs,
          followed: followed ?? FollowState.normal.obs,
          banned: banned ?? BanState.normal.obs);

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        userId: json["user_id"],
        name: json["real_name"],
        type: json["type"] ?? 0,
        profileImage: json["profile_image"] ?? "",
        followerCount: json["follower_count"] != null
            ? RxInt(json["follower_count"])
            : 0.obs,
        followingCount: json["following_count"] != null
            ? RxInt(json["following_count"])
            : 0.obs,
        totalposting: json["total_post_count"] ?? 0,
        resentPostCount: json["recent_post_count"] ?? 0,
        rank: json["rank"] != null ? json["rank"] as int : 0,
        lastRank: json["last_rank"] != null ? json["last_rank"] as int : 0,
        schoolRank:
            json["school_rank"] != null ? json["school_rank"] as int : 0,
        schoolLastRank: json["school_last_rank"] != null
            ? json["school_last_rank"] as int
            : 0,
        groupRatio:
            json["group_ratio"] != null ? json["group_ratio"] as double : 0,
        schoolRatio:
            json["school_ratio"] != null ? json["school_ratio"] as double : 0,
        groupRatioVariance: json["group_rank_variance"] != null
            ? json["group_rank_variance"] as double
            : 0,
        schoolRatioVariance: json["school_rank_variance"] != null
            ? json["school_rank_variance"] as double
            : 0,
        profileTag: json["profile_tag"] != null
            ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
            : [],
        fieldId: json["group"] != null ? json["group"].toString() : "16",
        univName: json["school"] != null
            ? json['school']['school_name']
            : json["school_name"] ?? '',
        univlogo: json["school"] != null ? json['school']['logo'] : '',
        department: json["department"] ?? '',
        isuser: json["is_user"] ?? 0,
        admissionYear: json["admission"] ?? "2000",
        snsList: json["user_sns"] != null
            ? List.from(json["user_sns"])
                .map((sns) => SNS.fromJson(sns))
                .toList()
                .obs
            : <SNS>[].obs,
        followed: json["looped"] != null
            ? FollowState.values[json["looped"]].obs
            : FollowState.normal.obs,
        banned: json["is_banned"] != null
            ? BanState.values[json["is_banned"]].obs
            : BanState.normal.obs,
      );

  void copywith(Map<String, dynamic> json) {
    userId = json["user_id"] ?? userId;
    name = json["real_name"] ?? name;
    type = json["type"] ?? type;
    profileImage = json["profile_image"] ?? profileImage;
    followerCount.value = json["follower_count"] != null
        ? json["follower_count"] as int
        : followerCount.value;
    followingCount.value = json["following_count"] != null
        ? json["following_count"] as int
        : followingCount.value;
    totalposting = json["total_post_count"] ?? totalposting;
    resentPostCount = json["recent_post_count"] ?? resentPostCount;
    rank = json["rank"] != null ? json["rank"] as int : rank;
    lastRank = json["last_rank"] != null ? json["last_rank"] as int : lastRank;
    schoolRank =
        json["school_rank"] != null ? json["school_rank"] as int : schoolRank;
    schoolLastRank = json["school_last_rank"] != null
        ? json["school_last_rank"] as int
        : schoolLastRank;
    groupRatio = json["group_ratio"] != null
        ? json["group_ratio"] as double
        : groupRatio;
    schoolRatio = json["school_ratio"] != null
        ? json["school_ratio"] as double
        : schoolRatio;
    groupRatioVariance = json["group_rank_variance"] != null
        ? json["group_rank_variance"] as double
        : groupRatioVariance;
    schoolRatioVariance = json["school_rank_variance"] != null
        ? json["school_rank_variance"] as double
        : schoolRatioVariance;
    profileTag = json["profile_tag"] != null
        ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
        : profileTag;
    fieldId = json["group"] != null ? json["group"].toString() : fieldId;
    univName = json["school"] != null
        ? json["school"]['school_name']
        : json["school_name"] ?? univName;
    univlogo = json["school"] != null ? json['school']['logo'] : univlogo;
    department = json["department"] ?? department;
    admissionYear = json["admission"] ?? admissionYear;
    snsList = json["user_sns"] != null
        ? List.from(json["user_sns"])
            .map((sns) => SNS.fromJson(sns))
            .toList()
            .obs
        : snsList;
    isuser = json["is_user"] ?? isuser;
    followed.value = json["looped"] != null
        ? FollowState.values[json["looped"]]
        : followed.value;
    banned.value = json["is_banned"] != null
        ? BanState.values[json["is_banned"]]
        : banned.value;
  }

  Map<String, dynamic> toJson() => {
        "user": userId,
        "real_name": name,
        "type": type,
        "profile_image": profileImage,
        "project_tag": List<dynamic>.from(profileTag.map((x) => x.toJson())),
      };
}

// class Rank {
//   String fieldId;
//   double groupRatio;
//   double schoolRatio;

//   Rank({
//     required this.fieldId,
//     required this.groupRatio,
//     required this.schoolRatio,
//   });

//   factory Rank.fromJson(Map<String, dynamic> json) => Rank(
//         fieldId: json["group"] != null ? json["group"].toString() : "10",
//         groupRatio:
//             json["group_ratio"] != null ? json["group_ratio"] as double : 0,
//         schoolRatio:
//             json["school_ratio"] != null ? json["school_ratio"] as double : 0,
//       );
// }

