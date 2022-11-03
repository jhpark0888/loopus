import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class Company extends User {
  Company({
    required userId,
    required profileImage,
    required name,
    required followed,
    required banned,
    required followerCount,
    required followingCount,
    required fieldId,
    required this.itrUsers,
    required this.contactcount,
    required this.homepage,
    required this.intro,
    required this.address,
    required this.images,
    required this.slogan,
    required this.category,
    required this.itrCount,
  }) : super(
          userId: userId,
          profileImage: profileImage,
          name: name,
          fieldId: fieldId,
          followed: followed,
          banned: banned,
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
  List<User> itrUsers;
  int itrCount;

  factory Company.defaultCompany(
          {int? userId,
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
          Rx<BanState>? banned,
          List<CompanyImage>? images,
          String? slogan,
          String? category,
          List<Person>? itrUsers,
          int? itrCount}) =>
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
          banned: banned ?? BanState.normal.obs,
          images: images ?? [],
          slogan: slogan ?? "",
          category: category ?? "",
          itrUsers: itrUsers ?? [],
          itrCount: itrCount ?? 0);

  factory Company.fromJson(Map<String, dynamic> json) => Company(
      userId: json['user_id'] ?? json['id'] ?? json['user'] ?? 0,
      profileImage: json["company_logo"] != null
          ? json["company_logo"].runtimeType == String
              ? json["company_logo"]
              : json["company_logo"]["logo"] ?? ""
          : json["logo"] != null ? json['logo'] : '',
      name: json['company_name'] != null
          ? json['company_name']
          : json["company_logo"] != null
              ? json["company_logo"]["company_name"] ?? ""
              : ""
                  "",
      followerCount: 0.obs,
      followingCount: 0.obs,
      fieldId: json['contact_field'] != null
          ? json['contact_field'].toString()
          : json["group"] != null
              ? json['group'].toString()
              : "16",
      contactcount: json['count'] != null ? RxInt(json['count']) : RxInt(0),
      homepage: json["homepage"] ?? "",
      intro: json["information"] ?? "",
      address: json["location"] ?? "",
      followed: json["looped"] != null
          ? FollowState.values[json["looped"]].obs
          : FollowState.normal.obs,
      banned: json["is_banned"] != null
          ? BanState.values[json["is_banned"]].obs
          : BanState.normal.obs,
      images: json["company_images"] != null
          ? json["company_images"].runtimeType != List
              ? [
                  json["company_images"].runtimeType == String
                      ? CompanyImage.fromString(json["company_images"])
                      : CompanyImage.fromJson(json["company_images"])
                ]
              : List.from(json["company_images"])
                  .map((image) => CompanyImage.fromJson(image))
                  .toList()
          : [],
      slogan: json["slogan"] ?? "",
      category: json["category"] ?? "",
      itrUsers: json["interest"] != null
          ? List.from(json["interest"])
              .map((person) => Person.fromJson(person))
              .toList()
          : [],
      itrCount: json["interest_count"] ?? 0);

  void copywith(Map<String, dynamic> json) {
    userId = json["user_id"] ?? json['id'] ?? userId;
    profileImage = json["company_logo"] != null
        ? json["company_logo"].runtimeType == String
            ? json["company_logo"]
            : json["company_logo"]["logo"] ?? profileImage
        : profileImage;
    name = json['company_name'] != null
        ? json['company_name']
        : json["company_logo"] != null
            ? json["company_logo"]["company_name"] ?? name
            : name;
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
    banned.value = json["is_banned"] != null
        ? BanState.values[json["is_banned"]]
        : banned.value;
    images = json["company_images"] != null
        ? json["company_images"].runtimeType != List
            ? [
                json["company_images"].runtimeType == String
                    ? CompanyImage.fromString(json["company_images"])
                    : CompanyImage.fromJson(json["company_images"])
              ]
            : List.from(json["company_images"])
                .map((image) => CompanyImage.fromJson(image))
                .toList()
        : images;
    slogan = json["slogan"] ?? slogan;
    category = json["category"] ?? category;
    itrUsers = json["interest"] != null
        ? List.from(json["interest"])
            .map((person) => Person.fromJson(person))
            .toList()
        : itrUsers;
    itrCount = json["interest_count"] ?? itrCount;
  }
}

class CompanyImage {
  CompanyImage({required this.image, required this.imageInfo});

  String imageInfo;
  String image;

  factory CompanyImage.fromJson(Map<String, dynamic> json) => CompanyImage(
        image: json['image'] ?? "",
        imageInfo: json["image_info"] ?? "",
      );

  factory CompanyImage.fromString(String image) => CompanyImage(
        image: image,
        imageInfo: "",
      );
}
