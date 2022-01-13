import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/user_model.dart';

Future<List<User>> getlooplist(int userid) async {
  String? token = await const FlutterSecureStorage().read(key: "token");

  final uri = Uri.parse("http://3.35.253.151:8000/loop_api/get_list/$userid");

  http.Response response =
      await http.get(uri, headers: {"Authorization": "Token $token"});

  if (response.statusCode == 200) {
    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    List<User> looplist = List.from(responseBody["friend"])
        .map((friend) => User.fromJson(friend))
        .toList();
    return looplist;
  } else {
    return Future.error(response.statusCode);
  }
}
