import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';

class Enterprise {
  Enterprise({
    required this.id,
    required this.name,
    required this.field,
    required this.contactcount,
    this.enterpriseImage,
  });

  int id;
  String name;
  String field;
  RxInt contactcount;
  String? enterpriseImage;

  factory Enterprise.fromJson(Map<String, dynamic> json) => Enterprise(
        id: json["user_id"],
        name: json["real_name"],
        enterpriseImage: json["profile_image"],
        contactcount:
            json["loop_count"] != null ? RxInt(json["loop_count"]) : 0.obs,
        field: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "user": id,
        "real_name": name,
        "profile_image": enterpriseImage,
      };
}
