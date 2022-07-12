import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';

class User {
  User({
    required this.userid,
    required this.realName,
    required this.type,
    required this.department,
    required this.loopcount,
    required this.totalposting,
    required this.resentPostCount,
    required this.isuser,
    required this.fieldId,
    this.profileImage,
    required this.profileTag,
    required this.looped,
    required this.banned,
    required this.rank,
    required this.trend,
    required this.fieldRank,
  });

  int userid;
  String realName;
  int type;
  String department;
  int? isuser;
  RxInt loopcount;
  int totalposting;
  int resentPostCount;
  String fieldId;
  String? profileImage;
  List<Tag> profileTag;
  int rank;
  int trend;
  double fieldRank;

  Rx<FollowState> looped;
  Rx<BanState> banned;

  factory User.defaultuser({
    int? userid,
    String? realName,
    int? type,
    String? department,
    int? isuser,
    RxInt? loopcount,
    String? fieldId,
    int? totalposting,
    int? resentPostCount,
    int? rank,
    int? trend,
    String? profileImage,
    double? fieldRank,
    List<Tag>? profileTag,
    Rx<FollowState>? looped,
    Rx<BanState>? banned,
  }) =>
      User(
          userid: userid ?? 0,
          realName: realName ?? "",
          type: type ?? 0,
          department: department ?? "",
          loopcount: loopcount ?? 0.obs,
          totalposting: totalposting ?? 0,
          fieldId: fieldId ?? "10",
          isuser: isuser ?? 0,
          rank: rank ?? 0,
          resentPostCount: resentPostCount ?? 0,
          trend: trend ?? 0,
          fieldRank: fieldRank ?? 0,
          profileTag: profileTag ?? [],
          looped: looped ?? FollowState.normal.obs,
          banned: banned ?? BanState.normal.obs);

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["user_id"],
        realName: json["real_name"],
        type: json["type"] ?? 0,
        profileImage: json["profile_image"],
        loopcount:
            json["loop_count"] != null ? RxInt(json["loop_count"]) : 0.obs,
        totalposting: json["total_post_count"] ?? 0,
        resentPostCount: json["recent_post_count"] ?? 0,
        rank: json["rank"] ?? 0,
        trend: json["trend"] ?? 0,
        profileTag: json["profile_tag"] != null
            ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
            : [],
        fieldId: json["group"] != null ? json["group"].toString() : "10",
        fieldRank: json["group_rank"] ?? 0.0,
        department: json["department"] ?? '',
        isuser: json["is_user"] ?? 0,
        looped: json["looped"] != null
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
    loopcount =
        json["loop_count"] != null ? RxInt(json["loop_count"]) : loopcount;
    totalposting = json["total_post_count"] ?? totalposting;
    resentPostCount = json["recent_post_count"] ?? resentPostCount;
    rank = json["rank"] ?? rank;
    trend = json["trend"] ?? trend;
    profileTag = json["profile_tag"] != null
        ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
        : profileTag;
    fieldId = json["group"] != null ? json["group"].toString() : fieldId;
    fieldRank = json["group_rank"] ?? fieldRank;
    department = json["department"] ?? department;
    isuser = json["is_user"] ?? isuser;
    looped = json["looped"] != null
        ? FollowState.values[json["looped"]].obs
        : looped;
    banned = json["is_banned"] != null
        ? BanState.values[json["is_banned"]].obs
        : banned;
  }

  Map<String, dynamic> toJson() => {
        "user": userid,
        "real_name": realName,
        "type": type,
        "profile_image": profileImage,
        "project_tag": List<dynamic>.from(profileTag.map((x) => x.toJson())),
      };
}
