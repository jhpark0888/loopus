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
    required this.isuser,
    required this.fieldId,
    this.profileImage,
    required this.profileTag,
    required this.looped,
    required this.banned,
  });

  int userid;
  String realName;
  int type;
  String department;
  int? isuser;
  RxInt loopcount;
  int totalposting;
  int fieldId;
  String? profileImage;
  List<Tag> profileTag;
  Rx<FollowState> looped;
  Rx<BanState> banned;

  factory User.defaultuser({
    int? userid,
    String? realName,
    int? type,
    String? department,
    int? isuser,
    RxInt? loopcount,
    int? fieldId,
    int? totalposting,
    String? profileImage,
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
          fieldId: fieldId ?? 10,
          isuser: isuser ?? 0,
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
        profileTag: json["profile_tag"] != null
            ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
            : [],
        fieldId:
            json["group"] != null ? int.parse(json["group"].toString()) : 10,
        department: json["department"] ?? '',
        isuser: json["is_user"] ?? 0,
        looped: json["looped"] != null
            ? FollowState.values[json["looped"]].obs
            : FollowState.normal.obs,
        banned: json["is_banned"] != null
            ? BanState.values[json["is_banned"]].obs
            : BanState.normal.obs,
      );

  Map<String, dynamic> toJson() => {
        "user": userid,
        "real_name": realName,
        "type": type,
        "profile_image": profileImage,
        "project_tag": List<dynamic>.from(profileTag.map((x) => x.toJson())),
      };
}
