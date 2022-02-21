import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/post_content_widget.dart';
import 'package:loopus/widget/search_posting_widget.dart';

class PostingDetailController extends GetxController {
  PostingDetailController(this.postid);
  // RxBool isPostingContentLoading = true.obs;
  RxBool isPostDeleteLoading = false.obs;
  RxBool isPostUpdateLoading = false.obs;
  // RxBool isNetworkConnect = false.obs;
  Rx<ScreenState> postscreenstate = ScreenState.loading.obs;

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
          isMarked: 0.obs,
          isuser: 0,
          user: User(
              userid: 0,
              realName: "",
              type: 0,
              department: "",
              loopcount: 0.obs,
              totalposting: 0,
              isuser: 0,
              profileTag: [],
              looped: FollowState.normal.obs))
      .obs;
  RxList<PostContentWidget> postcontentlist = <PostContentWidget>[].obs;
  List<SearchPostingWidget> recommendposts = <SearchPostingWidget>[];

  // Future<void> loadPostingContent() async {
  //   http.Response? response = await getposting(item!.id);
  //   var responseBody = json.decode(utf8.decode(response!.bodyBytes));
  //   Post post = Post.fromJson(responseBody['posting_info']);
  //   item = post;
  // }

  @override
  void onInit() {
    getposting(postid);
    super.onInit();
  }
}
