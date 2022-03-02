class HTTPResponse {
  HTTPResponse({required this.isError, this.errorData, this.data});

  bool isError = false;
  Map? errorData = {"message": String, "statusCode": int};
  dynamic data;
}
