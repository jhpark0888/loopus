import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CareerDetailController extends GetxController {
  CareerDetailController({required this.career});
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  Rx<ScreenState> careerDetailScreenState = ScreenState.normal.obs;
  Project career;
  RxInt page = 1.obs;
  RxList<Post> postList = <Post>[].obs;
  RxBool enablePullUp = true.obs;

  @override
  void onInit() {
    super.onInit();
    getPosting();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        getPosting();
      }
    });
  }

  Future<void> getPosting() async {
    getCareerPosting(career.id, page.value).then((value) {
      if (value.isError == false) {
        List<Post> postlist = value.data;
        if (postlist.isNotEmpty) {
          if (postList.isEmpty) {
            postList(postlist);
          } else {
            postList.addAll(postlist);
          }
          page.value += 1;
          enablePullUp(true);
        } else {
          enablePullUp(false);
        }
        careerDetailScreenState(ScreenState.success);
      } else {
        errorSituation(value, screenState: careerDetailScreenState);
      }
    });
  }
}
