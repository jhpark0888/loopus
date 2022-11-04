import 'dart:async';
import 'dart:io';

import 'package:loopus/model/message_model.dart';

class HTTPResponse {
  HTTPResponse({required this.isError, this.errorData, this.data});

  bool isError = false;
  Map? errorData = {"message": String, "statusCode": int};
  dynamic data;
  static int timeout = 10000;

  factory HTTPResponse.success(data) =>
      HTTPResponse(isError: false, data: data);

  factory HTTPResponse.apiError(message, statusCode) => HTTPResponse(
      isError: true, errorData: {"message": message, "statusCode": statusCode});

  factory HTTPResponse.networkError() => HTTPResponse(
      isError: true, errorData: {"message": '네트워크 오류입니다', "statusCode": 59});

  factory HTTPResponse.serverError() => HTTPResponse(
      isError: true, errorData: {"message": '서버 오류입니다', "statusCode": 500});

  factory HTTPResponse.unexpectedError(e) =>
      HTTPResponse(isError: true, errorData: {"message": e, "statusCode": 600});

  static Future<HTTPResponse> httpErrorHandling(
      Future<HTTPResponse> Function() httpFt) async {
    try {
      return await httpFt();
    } on TimeoutException {
      return HTTPResponse.serverError();
    } on SocketException {
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
    }
  }
}
