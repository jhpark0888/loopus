import 'package:get/get.dart';

class QuestionItem {
  QuestionItem(
      {required this.id,
      required this.user,
      required this.is_user,
      required this.content,
      required this.answers,
      required this.adopt,
      required this.date,
      required this.department,
      required this.questionTag,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  int is_user;
  String? department;
  String content;
  String realname;
  String? profileimage;
  List<Answer> answers;
  bool? adopt;
  DateTime? date;
  List<QuestionTag> questionTag;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        id: json["id"],
        user: json["user_id"],
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
        department: department_map[json["department"]] ?? "",
        is_user: -1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "content": content,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "adopt": adopt,
        "question_tag": List<dynamic>.from(questionTag.map((x) => x.toJson())),
        "real_name": realname,
        "profile_image": profileimage == null ? null : profileimage,
        "department ": department_map[department] ?? "",
        "is_user": is_user,
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
      required this.department,
      required this.isuser,
      required this.realname,
      required this.profileimage});

  int id;
  int user;
  String answerer;
  int? isuser;
  String department;
  String? realname;
  String? profileimage;
  String content;
  int question;
  bool adopt;
  DateTime date;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        user: json["user_id"],
        answerer: json["answerer"],
        content: json["content"],
        question: json["question"],
        adopt: json["adopt"],
        date: DateTime.parse(json["date"]),
        profileimage:
            json["profile_image"] == null ? null : json["profile_image"],
        realname: json["real_name"] == null ? null : json["real_name"],
        isuser: json["is_user"] == null ? null : json["is_user"],
        department: department_map[json["department"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user,
        "answerer": answerer,
        "content": content,
        "question": question,
        "department": department_map[department],
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
        answers: [],
        adopt: null,
        date: null,
        questionTag: [],
        realname: "",
        profileimage: null,
        department: '',
        is_user: -1);
    item = QuestionItem.fromJson(json);
    return QuestionModel2(item);
  }
}

Map department_map = {
  0: '기타',
  1: '국어국문학과',
  2: '영어영문학과',
  3: '독어독문학과',
  4: '불어불문학과',
  5: '일어일문학과',
  6: '중어중국학과',
  7: '수학과',
  8: '물리학과',
  9: '화학과',
  10: '패션산업학과',
  11: '해양학과',
  12: '사회복지학과',
  13: '신문방송학과',
  14: '문헌정보학과',
  15: '창의인재개발학과',
  16: '행정학과',
  17: '정치외교학과',
  18: '경제학과',
  19: '무역학부',
  20: '소비자학과',
  21: '기계공학과',
  22: '전기공학과',
  23: '전자공학과',
  24: '산업경영공학과',
  25: '신소재공학과',
  26: '안전공학과',
  27: '에너지화학공학과',
  28: '메카트로닉스공학과',
  29: '컴퓨터공학부',
  30: '정보통신공학과',
  31: '임베디드시스템공학과',
  32: '경영학부',
  33: '세무회계학과',
  34: '테크노경영학과',
  35: '조형예술학부',
  36: '디자인학부',
  37: '공연예술학과',
  38: '체육학부',
  39: '운동건강학부',
  40: '국어교육과',
  41: '영어교육과',
  42: '일어교육과',
  43: '수학교육과',
  44: '체육교육과',
  45: '유아교육과',
  46: '역사교육과',
  47: '윤리교육과',
  48: '도시행정학과',
  49: '도시공학과',
  50: '건설환경공학부',
  51: '환경공학부',
  52: '건축공학과',
  53: '도시건축학부',
  54: '분자의생명전공',
  55: '생명과학전공',
  56: '생명공학전공',
  57: '나노바이오전공',
  58: '동북아통상전공',
  59: '한국통상전공',
  60: '법학부'
};
