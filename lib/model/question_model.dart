import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';

class QuestionItem {
  QuestionItem(
      {required this.id,
      required this.user,
      required this.is_user,
      required this.content,
      required this.answercount,
      required this.adopt,
      required this.date,
      required this.department,
      required this.questionTag,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  int is_user;
  int answercount;
  String? department;
  String content;
  String realname;
  String? profileimage;
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
        adopt: json["adopt"],
        questionTag:
            List<Tag>.from(json["question_tag"].map((x) => Tag.fromJson(x))),
        date: DateTime.parse(json["date"]),
        department: json["department"],
        is_user: -1,
        answercount: json["count"],
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
        "is_user": is_user,
        "count": answercount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
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
