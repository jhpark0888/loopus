import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';

class QuestionItem {
  QuestionItem(
      {required this.id,
      required this.user,
      required this.isuser,
      required this.content,
      required this.answer,
      required this.adopt,
      required this.date,
      required this.department,
      required this.questionTag,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  int isuser;
  String? department;
  String content;
  String realname;
  String? profileimage;
  List<Answer> answer;
  bool? adopt;
  DateTime? date;
  List<Tag> questionTag;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        id: json["id"],
        user: json["user_id"],
        content: json["content"],
        profileimage:
            json["profile_image"] == null ? null : json["profile_image"],
        realname: json["real_name"],
        answer:
            List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x))),
        adopt: json["adopt"],
        questionTag:
            List<Tag>.from(json["question_tag"].map((x) => Tag.fromJson(x))),
        date: DateTime.parse(json["date"]),
        department: json["department"],
        isuser: json["is_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "answer": List<dynamic>.from(answer.map((x) => x.toJson())),
        "adopt": adopt,
        "question_tag": List<dynamic>.from(questionTag.map((x) => x.toJson())),
        "real_name": realname,
        "profile_image": profileimage == null ? null : profileimage,
        "department ": department,
        "is_user": isuser,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class Answer {
  Answer(
      {required this.id,
      required this.user,
      required this.content,
      required this.question,
      required this.adopt,
      required this.date,
      required this.department,
      required this.isuser,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  int? isuser;
  var department;
  String? realname;
  String? profileimage;
  String content;
  int question;
  bool adopt;
  DateTime date;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        user: json["user_id"],
        content: json["content"],
        question: json["question_id"],
        adopt: json["adopt"],
        date: DateTime.parse(json["date"]),
        profileimage:
            json["profile_image"] == null ? null : json["profile_image"],
        realname: json["real_name"] == null ? null : json["real_name"],
        isuser: json["is_user"] == null ? null : json["is_user"],
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "question_id": question,
        "department": department,
        "adopt": adopt,
        "is_user": isuser == null ? null : isuser,
        "real_name": realname == null ? null : realname,
        "profile_image": profileimage == null ? null : profileimage,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class QuestionModel2 {
  QuestionItem questions;
  QuestionModel2(this.questions);

  factory QuestionModel2.fromJson(Map<String, dynamic> json) {
    QuestionItem item = QuestionItem(
        id: 0,
        user: 0,
        content: "",
        answer: [],
        adopt: null,
        date: null,
        questionTag: [],
        realname: "",
        profileimage: null,
        department: '',
        isuser: -1);
    item = QuestionItem.fromJson(json);
    return QuestionModel2(item);
  }
}
