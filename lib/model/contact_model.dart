import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';

class Contact {
  Contact({
    // required this.user,
    // required this.companyName,
    // required this.companyLogo,
    required this.companyImage,
    required this.group,
    required this.category,
    required this.slogan,
    required this.recommendation,
    required this.isFollow,
    required this.companyProfile,
  });

  // int id;
  // User user;
  // String companyName;
  // String companyLogo;
  String companyImage;
  int group;
  String category;
  String slogan;
  String recommendation;
  bool isFollow;
  CompanyProfile companyProfile;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
      // user: json["user_id"],
      // companyName: json["company_profile"],
      // companyLogo: json["logo"],
      companyProfile: CompanyProfile.fromJson(json["company_profile"]),
      companyImage: json["company_images"][0]['image'],
      group: json["group"],
      category: json["category"],
      slogan: json["slogan"] != null ? json['slogan'] : 'HR 시장의 새로운 바람 LOOPUS',
      recommendation: json["recommendation"] != null ? json['recommendation'] : '“당신 근처의 당근마켓"',
      isFollow: json["is_follow"] != null ? json['is_follow'] : false);

  Map<String, dynamic> toJson() => {
        // "user": user,
        // "enterprise": company,
      };
}

class CompanyProfile {
  CompanyProfile({
    required this.companyName,
    required this.companyLogo,
  });

  String companyName;
  String companyLogo;

  factory CompanyProfile.fromJson(Map<String, dynamic> json) => CompanyProfile(
      companyName: json["company_name"], companyLogo: json["logo"]);
}


// import 'package:loopus/model/company_model.dart';
// import 'package:loopus/model/user_model.dart';

// class Contact {
//   Contact(
//       {required this.id,
//       required this.user,
//       required this.company,
//       required this.date});

//   int id;
//   User user;
//   Company company;
//   DateTime date;

//   factory Contact.fromJson(Map<String, dynamic> json) => Contact(
//         id: json['id'],
//         user: json["user_id"],
//         company: json["real_name"],
//         date: json["date"],
//       );

//   Map<String, dynamic> toJson() => {
//         "user": user,
//         "enterprise": company,
//       };
// }
