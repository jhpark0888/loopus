import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getlooplist(var userid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("http://3.35.253.151:8000/loop_api/get_list/$userid");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    return response;
  } else {
    return Future.error(response.statusCode);
  }
}
