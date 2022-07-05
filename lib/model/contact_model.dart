import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';

class Contact {
  Contact(
      {required this.id,
      required this.user,
      required this.company,
      required this.date});

  int id;
  User user;
  Company company;
  DateTime date;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'],
        user: json["user_id"],
        company: json["real_name"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "enterprise": company,
      };
}
