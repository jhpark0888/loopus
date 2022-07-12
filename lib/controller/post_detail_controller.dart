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
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';

class PostingDetailController extends GetxController {
  PostingDetailController({
    required this.postid,
    required this.post,
  });
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
          content: ''.obs,
          images: [],
          links: [],
          comments: <Comment>[].obs,
          tags: <Tag>[].obs,
          date: DateTime.now(),
          project: null,
          likeCount: 0.obs,
          isLiked: 0.obs,
          isMarked: 0.obs,
          isuser: 0,
          user: User.defaultuser())
      .obs;

  late int lastIsLiked;

  @override
  void onInit() async {
    await getposting(postid).then((value) async {
      if (value.isError == false) {
        // Post temppost = Post.fromJson(value.data);
        // print('변화 전 : ${post.hashCode}');
        // print('새로운 포스트 : ${temppost.hashCode}');
        // post.value = Post.fromJson(value.data);
        post.value!.copywith(value.data);
        // print('변화 후 : ${post.hashCode}');
        lastIsLiked = post.value!.isLiked.value;
        commentToList();
        postscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: postscreenstate);
      }
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
