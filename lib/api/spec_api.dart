import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/environment_model.dart';

Future<HTTPResponse> getSchoolSpec() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // String? strSchoolId =
    //     await const FlutterSecureStorage().read(key: "strSchoolId");
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse("${Environment.apiUrl}/project_api/in_school");

      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("교내 스펙 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

//cat: 0, 1 0 --> 공모전 1--> 대외활동
//group:

Map<int, List<String>> schoolOutCatMap = {
  0: [
    "기획/아이디어",
    "정책/제안/공로",
    "광고/홍보/마케팅",
    "논문/논술/학술/리포트",
    "네이밍/슬로건/카피라이팅",
    "영상/UCC/영화",
    "사진/이미지/SNS콘텐츠",
    "수기/후기/감상문/글짓기",
    "문학/시나리오/스토리",
    "캐릭터/웹툰/만화",
    "디자인/패션/제품",
    "아트/미술/공예",
    "음악/무용/공연/연기",
    "IT/웹/모바일/게임",
    "과학/공학/기술",
    "건축/건설/인테리어",
    "취업/창업",
    "모의영연/발표/토론",
    "이벤트/기타"
  ],
  1: [
    "마케터",
    "서포터즈",
    "리포터/객원기자",
    "모니터",
    "체험단",
    "재능기부",
    "봉사활동",
    "캠프",
    "취업/창업",
    "교육/강연/세미나",
    "전시/페스티벌",
    "해외탐방",
    "기타"
  ],
  2: [],
  3: [],
};

Future<HTTPResponse> getSchoolOutPopNotice(int catId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // String? strSchoolId =
    //     await const FlutterSecureStorage().read(key: "strSchoolId");
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "${Environment.apiUrl}/project_api/out_school?type=pop&cat=$catId");

      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("교외 인기 공지 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

Future<HTTPResponse> getSchoolOutGroupNoti(int catId, String group) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // String? strSchoolId =
    //     await const FlutterSecureStorage().read(key: "strSchoolId");
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "${Environment.apiUrl}/project_api/out_school?type=main&cat=$catId&group=$group");

      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("교외 카테고리별 공지 리스트 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

//id: project id, activity id, activity id
//type: class, school, activity
//last: 마지막 post id
Future<HTTPResponse> getDetailSpec(int id, String type) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // String? strSchoolId =
    //     await const FlutterSecureStorage().read(key: "strSchoolId");
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "${Environment.apiUrl}/project_api/detail?id=$id&type=$type");

      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("스펙 디테일 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}

//id: project id
//last: 마지막 post id
Future<HTTPResponse> getDetailPosts(int id, int last) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    // String? strSchoolId =
    //     await const FlutterSecureStorage().read(key: "strSchoolId");
    String? token = await const FlutterSecureStorage().read(key: "token");
    return HTTPResponse.httpErrorHandling(() async {
      final uri = Uri.parse(
          "${Environment.apiUrl}/project_api/detail_post?id=$id&last=$last");

      http.Response response = await http.get(uri, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("스펙 디테일 포스트 로드: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        return HTTPResponse.apiError('', response.statusCode);
      }
      return HTTPResponse.apiError('', response.statusCode);
    });
  }
}
