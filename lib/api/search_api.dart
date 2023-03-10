import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/environment_model.dart';

Future<HTTPResponse> tagsearch(String searchWord) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');

    Uri uri = Uri.parse(
        '${Environment.apiUrl}/tag_api/search_tag?query=${searchWord}');
    return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": "Token $token"
        },
      ).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("ํ๊ทธ ๊ฒ์: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responsebody = json.decode(utf8.decode(response.bodyBytes));
        // List responselist = responsebody["results"];
        // List<SearchTag> tagmaplist =
        //     responselist.map((map) => SearchTag.fromJson(map)).toList();

        // print(responselist);
        // searchController.searchtaglist.clear();

        return HTTPResponse.success(responsebody);
      } else if (response.statusCode == 401) {
        return HTTPResponse.apiError('', response.statusCode);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> search(
    SearchType searchType, String searchtext, int pagenumber) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');
    // ์์?

    String searchword = searchtext.trim().replaceAll(RegExp("\\s+"), " ");
    print("๊ฒ์์ด: $searchword");

    final url = Uri.parse(
        "${Environment.apiUrl}/search_api/search/${searchType.name}?query=$searchword&page=$pagenumber");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.get(url, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("${searchType.name} ๊ฒ์ : ${response.statusCode}");

      if (response.statusCode == 200) {
        List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> companySearch(String searchtext, int pagenumber) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');
    // ์์?

    String searchword = searchtext.trim().replaceAll(RegExp("\\s+"), " ");
    print("๊ฒ์์ด: $searchword");

    final url = Uri.parse(
        "${Environment.apiUrl}/search_api/search_company?query=$searchword&page=$pagenumber");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.get(url, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("๊ธฐ์ ๊ฒ์ : ${response.statusCode}");

      if (response.statusCode == 200) {
        List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> getResentSearches() async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');

    final url = Uri.parse("${Environment.apiUrl}/search_api/search_log");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.get(url, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("์ต๊ทผ ๊ฒ์ ๋ก๋ : ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  }
}

Future<HTTPResponse> addRecentSearch(int type, String query) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');

    final url = Uri.parse(
        "${Environment.apiUrl}/search_api/search_log?type=$type&query=$query");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.post(url, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("์ต๊ทผ ๊ฒ์ ์ถ๊ฐ : ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseBody = response.body != ""
            ? jsonDecode(utf8.decode(response.bodyBytes))
            : null;
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  }
}

// ํ๊ฐ ์ญ์?: one, ๋ชจ๋ ์ญ์?: all
Future<HTTPResponse> deleteResentSearch(String type, int id) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    return HTTPResponse.networkError();
  } else {
    String? token = await FlutterSecureStorage().read(key: 'token');

    final url = Uri.parse(
        "${Environment.apiUrl}/search_api/search_log?type=$type&id=$id");
    return HTTPResponse.httpErrorHandling(() async {
      final response = await http.delete(url, headers: {
        "Authorization": "Token $token"
      }).timeout(Duration(milliseconds: HTTPResponse.timeout));

      print("์ต๊ทผ ๊ฒ์ ์ญ์? : ${response.statusCode}");

      if (response.statusCode == 200) {
        return HTTPResponse.success("SUCCESS");
      } else {
        return HTTPResponse.apiError("FAIL", response.statusCode);
      }
    });
  }
}



// Future<HTTPResponse> searchPopPost(int page) async {
//   ConnectivityResult result = await initConnectivity();
//   if (result == ConnectivityResult.none) {
//     showdisconnectdialog();
//     return HTTPResponse.networkError();
//   } else {
//     SearchController searchController = Get.find();
//     String? token = await FlutterSecureStorage().read(key: 'token');
//     // ์์?

//     final url = Uri.parse("${Environment.apiUrl}/search_api/recommend?page=$page");

//     try {
//       final response =
//           await http.get(url, headers: {"Authorization": "Token $token"});

//       print("๊ฒ์ : ${response.statusCode}");

//       if (response.statusCode == 200) {
//         List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
//         print(responseBody);
//         return HTTPResponse.success(responseBody);
//       } else {
//         return HTTPResponse.apiError('', response.statusCode);
//       }
//     } on SocketException {
//       // ErrorController.to.isServerClosed(true);
//       return HTTPResponse.serverError();
//     } catch (e) {
//       print(e);
//       return HTTPResponse.unexpectedError(e);
//     }
//   }
// }
