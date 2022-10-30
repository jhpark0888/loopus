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
  PostingDetailController(
      {required this.postid, this.post, this.autoFocus = false});
  RxBool isPostUpdateLoading = false.obs;
  RxBool isCommentLoading = false.obs;
  Rx<ScreenState> postscreenstate = ScreenState.loading.obs;

  ScrollController scrollController = ScrollController();

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  TextEditingController reportController = TextEditingController();
  RxInt selectedCommentId = 0.obs;
  Rx<Person> tagUser = Person.defaultuser().obs;

  int postid;

  Rx<Post>? post;

  late int lastIsLiked;
  late int lastIsMarked;

  GlobalKey commentListKey = GlobalKey();
  bool autoFocus;

  @override
  void onInit() async {
    // if (post.value == null) {
    //   post = Post(
    //           id: 0,
    //           userid: 0,
    //           content: ''.obs,
    //           images: [],
    //           links: [],
    //           comments: <Comment>[].obs,
    //           tags: <Tag>[].obs,
    //           date: DateTime.now(),
    //           project: null,
    //           likeCount: 0.obs,
    //           isLiked: 0.obs,
    //           isMarked: 0.obs,
    //           isuser: 0,
    //           user: Person.defaultuser())
    //       .obs;
    // }
    await getposting(postid).then((value) async {
      if (value.isError == false) {
        if (post != null) {
          post!.value.copywith(value.data);
        } else {
          post = Post.fromJson(value.data).obs;
        }

        lastIsLiked = post!.value.isLiked.value;
        lastIsMarked = post!.value.isMarked.value;
        // if (post!.value.comments.isEmpty) {
        //   refreshController.loadNoData();
        // }
        postscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: postscreenstate);
      }
    });
    commentController.addListener(() {
      if (tagUser.value.userId != 0 && commentController.text == '') {
        tagdelete();
      }
    });

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    if (autoFocus) {
      Scrollable.ensureVisible(commentListKey.currentContext!,
          curve: Curves.ease, duration: const Duration(milliseconds: 500));
    }

    super.onReady();
  }

  void tagdelete() {
    tagUser(Person.defaultuser());
    selectedCommentId(0);
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
