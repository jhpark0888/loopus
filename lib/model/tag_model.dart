import 'dart:convert';

class Tag {
  Tag({required this.tagId, required this.tag, required this.count});

  int tagId;
  String tag;
  int count;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tagId: json["tag_id"] ?? json["id"],
        tag: json["tag"],
        count: json["tag_count"] ?? json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {"id": tagId, "tag": tag, "tag_count": count};
}
