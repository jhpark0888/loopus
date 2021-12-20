import 'package:loopus/model/tag_model.dart';

class Project {
  Project({
    required this.id,
    required this.projectName,
    required this.introduction,
    required this.startDate,
    this.endDate,
    required this.projectTag,
  });

  int id;
  String projectName;
  String introduction;
  DateTime startDate;
  DateTime? endDate;
  List<Tag> projectTag;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        projectName: json["project_name"],
        introduction: json["introduction"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: json["end_date"],
        projectTag:
            List<Tag>.from(json["project_tag"].map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "introduction": introduction,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": endDate,
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
      };
}
