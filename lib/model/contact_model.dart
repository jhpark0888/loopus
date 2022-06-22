import 'package:loopus/model/enterprise_model.dart';
import 'package:loopus/model/user_model.dart';

class Contact {
  Contact(
      {required this.id,
      required this.user,
      required this.enterprise,
      required this.date});

  int id;
  User user;
  Enterprise enterprise;
  DateTime date;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'],
        user: json["user_id"],
        enterprise: json["real_name"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "enterprise": enterprise,
      };
}
