import 'package:loopus/model/tag_model.dart';

class User {
  User({
    required this.user,
    required this.realName,
    required this.type,
    required this.department,
    required this.loopcount,
    required this.totalposting,
    required this.isuser,
    this.profileImage,
    required this.profileTag,
  });

  int user;
  String realName;
  int type;
  String department;
  int? isuser;
  int loopcount;
  int totalposting;
  String? profileImage;
  List<Tag> profileTag;

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: json["user_id"],
        realName: json["real_name"],
        type: json["type"] ?? 0,
        profileImage: json["profile_image"],
        loopcount: json["loop_count"] ?? 0,
        totalposting: json["total_post_count"] ?? 0,
        profileTag: json["profile_tag"] != null
            ? List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x)))
            : [],
        department: json["department"],
        isuser: json["is_user"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "real_name": realName,
        "type": type,
        "profile_image": profileImage,
        "project_tag": List<dynamic>.from(profileTag.map((x) => x.toJson())),
      };
}
