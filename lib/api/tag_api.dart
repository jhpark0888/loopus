import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/error_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

import '../constant.dart';
Future<HTTPResponse> getTagPosting(int tagId, int page, String type) async {
  ConnectivityResult result = await initConnectivity();

  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    // print(userid);
    //type: new, pop
    final specificPostingLoadUri = Uri.parse(
        "$serverUri/tag_api/tagged_post?id=$tagId&page=$page&type=$type");
return HTTPResponse.httpErrorHandling(() async {
      http.Response response = await http.get(specificPostingLoadUri,
          headers: {"Authorization": "Token $token"}).timeout(Duration(milliseconds: HTTPResponse.timeout));;

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        return HTTPResponse.success(responseBody);
      } else if (response.statusCode == 404) {
        Get.back();
        showCustomDialog('이미 삭제된 포스팅입니다', 1400);
        return HTTPResponse.apiError('이미 삭제된 포스팅입니다', response.statusCode);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    });
  }
}

