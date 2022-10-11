import 'dart:convert';

import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/screen/profile_sns_add_screen.dart';
import 'package:path/path.dart';

class User {
  User({
    required this.userid,
    required this.realName,
    required this.type,
    required this.univName,
    required this.univlogo,
    required this.department,
    required this.followerCount,
    required this.followingCount,
    required this.totalposting,
    required this.resentPostCount,
    required this.isuser,
    required this.fieldId,
    this.profileImage,
    required this.profileTag,
    required this.followed,
    required this.banned,
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
  });

  int userid;
  String realName;
  int type;
  String univName;
  String univlogo;
  String department;
  int? isuser;
  RxInt followerCount;
  RxInt followingCount;
  int totalposting;
  int resentPostCount;
  String fieldId;
  String? profileImage;
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
  Rx<FollowState> followed;
  Rx<BanState> banned;

  factory User.defaultuser({
    int? userid,
    String? realName,
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
      User(
          userid: userid ?? 0,
          realName: realName ?? "",
          type: type ?? 0,
          univName: univName ?? '',
          univlogo: univlogo ?? '',
          department: department ?? "",
          followerCount: followerCount ?? 0.obs,
          followingCount: followingCount ?? 0.obs,
          totalposting: totalposting ?? 0,
          fieldId: fieldId ?? "10",
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["user_id"],
        realName: json["real_name"],
        type: json["type"] ?? 0,
        profileImage: json["profile_image"],
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
        fieldId: json["group"] != null ? json["group"].toString() : "10",
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
    userid = json["user_id"] ?? userid;
    realName = json["real_name"] ?? realName;
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
        "user": userid,
        "real_name": realName,
        "type": type,
        "profile_image": profileImage,
        "project_tag": List<dynamic>.from(profileTag.map((x) => x.toJson())),
      };

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

