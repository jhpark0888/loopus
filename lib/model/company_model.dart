import 'package:get/get.dart';

class Company {
  Company({
    required this.id,
    required this.companyImage,
    required this.companyName,
    required this.contactField,
    required this.contactcount,
  });

  int id;
  String companyImage;
  String companyName;
  String contactField;
  RxInt contactcount;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['company_id'],
        companyImage: json['company_image'],
        companyName: json['company_name'],
        contactField: json['contact_field'],
        contactcount: json['count'] != null ? RxInt(json['count']) : RxInt(0),
      );
}
