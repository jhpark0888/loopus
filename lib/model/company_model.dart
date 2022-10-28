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
    required fieldId,
    required this.contactcount,
    required this.homepage,
    required this.intro,
    required this.address,
    required this.images,
    required this.slogan,
    required this.category,
  }) : super(
          userId: userId,
          profileImage: profileImage,
          name: name,
          fieldId: fieldId,
          followed: followed,
          followerCount: followerCount,
          followingCount: followingCount,
          userType: UserType.company,
        );

  RxInt contactcount;
  String homepage;
  String intro;
  String address;
  List<CompanyImage> images;
  String slogan;
  String category;

  factory Company.defaultCompany({
    int? userId,
    String? profileImage,
    String? name,
    RxInt? followerCount,
    RxInt? followingCount,
    String? fieldId,
    RxInt? contactcount,
    String? homepage,
    String? intro,
    String? address,
    Rx<FollowState>? followed,
    List<CompanyImage>? images,
    String? slogan,
    String? category,
  }) =>
      Company(
        userId: userId ?? 0,
        profileImage: profileImage ?? "",
        name: name ?? "",
        followerCount: followerCount ?? 0.obs,
        followingCount: followingCount ?? 0.obs,
        fieldId: fieldId ?? "16",
        contactcount: contactcount ?? 0.obs,
        homepage: homepage ?? "",
        intro: intro ?? "",
        address: address ?? "",
        followed: followed ?? FollowState.normal.obs,
        images: images ?? [],
        slogan: slogan ?? "",
        category: category ?? "",
      );

  factory Company.fromJson(Map<String, dynamic> json) => Company(
      userId: json['user_id'] ?? json['id'] ?? json['user'],
      profileImage: json["company_logo"] != null
          ? json["company_logo"]['logo'] ?? ""
          : json['logo'] ?? "",
      name: json["company_logo"] != null
          ? json["company_logo"]['company_name'] ?? ""
          : json['company_name'] ?? "",
      followerCount: 0.obs,
      followingCount: 0.obs,
      fieldId: json['contact_field'] ?? "16",
      contactcount: json['count'] != null ? RxInt(json['count']) : RxInt(0),
      homepage: json["homepage"] ?? "",
      intro: json["information"] ?? "",
      address: json["location"] ?? "",
      followed: json["looped"] != null
          ? FollowState.values[json["looped"]].obs
          : FollowState.normal.obs,
      images: json["company_images"] != null
          ? json["company_images"].runtimeType != Iterable
              ? [CompanyImage.fromJson(json["company_images"])]
              : List.from(json["company_images"])
                  .map((image) => CompanyImage.fromJson(image))
                  .toList()
          : [],
      slogan: json["slogan"] ?? "",
      category: json["category"] ?? "");

  void copywith(Map<String, dynamic> json) {
    userId = json["user_id"] ?? json['id'] ?? userId;
    profileImage = json["company_logo"] != null
        ? json["company_logo"]['logo'] ?? profileImage
        : json['logo'] ?? profileImage;
    name = json["company_logo"] != null
        ? json["company_logo"]['company_name'] ?? name
        : json['company_name'] ?? name;
    followerCount.value = json["follower_count"] != null
        ? json["follower_count"] as int
        : followerCount.value;
    followingCount.value = json["following_count"] != null
        ? json["following_count"] as int
        : followingCount.value;

    fieldId = json['contact_field'] ?? fieldId;
    contactcount = json['count'] != null ? RxInt(json['count']) : contactcount;
    homepage = json["homepage"] ?? homepage;
    intro = json["information"] ?? intro;
    address = json["location"] ?? address;
    followed = json["looped"] != null
        ? FollowState.values[json["looped"]].obs
        : followed;
    images = json["company_images"] != null
        ? List.from(json["company_images"])
            .map((image) => CompanyImage.fromJson(image))
            .toList()
        : images;
    slogan = json["slogan"] ?? slogan;
    category = json["category"] ?? category;
  }
}

class CompanyImage {
  CompanyImage({required this.image, required this.imageInfo});

  String imageInfo;
  String image;

  factory CompanyImage.fromJson(Map<String, dynamic> json) => CompanyImage(
        image: json['image'] ?? "",
        imageInfo: json["imageInfo"] ?? "",
      );
}
