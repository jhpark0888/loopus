import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/post_model.dart';

class PostingDetailController extends GetxController {
  RxBool isPostingContentLoading = true.obs;
  RxBool isPostDeleteLoading = false.obs;
  Post? item;

  // Future<void> loadPostingContent() async {
  //   http.Response? response = await getposting(item!.id);
  //   var responseBody = json.decode(utf8.decode(response!.bodyBytes));
  //   Post post = Post.fromJson(responseBody['posting_info']);
  //   item = post;
  // }

  @override
  void onInit() {
    // loadPostingContent().then((value) => isPostingContentLoading.value = false);
    super.onInit();
  }
}
