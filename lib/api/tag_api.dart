import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

import '../constant.dart';

void gettagsearch(Tagtype tagtype) async {
  TagController tagController = Get.find(tag: tagtype.toString());
  tagController.isTagSearchLoading(true);
  Uri uri =
      Uri.parse('$serverUri/tag_api/tag?query=${tagController.tagsearch.text}');
  print(uri);
  http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  var responsebody = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    List responselist = responsebody["results"];
    List<SearchTag> tagmaplist =
        responselist.map((map) => SearchTag.fromJson(map)).toList();

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
          tagtype: tagtype,
        );
      }).toList());

      for (var selectedtag in tagController.selectedtaglist) {
        tagController.searchtaglist
            .removeWhere((element) => element.tag == selectedtag.text);
      }
    } else {
      tagController.searchtaglist.clear();

      tagController.searchtaglist(tagmaplist.map((element) {
        return SearchTagWidget(
          id: element.id,
          tag: element.tag,
          count: element.count,
          isSearch: 0,
          tagtype: tagtype,
        );
      }).toList());
      if (tagController.tagsearch.text != '' &&
          tagController.selectedtaglist
              .where((tag) => tag.text == tagController.tagsearch.text)
              .isEmpty) {
        tagController.searchtaglist.insert(
            0,
            SearchTagWidget(
              id: 0,
              tag: "처음으로 '${tagController.tagsearch.text}' 태그 사용하기",
              isSearch: 0,
              tagtype: tagtype,
            ));
      }

      tagController.selectedtaglist.forEach((selectedtag) {
        tagController.searchtaglist
            .removeWhere((element) => element.tag == selectedtag.text);
      });
    }
    tagController.isTagSearchLoading(false);
  } else if (response.statusCode == 401) {
  } else {
    print('tag status code :${response.statusCode}');
  }
}

// Future<SearchTag?> postmaketag(Tagtype tagtype) async {
//   TagController tagController = Get.find(tag: tagtype.toString());

//   Uri uri = Uri.parse('$serverUri/tag_api/tag');

//   var tag = {"tag": tagController.tagsearch.text};

//   http.Response response = await http.post(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(tag),
//   );

//   print('태그 생성: ${response.statusCode}');
//   if (response.statusCode == 201) {
//     tagController.tagsearch.clear();
//     Map responsebody = json.decode(utf8.decode(response.bodyBytes));
//     SearchTag searchtag = SearchTag.fromJson(responsebody["tag"]);
//     return searchtag;
//   } else if (response.statusCode == 401) {
//   } else {}
// }
