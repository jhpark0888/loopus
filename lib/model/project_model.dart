import 'package:loopus/model/tag_model.dart';

class Project {
  Project({
    required this.id,
    required this.projectName,
    required this.introduction,
    required this.startDate,
    this.endDate,
    required this.projectTag,
    required this.totallike,
  });

  int id;
  String projectName;
  String introduction;
  String startDate;
  String? endDate;
  List<Tag> projectTag;
  int totallike;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        projectName: json["project_name"],
        introduction: json["introduction"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        projectTag:
            List<Tag>.from(json["project_tag"].map((x) => Tag.fromJson(x))),
        totallike: json["Total project Like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "introduction": introduction,
        "start_date": startDate,
        "end_date": endDate,
        "project_tag": List<dynamic>.from(projectTag.map((x) => x.toJson())),
        "Total project Like": totallike,
      };
}
