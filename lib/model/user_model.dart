import 'package:loopus/model/tag_model.dart';

class User {
  User({
    required this.user,
    required this.realName,
    required this.type,
    required this.department,
    required this.isuser,
    this.profileImage,
    required this.profileTag,
  });

  int user;
  String realName;
  int type;
  String department;
  int? isuser;
  String? profileImage;
  List<Tag> profileTag;

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: json["user"],
        realName: json["real_name"],
        type: json["type"],
        profileImage: json["profile_image"],
        profileTag:
            List<Tag>.from(json["profile_tag"].map((x) => Tag.fromJson(x))),
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
