abstract class Issue {
  abstract String url;
  abstract String title;
  abstract String image;
}

class NewsIssue extends Issue {
  @override
  String url;
  @override
  String title;
  @override
  String image;
  String corp;

  NewsIssue({
    required this.url,
    required this.corp,
    this.title = "",
    this.image = "",
  });

  // factory NewsIssue.fromJson(String json) => NewsIssue(
  //       url: json,
  //       corp: "루프일보",
  //     );

  factory NewsIssue.fromJson(Map<String, dynamic> json) => NewsIssue(
        url: json["urls"],
        corp: json["corp"] ?? "루프일보",
      );
}

class BrunchIssue extends Issue {
  @override
  String url;
  @override
  String title;
  @override
  String image;
  String writer;
  String profileImage;

  BrunchIssue({
    required this.url,
    required this.writer,
    required this.profileImage,
    this.image = "",
    this.title = "",
  });

  factory BrunchIssue.fromJson(Map<String, dynamic> json) => BrunchIssue(
        url: json["urls"],
        writer: json["writer"],
        profileImage: json["profile_url"],
      );
}

class YoutubeIssue extends Issue {
  @override
  String url;
  @override
  String title;
  @override
  String image;
  String chImage;
  String chName;

  YoutubeIssue({
    required this.url,
    this.title = "",
    this.image = "",
    this.chImage = "",
    this.chName = "",
  });

  factory YoutubeIssue.fromJson(String url) => YoutubeIssue(
        url: url,
      );
}
