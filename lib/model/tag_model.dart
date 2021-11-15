import 'dart:convert';

class Tag {
  Tag({
    required this.id,
    required this.tag,
    // required this.count
  });

  int id;
  String tag;
  // int count;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"], tag: json["tag"],
        // count: json["count"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        // "count": count,
      };
}
