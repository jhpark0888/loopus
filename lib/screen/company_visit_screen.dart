import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/user_tile_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constant.dart';

class CompanyVisitScreen extends StatelessWidget {
  CompanyVisitScreen(
      {Key? key, required this.isCompVisit, required this.company})
      : super(key: key);
  late final CompanyVisitController _controller =
      CompanyVisitController(userId: company.userId, isCompVisit: isCompVisit)
        ..getVisitShowUserList();
  Company company;
  bool isCompVisit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "${company.name}${isCompVisit ? "가 살펴본 프로필" : "를 조회한 프로필"}",
          bottomBorder: false,
        ),
        body: Obx(() => _controller.screenState.value == ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.screenState.value == ScreenState.normal
                ? Container()
                : _controller.screenState.value == ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        // _reLoad();
                      })
                    : _controller.screenState.value == ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            // _reLoad();
                          })
                        : _controller.userList.isEmpty
                            ? EmptyContentWidget(
                                text: isCompVisit
                                    ? "살펴본 프로필이 없습니다"
                                    : "조회한 프로필이 없습니다")
                            : SmartRefresher(
                                controller: _controller.refreshController,
                                enablePullDown: false,
                                enablePullUp: true,
                                footer: const MyCustomFooter(),
                                onLoading: _controller.onLoading,
                                child: SingleChildScrollView(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        Text(
                                            "총 ${_controller.userList.length}개의 프로필",
                                            style: MyTextTheme.main(context)
                                                .copyWith(
                                                    color: AppColors.maingray)),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Obx(
                                          () => ListView.separated(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return UserTileWidget(
                                                  user: _controller
                                                      .userList[index],
                                                );
                                              },
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const SizedBox(height: 24),
                                              itemCount:
                                                  _controller.userList.length),
                                        ),
                                        const SizedBox(height: 16),
                                      ]),
                                )),
                              )));
  }
}

class CompanyVisitController {
  CompanyVisitController({
    required this.userId,
    required this.isCompVisit,
  });

  int userId;
  bool isCompVisit;
  RxList<Person> userList = <Person>[].obs;
  Rx<ScreenState> screenState = ScreenState.loading.obs;
  RefreshController refreshController = RefreshController();
  int pageNum = 1;

  void onLoading() {
    getVisitShowUserList();
  }

  void getVisitShowUserList() {
    getCompShowUsers(isCompVisit ? "shown" : "user", pageNum).then((value) {
      if (value.isError == false) {
        List<Person> tempUserList = List.from(value.data)
            .map((friend) => Person.fromJson(friend))
            .toList();

        pageNum += 1;
        userList.addAll(tempUserList);
        refreshController.loadComplete();
        screenState(ScreenState.success);
      } else {
        if (value.errorData!["statusCode"] == 204) {
          refreshController.loadNoData();
        } else {
          errorSituation(value, screenState: screenState);
          refreshController.loadComplete();
        }
      }
    });
  }
}
