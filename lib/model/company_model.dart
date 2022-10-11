import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class Company {
  Company({
    required this.id,
    required this.companyImage,
    required this.companyName,
    required this.contactField,
    required this.contactcount,
    required this.url,
    required this.intro,
    required this.address,
    required this.followed,
  });

  int id;
  String companyImage;
  String companyName;
  String contactField;
  RxInt contactcount;
  String url;
  String intro;
  String address;
  Rx<FollowState> followed;

  factory Company.defaultCompany({
    int? id,
    String? companyImage,
    String? companyName,
    String? contactField,
    RxInt? contactcount,
    String? url,
    String? intro,
    String? address,
    Rx<FollowState>? followed,
  }) =>
      Company(
          id: id ?? 0,
          companyImage: companyImage ?? "",
          companyName: companyName ?? "",
          contactField: contactField ?? "",
          contactcount: contactcount ?? 0.obs,
          url: url ?? "",
          intro: intro ?? "",
          address: address ?? "",
          followed: followed ?? FollowState.normal.obs);

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['company_id'],
        companyImage: json['company_image'] ?? "",
        companyName: json['company_name'],
        contactField: json['contact_field'],
        contactcount: json['count'] != null ? RxInt(json['count']) : RxInt(0),
        url: json["url"],
        intro: json["intro"],
        address: json["address"],
        followed: json["looped"] != null
            ? FollowState.values[json["looped"]].obs
            : FollowState.normal.obs,
      );
}
