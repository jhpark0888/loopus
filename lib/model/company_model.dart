import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class Company extends User {
  Company({
    required userId,
    required profileImage,
    required name,
    required followed,
    required followerCount,
    required followingCount,
    required this.contactField,
    required this.contactcount,
    required this.homepage,
    required this.intro,
    required this.address,
  }) : super(
          userId: userId,
          profileImage: profileImage,
          name: name,
          followed: followed,
          followerCount: followerCount,
          followingCount: followingCount,
          userType: UserType.company,
        );

  String contactField;
  RxInt contactcount;
  String homepage;
  String intro;
  String address;

  factory Company.defaultCompany({
    int? userId,
    String? profileImage,
    String? name,
    RxInt? followerCount,
    RxInt? followingCount,
    String? contactField,
    RxInt? contactcount,
    String? homepage,
    String? intro,
    String? address,
    Rx<FollowState>? followed,
  }) =>
      Company(
          userId: userId ?? 0,
          profileImage: profileImage ?? "",
          name: name ?? "",
          followerCount: followerCount ?? 0.obs,
          followingCount: followingCount ?? 0.obs,
          contactField: contactField ?? "10",
          contactcount: contactcount ?? 0.obs,
          homepage: homepage ?? "",
          intro: intro ?? "",
          address: address ?? "",
          followed: followed ?? FollowState.normal.obs);

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        userId: json['user_id'],
        profileImage: json["company_logo"] != null
            ? json["company_logo"]['logo'] ?? ""
            : "",
        name: json["company_logo"] != null
            ? json["company_logo"]['company_name'] ?? ""
            : "",
        followerCount: 0.obs,
        followingCount: 0.obs,
        contactField: json['contact_field'] ?? "10",
        contactcount: json['count'] != null ? RxInt(json['count']) : RxInt(0),
        homepage: json["homepage"],
        intro: json["information"],
        address: json["location"],
        followed: json["looped"] != null
            ? FollowState.values[json["looped"]].obs
            : FollowState.normal.obs,
      );
}
