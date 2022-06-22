import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/user_model.dart';

class PostingDetailController extends GetxController {
  PostingDetailController({
    required this.postid,
    required this.post,
  });
  // RxBool isPostingContentLoading = true.obs;
  RxBool isPostDeleteLoading = false.obs;
  RxBool isPostUpdateLoading = false.obs;
  // RxBool isNetworkConnect = false.obs;
  Rx<ScreenState> postscreenstate = ScreenState.loading.obs;

  ScrollController scrollController = ScrollController();

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  RxList<PostComment> postCommentList = <PostComment>[].obs;

  RxInt selectedCommentId = 0.obs;
  Rx<User> tagUser = User.defaultuser().obs;

  // KeyboardVisibilityController keyboardController =
  //     KeyboardVisibilityController();
  // RxBool onKeyborad = false.obs;

  int postid;

  Rx<Post?> post = Post(
          id: 0,
          userid: 0,
          content: '',
          images: [],
          scraps: [],
          comments: <Comment>[].obs,
          tags: [],
          date: DateTime.now(),
          project: null,
          likeCount: 0.obs,
          isLiked: 0.obs,
          isMarked: 0.obs,
          isuser: 0,
          user: User.defaultuser())
      .obs;

  @override
  void onInit() async {
    await getposting(postid).then((value) async {
      if (value.isError == false) {
        Post temppost = Post.fromJson(value.data);
        post(temppost);
        commentToList();
        postscreenstate(ScreenState.success);
      } else {}
    });

    // keyboardController.onChange.listen((isVisible) {
    //   // onKeyborad(isVisible);
    //   if (isVisible && selectedCommentId.value != 0) {
    //     print('ddd');
    //     Scrollable.ensureVisible(Get.context!,
    //         alignment: 1,
    //         duration: const Duration(milliseconds: 300),
    //         curve: Curves.ease);
    //   }
    // });

    commentController.addListener(() {
      if (tagUser.value.userid != 0 && commentController.text == '') {
        tagdelete();
      }
    });

    super.onInit();
  }

  void tagdelete() {
    tagUser(User.defaultuser());
    selectedCommentId(0);
  }

  void commentToList() {
    List<PostComment> teptlist = [];
    for (var comment in post.value!.comments) {
      teptlist.add(comment);
      for (var reply in comment.replyList.reversed) {
        teptlist.add(reply);
      }
    }
    postCommentList(teptlist);
  }
}
