import 'package:get/get.dart';

class QuestionItem {
  QuestionItem({
    required this.myQuestions,
    required this.questions,
  });

  List<Question> myQuestions;
  RxList<Question> questions;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        myQuestions: List<Question>.from(
            json["my_questions"].map((x) => Question.fromJson(x))),
        questions: RxList<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "my_questions": List<dynamic>.from(myQuestions.map((x) => x.toJson())),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  Question(
      {required this.id,
      required this.user,
      required this.questioner,
      required this.content,
      required this.answers,
      required this.adopt,
      required this.date,
      required this.questionTag,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  String questioner;
  String content;
  String realname;
  String? profileimage;
  List<Answer> answers;
  bool? adopt;
  DateTime? date;
  List<QuestionTag> questionTag;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        user: json["user"],
        questioner: json["questioner"],
        content: json["content"],
        profileimage:
            json["profile_image"] == null ? null : json["profile_image"],
        realname: json["real_name"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        adopt: json["adopt"],
        questionTag: List<QuestionTag>.from(
            json["question_tag"].map((x) => QuestionTag.fromJson(x))),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "questioner": questioner,
        "content": content,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "adopt": adopt,
        "question_tag": List<dynamic>.from(questionTag.map((x) => x.toJson())),
        "real_name": realname,
        "profile_image": profileimage == null ? null : profileimage,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class QuestionTag {
  QuestionTag({
    required this.tagId,
    required this.tag,
  });

  int tagId;
  String tag;

  factory QuestionTag.fromJson(Map<String, dynamic> json) => QuestionTag(
        tagId: json["tag_id"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "tag": tag,
      };
}

class Answer {
  Answer(
      {required this.id,
      required this.user,
      required this.answerer,
      required this.content,
      required this.question,
      required this.adopt,
      required this.date,
      required this.isuser,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  String answerer;
  int? isuser;
  String? realname;
  String? profileimage;
  String content;
  int question;
  bool adopt;
  DateTime date;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        user: json["user"],
        answerer: json["answerer"],
        content: json["content"],
        question: json["question"],
        adopt: json["adopt"],
        date: DateTime.parse(json["date"]),
        profileimage:
            json["profile_image"] == null ? null : json["profile_image"],
        realname: json["real_name"] == null ? null : json["real_name"],
        isuser: json["is_user"] == null ? null : json["is_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "answerer": answerer,
        "content": content,
        "question": question,
        "adopt": adopt,
        "is_user": isuser == null ? null : isuser,
        "real_name": realname == null ? null : realname,
        "profile_image": profileimage == null ? null : profileimage,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class QuestionModel {
  QuestionItem questionitems;
  QuestionModel(this.questionitems);

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    QuestionItem item = QuestionItem(
        myQuestions: [],
        questions: [
          Question(
              id: 0,
              user: 0,
              questioner: "",
              content: "",
              answers: [],
              adopt: null,
              date: null,
              questionTag: [],
              realname: "",
              profileimage: null)
        ].obs);
    item = QuestionItem.fromJson(json);
    return QuestionModel(item);
    // factory QuestionModel.fromJson(Map<dynamic> json) {
    //   List<Question>? items = [];
    //   items = json.map((e) => Question.fromJson(e)).toList();
    //   return QuestionModel(questionitems: items);
    // }
  }
}

class QuestionModel2 {
  Question questions;
  QuestionModel2(this.questions);

  factory QuestionModel2.fromJson(Map<String, dynamic> json) {
    Question item = Question(
        id: 0,
        user: 0,
        questioner: "",
        content: "",
        answers: [],
        adopt: null,
        date: null,
        questionTag: [],
        realname: "",
        profileimage: null);
    item = Question.fromJson(json);
    return QuestionModel2(item);
  }
}
