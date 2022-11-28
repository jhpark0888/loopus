import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
      {required this.postid, required this.post, this.autoFocus = false});
  RxBool isPostUpdateLoading = false.obs;
  RxBool isCommentLoading = false.obs;
  Rx<ScreenState> postscreenstate = ScreenState.loading.obs;

  ScrollController scrollController = ScrollController();

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  RxInt selectedCommentId = 0.obs;
  Rx<User> tagUser = User.defaultuser().obs;

  int postid;

  Rx<Post> post;

  GlobalKey commentListKey = GlobalKey();
  bool autoFocus;
  ReceivePort _port = ReceivePort();

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
    await postingLoad();
    if (post.value.files.isNotEmpty) {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
      });

      FlutterDownloader.registerCallback(downloadCallback);
    }
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
    // if (autoFocus) {
    //   Scrollable.ensureVisible(commentListKey.currentContext!,
    //       curve: Curves.ease, duration: const Duration(milliseconds: 500));
    // }

    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future postingLoad() async {
    await getposting(postid).then((value) async {
      if (value.isError == false) {
        post.value.copywith(value.data);

        postscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: postscreenstate);
      }
    });
  }

  void tagdelete() {
    tagUser(User.defaultuser());
    selectedCommentId(0);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
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
