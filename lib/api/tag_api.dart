import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

void gettagsearch() async {
  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/login/');
  TagController tagController = Get.find();
  Uri uri = Uri.parse(
      'http://3.35.253.151:8000/tag_api/search?query=${tagController.tagsearch.text}');

  http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  print(response.statusCode);
  var responsebody = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    List responselist = responsebody["results"];
    List<SearchTag> tagmaplist =
        responselist.map((map) => SearchTag.fromJson(map)).toList();

    print(responselist);
    if (tagmaplist
        .where((element) => element.tag == tagController.tagsearch.text)
        .isNotEmpty) {
      tagController.searchtaglist.clear();

      tagController.searchtaglist(tagmaplist.map((element) {
        return SearchTagWidget(
          id: element.id,
          tag: element.tag,
          count: element.count,
          isSearch: 0,
        );
      }).toList());

      for (var selectedtag in tagController.selectedtaglist) {
        tagController.searchtaglist
            .removeWhere((element) => element.id == selectedtag.id);
      }
    } else {
      tagController.searchtaglist.clear();

      tagController.searchtaglist(tagmaplist.map((element) {
        return SearchTagWidget(
          id: element.id,
          tag: element.tag,
          count: element.count,
          isSearch: 0,
        );
      }).toList());
      if (tagController.tagsearch.text != '') {
        tagController.searchtaglist.insert(
            0,
            SearchTagWidget(
              id: 0,
              tag: "처음으로 '${tagController.tagsearch.text}' 태그 사용하기",
              isSearch: 0,
            ));
      }

      tagController.selectedtaglist.forEach((selectedtag) {
        tagController.searchtaglist
            .removeWhere((element) => element.id == selectedtag.id);
      });
    }
  } else if (response.statusCode == 401) {
    // Get.defaultDialog(
    //   title: '로그인 오류',
    //   content: Text('아이디 또는 비밀번호가 틀렸습니다'),
    // );
  } else {
    print(response.statusCode);
  }
}

Future<SearchTag?> postmaketag() async {
  TagController tagController = Get.find();

  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/login/');
  Uri uri = Uri.parse('http://3.35.253.151:8000/tag_api/create/');

  var tag = {"tag": tagController.tagsearch.text};

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(tag),
  );

  print(response.statusCode);

  if (response.statusCode == 201) {
    tagController.tagsearch.clear();
    Map responsebody = json.decode(utf8.decode(response.bodyBytes));
    print(responsebody);
    SearchTag searchtag = SearchTag.fromJson(responsebody["tag"]);
    return searchtag;
  } else if (response.statusCode == 401) {
    // Get.defaultDialog(
    //   title: '로그인 오류',
    //   content: Text('아이디 또는 비밀번호가 틀렸습니다'),
    // );
  } else {
    print(response.statusCode);
  }
}
