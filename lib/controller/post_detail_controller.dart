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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostingDetailController extends GetxController {
  PostingDetailController({
    required this.postid,
    required this.post,
  });
  RxBool isPostUpdateLoading = false.obs;
  // RxBool isNetworkConnect = false.obs;
  Rx<ScreenState> postscreenstate = ScreenState.loading.obs;

  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  // RxList<PostComment> postCommentList = <PostComment>[].obs;

  RxInt selectedCommentId = 0.obs;
  Rx<User> tagUser = User.defaultuser().obs;

  int postid;

  Rx<Post?> post;

  late int lastIsLiked;
  late int lastIsMarked;

  @override
  void onInit() async {
    if (post.value == null) {
      post = Post(
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
    }
    await getposting(postid).then((value) async {
      if (value.isError == false) {
        if (post.value != null) {
          post.value!.copywith(value.data);
        }

        lastIsLiked = post.value!.isLiked.value;
        lastIsMarked = post.value!.isMarked.value;
        if (post.value!.comments.isEmpty) {
          refreshController.loadNoData();
        }
        postscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: postscreenstate);
      }
    });
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

  Future commentListLoad() async {
    await commentListGet(postid, "comment", post.value!.comments.last.id)
        .then((value) {
      if (value.isError == false) {
        List<Comment> commentList = List.from(value.data)
            .map((comment) => Comment.fromJson(comment))
            .toList();

        post.value!.comments.addAll(commentList);

        if (commentList.length < 10) {
          refreshController.loadNoData();
          return;
        }
        refreshController.loadComplete();
      } else {
        errorSituation(value);
        refreshController.loadComplete();
      }
    });
  }

  // void commentToList() {
  //   List<PostComment> teptlist = [];
  //   for (var comment in post.value!.comments) {
  //     teptlist.add(comment);
  //     for (var reply in comment.replyList.reversed) {
  //       teptlist.add(reply);
  //     }
  //   }
  //   postCommentList(teptlist);
  // }
}
