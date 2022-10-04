import 'package:get/get.dart';

enum SNSType { instagram, github, notion, naver, youtube }

extension SNSEngtoKor on SNSType {
  String get snsEngtoKor {
    switch (this) {
      case SNSType.instagram:
        return "인스타그램";
      case SNSType.github:
        return "깃허브";
      case SNSType.notion:
        return "노션";
      case SNSType.naver:
        return "네이버";
      case SNSType.youtube:
        return "유튜브";
    }
  }
}

extension SNSInputType on SNSType {
  String get snsInputType {
    switch (this) {
      case SNSType.instagram:
      case SNSType.github:
      case SNSType.naver:
        return "아이디";
      case SNSType.notion:
      case SNSType.youtube:
        return "URL";
    }
  }
}

extension SNSurl on SNSType {
  String get snsUrl {
    switch (this) {
      case SNSType.instagram:
        return "https://www.instagram.com/";
      case SNSType.github:
        return "https://github.com/";
      case SNSType.naver:
        return "https://blog.naver.com/";
      case SNSType.notion:
      case SNSType.youtube:
        return "";
    }
  }
}

class SNS {
  SNS({required this.snsType, required this.url});

  SNSType snsType;
  String url;

  factory SNS.fromJson(Map<String, dynamic> json) =>
      SNS(snsType: SNSType.values[json["type"]], url: json["url"]);
}
