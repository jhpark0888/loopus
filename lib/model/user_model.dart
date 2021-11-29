class User {
  User({
    required this.user,
    required this.realName,
    required this.type,
    required this.classNum,
    this.profileImage,
  });

  int user;
  String realName;
  int type;
  String classNum;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: json["user"],
        realName: json["real_name"],
        type: json["type"],
        classNum: json["class_num"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "real_name": realName,
        "type": type,
        "class_num": classNum,
        "profile_image": profileImage,
      };
}
