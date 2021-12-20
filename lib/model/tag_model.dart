import 'dart:convert';

class SearchTag {
  SearchTag({required this.id, required this.tag, this.count});

  int id;
  String tag;
  int? count;

  factory SearchTag.fromJson(Map<String, dynamic> json) =>
      SearchTag(id: json["id"], tag: json["tag"], count: json["count"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "count": count,
      };
}

class Tag {
  Tag({
    required this.tagId,
    required this.tag,
  });

  int tagId;
  String tag;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tagId: json["tag_id"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "tag": tag,
      };
}
