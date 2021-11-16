class QuestionItem {
  QuestionItem({
    required this.myQuestions,
    required this.questions,
  });

  List<Question> myQuestions;
  List<Question> questions;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        myQuestions: List<Question>.from(
            json["my_questions"].map((x) => Question.fromJson(x))),
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "my_questions": List<dynamic>.from(myQuestions.map((x) => x.toJson())),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  Question({
    required this.id,
    required this.user,
    required this.questioner,
    required this.content,
    required this.answers,
    required this.adopt,
    required this.date,
  });

  int id;
  int user;
  String questioner;
  String content;
  List<Answer> answers;
  bool adopt;
  DateTime date;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        user: json["user"],
        questioner: json["questioner"],
        content: json["content"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        adopt: json["adopt"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "questioner": questioner,
        "content": content,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "adopt": adopt,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class Answer {
  Answer({
    required this.id,
    required this.user,
    required this.answerer,
    required this.content,
    required this.question,
    required this.adopt,
    required this.date,
  });

  int id;
  int user;
  String answerer;
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "answerer": answerer,
        "content": content,
        "question": question,
        "adopt": adopt,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}
