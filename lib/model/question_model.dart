import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';

class QuestionItem {
  QuestionItem(
      {required this.id,
      required this.user,
      required this.isuser,
      required this.content,
      required this.answercount,
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
  int answercount;
  String? department;
  String content;
  String realname;
  List<Answer> answer;
  String? profileimage;
  bool? adopt;
  DateTime? date;
  List<Tag> questionTag;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        id: json["id"],
        user: json["user_id"],
        content: json["content"],
        profileimage:
            json["profile_image"],
        realname: json["real_name"],
        adopt: json["adopt"],
        questionTag:
            List<Tag>.from(json["question_tag"].map((x) => Tag.fromJson(x))),
        date: DateTime.parse(json["date"]),
        department: json["department"],
        isuser: json["is_user"] ?? 0,
        answercount: json["count"] ?? 0,
        answer: json["answer"] != null ?
            List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "adopt": adopt,
        "question_tag": List<dynamic>.from(questionTag.map((x) => x.toJson())),
        "real_name": realname,
        "profile_image": profileimage == null ? null : profileimage,
        "department ": department,
        "is_user": isuser,
        "count": answercount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class Answer {
  Answer(
      {required this.id,
      required this.user,
      required this.content,
      required this.questionid,
      required this.adopt,
      required this.date,
      required this.department,
      required this.isuser,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  int isuser;
  String department;
  String? realname;
  String? profileimage;
  String content;
  int questionid;
  bool adopt;
  DateTime date;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        user: json["user_id"],
        content: json["content"],
        questionid: json["question_id"].runtimeType == String ? int.parse(json["question_id"]) : json["question_id"],
        adopt: json["adopt"],
        date: DateTime.parse(json["date"]),
        profileimage:
            json["profile_image"] ?? null,
        realname: json["real_name"] ?? null,
        isuser: json["is_user"] ?? 0,
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "question_id": questionid,
        "department": department,
        "adopt": adopt,
        "is_user": isuser == null ? null : isuser,
        "real_name": realname == null ? null : realname,
        "profile_image": profileimage == null ? null : profileimage,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class QuestionModel {
  RxList<QuestionItem> questionitems;
  QuestionModel({required this.questionitems});

  factory QuestionModel.fromJson(List<dynamic> json) {
    RxList<QuestionItem>? items = <QuestionItem>[].obs;
    items.value = json.map((e) => QuestionItem.fromJson(e)).toList();
    return QuestionModel(questionitems: items);
    // factory QuestionModel.fromJson(Map<dynamic> json) {
    //   List<Question>? items = [];
    //   items = json.map((e) => Question.fromJson(e)).toList();
    //   return QuestionModel(questionitems: items);
    // }
  }
}
