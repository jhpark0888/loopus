import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

class QuestionItem {
  QuestionItem(
      {required this.id,
      required this.userid,
      required this.isuser,
      required this.content,
      required this.answercount,
      required this.answer,
      required this.adopt,
      required this.date,
      required this.questionTag,
      required this.user});

  int id;
  int userid;
  int isuser;
  int answercount;
  String content;
  List<Answer> answer;
  bool? adopt;
  DateTime? date;
  List<Tag> questionTag;
  User user;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        id: json["id"],
        userid: json["user_id"],
        content: json["content"],
        adopt: json["adopt"],
        questionTag:
            List<Tag>.from(json["question_tag"].map((x) => Tag.fromJson(x))),
        date: DateTime.parse(json["date"]),
        isuser: json["is_user"] ?? 0,
        answercount: json["count"] ?? 0,
        answer: json["answer"] != null
            ? List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x)))
            : [],
        user: User.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "adopt": adopt,
        "question_tag": List<dynamic>.from(questionTag.map((x) => x.toJson())),
        "is_user": isuser,
        "count": answercount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class Answer {
  Answer(
      {required this.id,
      required this.userid,
      required this.content,
      required this.questionid,
      required this.date,
      required this.isuser,
      required this.user});

  int id;
  int userid;
  int isuser;
  String content;
  int questionid;
  DateTime date;
  User user;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
      id: json["id"],
      userid: json["user_id"],
      content: json["content"],
      questionid: json["question_id"].runtimeType == String
          ? int.parse(json["question_id"])
          : json["question_id"],
      date: DateTime.parse(json["date"]),
      isuser: json["is_user"] ?? 0,
      user: User.fromJson(json["profile"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userid,
        "content": content,
        "question_id": questionid,
        "is_user": isuser == null ? null : isuser,
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
