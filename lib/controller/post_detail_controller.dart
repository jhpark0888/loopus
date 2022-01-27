import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/post_model.dart';
import 'package:loopus/widget/search_posting_widget.dart';

class PostingDetailController extends GetxController {
  PostingDetailController(this.postid);
  RxBool isPostingContentLoading = true.obs;
  RxBool isPostDeleteLoading = false.obs;

  int postid;

  Rx<Post> post = Post(
          id: 0,
          userid: 0,
          thumbnail: '',
          title: '',
          date: DateTime.now(),
          project: null,
          contents: [],
          likeCount: 0.obs,
          isLiked: 0.obs,
          realname: '',
          department: '',
          profileimage: null,
          isMarked: 0.obs,
          isuser: 0)
      .obs;
  RxList<SearchPostingWidget> recommendposts = <SearchPostingWidget>[].obs;

  // Future<void> loadPostingContent() async {
  //   http.Response? response = await getposting(item!.id);
  //   var responseBody = json.decode(utf8.decode(response!.bodyBytes));
  //   Post post = Post.fromJson(responseBody['posting_info']);
  //   item = post;
  // }

  @override
  void onInit() {
    isPostingContentLoading(true);
    getposting(postid).then((value) {
      post(Post.fromJson(value['posting_info']));
      recommendposts(List.from(value['recommend_post'])
          .map((post) => Post.fromJson(post))
          .toList()
          .map((posting) => SearchPostingWidget(post: posting))
          .toList());
      isPostingContentLoading(false);
    });
    super.onInit();
  }
}
