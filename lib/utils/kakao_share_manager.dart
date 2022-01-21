import 'package:kakao_flutter_sdk/link.dart';

class KakaoShareManager {
  static final KakaoShareManager _manager = KakaoShareManager._internal();

  factory KakaoShareManager() {
    return _manager;
  }

  KakaoShareManager._internal() {
    // 초기화 코드
  }

  void initializeKakaoSDK() {
    String kakaoAppKey = "3e0e4823d8dd690cfb48b8bcd5ad7e6c";
    KakaoContext.clientId = kakaoAppKey;
  }

  Future<bool> isKakaotalkInstalled() async {
    bool installed = await isKakaoTalkInstalled();
    return installed;
  }

  void shareMyCode() async {
    try {
      var template = _getTemplate();
      var uri = await LinkClient.instance.defaultWithTalk(template);
      await LinkClient.instance.launchKakaoTalk(uri);
    } catch (error) {
      print(error.toString());
    }
  }

  DefaultTemplate _getTemplate() {
    String title = "박도영님이 본인의 포트폴리오를 공유했어요";
    Uri imageLink = Uri.parse(
        "https://loopus.s3.ap-northeast-2.amazonaws.com/image_cropper_3F4D11D8-D095-4E44-82A7-D49874670290-1458-000000949B8EBA9E.jpg");
    Link link = Link(
        webUrl: Uri.parse("https://developers.kakao.com"),
        mobileWebUrl: Uri.parse("https://developers.kakao.com"));

    Content content = Content(
      title,
      imageLink,
      link,
    );

    FeedTemplate template = FeedTemplate(content,
        social: Social(likeCount: 286, subscriberCount: 1200),
        buttons: [
          Button(
            "웹으로 보기",
            Link(
              mobileWebUrl: Uri.parse("https://developers.kakao.com"),
            ),
          ),
          Button("앱으로 보기",
              Link(mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
        ]);

    return template;
  }
}
