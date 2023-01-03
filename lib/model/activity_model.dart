import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';

//활동 모델(교내, 교외)
class Activity {
  int id;
  String title;
  String image;
  String content;
  int viewCount;
  Project? career;
  RxList<Person> member;
  int memberCount;

  Activity({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.viewCount,
    this.career,
    // required this.posts,
    required this.member,
    required this.memberCount,
  });
}

//교내 활동 모델
class SchoolActi extends Activity {
  // @override
  // RxList<Post> posts;

  String category;
  String url;
  DateTime uploadDate;
  int schoolId;

  SchoolActi({
    required id,
    required title,
    required image,
    required content,
    required this.url,
    required viewCount,
    required this.category,
    required this.uploadDate,
    required this.schoolId,
    career,
    // required this.posts,
    required member,
    required memberCount,
  }) : super(
          id: id,
          title: title,
          image: image,
          content: content,
          viewCount: viewCount,
          career: career,
          member: member,
          memberCount: memberCount,
        );

  factory SchoolActi.fromJson(Map<String, dynamic> json) => SchoolActi(
        id: json['id'] ?? 0,
        category: json["cat"] ?? 0,
        title: json['title'] ?? 0,
        image: json['image'] ?? "",
        url: json["url"] ?? "",
        content: json['content'] ?? "",
        uploadDate: json["upload_date"] != null
            ? DateTime.parse(json["upload_date"])
            : DateTime.now(),
        viewCount: json['view_count'] ?? 0,
        schoolId: json["shcool"] ?? 0,
        career:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
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
        memberCount: json['member'] != null ? json["member"]["count"] : 0,
      );

  factory SchoolActi.defaultScActi({
    int? id,
    String? content,
    String? image,
    String? title,
    String? url,
    int? viewCount,
    String? category,
    DateTime? uploadDate,
    int? schoolId,
    Project? career,
    // RxList<Post>? posts,
    RxList<Person>? member,
    int? memberCount,
  }) =>
      SchoolActi(
        id: id ?? 0,
        content: content ?? "",
        image: image ?? "",
        title: title ?? "",
        url: url ?? "",
        viewCount: viewCount ?? 0,
        category: category ?? "",
        uploadDate: uploadDate ?? DateTime.now(),
        schoolId: schoolId ?? 0,
        career: career,
        // posts: posts ?? <Post>[].obs,
        member: member ?? <Person>[].obs,
        memberCount: memberCount ?? 0,
      );
}

//교외 활동 모델
class OutActi extends Activity {
  String organizer;
  DateTime startDate;
  DateTime endDate;
  int type;
  int group;
  int tagCount;

  OutActi({
    required id,
    required title,
    required image,
    required content,
    required viewCount,
    career,
    // required this.posts,
    required member,
    required memberCount,
    required this.organizer,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.group,
    required this.tagCount,
  }) : super(
          id: id,
          title: title,
          image: image,
          content: content,
          viewCount: viewCount,
          career: career,
          member: member,
          memberCount: memberCount,
        );

  // factory OutActi.defaultScActi({
  //   int? id,
  //   String? content,
  //   String? image,
  //   String? title,
  //   String? url,
  //   int? viewCount,
  //   String? category,
  //   DateTime? uploadDate,
  //   int? schoolId,
  // }) =>
  //     OutActi(
  //       id: id ?? 0,
  //       content: content ?? "",
  //       image: image ?? "",
  //       title: title ?? "",
  //       url: url ?? "",
  //       viewCount: viewCount ?? 0,
  //       category: category ?? "",
  //       uploadDate: uploadDate ?? DateTime.now(),
  //       schoolId: schoolId ?? 0,
  //     );

  factory OutActi.fromJson(Map<String, dynamic> json) => OutActi(
        id: json['id'] ?? 0,
        type: json["type"] ?? 0,
        group: json["group"] != null ? int.parse(json["group"]) : 0,
        content: json['content'] ?? "",
        image: json['image'] ?? "",
        title: json['title'] ?? 0,
        organizer: json['organizer'] ?? "",
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"])
            : DateTime.now(),
        endDate: json["end_date"] != null
            ? DateTime.parse(json["end_date"])
            : DateTime.now(),
        viewCount: json['view_count'] ?? 0,
        tagCount: json['tagged_count'] ?? 0,
        career:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        // posts: json["post"] != null
        // ? List.from(json["post"])
        // .map((post) => Post.fromJson(post))
        // .toList()
        // .obs
        // : <Post>[].obs,
        member: json['member'] != null
            ? List.from(json["member"]["profile"])
                .map((profile) => Person.fromJson(profile))
                .toList()
                .obs
            : <Person>[].obs,
        memberCount: json['member'] != null ? json["member"]["count"] : 0,
      );
}
