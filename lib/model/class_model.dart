import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';

class SchoolClass {
  SchoolClass({
    required this.id,
    required this.classType,
    required this.className,
    required this.schoolId,
    required this.career,
    required this.member,
    required this.memberCount,
    // required this.posts,
  });

  int id;
  String classType;
  String className;
  int schoolId;
  Project career;
  RxList<Person> member;
  int memberCount;
  // RxList<Post> posts;

  String get dept => classType.split(" ").first;
  String get subject => classType.split(" ").last;

  factory SchoolClass.defaultSc({
    int? id,
    String? classType,
    String? className,
    int? schoolId,
    Project? career,
    RxList<Person>? member,
    int? memberCount,
    // RxList<Post>? posts,
  }) =>
      SchoolClass(
        id: id ?? 0,
        classType: classType ?? "",
        className: className ?? "",
        schoolId: schoolId ?? 0,
        career: career ?? Project.defaultProject(),
        member: member ?? <Person>[].obs,
        memberCount: memberCount ?? 0,
        // posts: posts ?? <Post>[].obs,
      );

  factory SchoolClass.fromJson(Map<String, dynamic> json) => SchoolClass(
        id: json['class_inform']['id'] ?? 0,
        classType: json['class_inform']['class_type'] ?? "",
        className: json['class_inform']['class_name'] ?? "",
        schoolId: json['class_inform']['school'] ?? 0,
        career: json["project"] != null
            ? Project.fromJson(json["project"])
            : Project.defaultProject(),
        // posts: json["post"] != null
        //     ? List.from(json["post"])
        //         .map((post) => Post.fromJson(post))
        //         .toList()
        //         .obs
        //     : <Post>[].obs,
        member: json['member'] != null
            ? List.from(json["member"]["profile"])
                .map((profile) => Person.fromJson(profile))
                .toList()
                .obs
            : <Person>[].obs,
        memberCount: json["member"]["count"] ?? 0,
      );
}
