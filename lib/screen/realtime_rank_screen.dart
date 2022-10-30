import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constant.dart';

class RealTimeRankScreen extends StatelessWidget {
  RealTimeRankScreen(
      {Key? key, required this.currentField, required this.isUniversity})
      : super(key: key);
  late final CareerBoardController _controller =
      Get.find<CareerBoardController>()
        ..getRanker(currentField.key, isUniversity);
  MapEntry<String, String> currentField;
  bool isUniversity;

  void _reLoad() {
    _controller.getRanker(currentField.key, isUniversity);
  }

  void onRefresh() {
    _reLoad();

    _controller.allrankerRefreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '실시간 커리어 순위',
          bottomBorder: false,
        ),
        body: Obx(() => _controller.allrankerScreenstate.value ==
                ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.allrankerScreenstate.value == ScreenState.normal
                ? Container()
                : _controller.allrankerScreenstate.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        _reLoad();
                      })
                    : _controller.allrankerScreenstate.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            _reLoad();
                          })
                        : (isUniversity == true
                                ? _controller
                                    .campusRankerMap[currentField.key]!.isEmpty
                                : _controller
                                    .koreaRankerMap[currentField.key]!.isEmpty)
                            ? EmptyContentWidget(text: "실시간 순위가 없습니다")
                            : SmartRefresher(
                                physics: const BouncingScrollPhysics(),
                                controller:
                                    _controller.allrankerRefreshController,
                                header: MyCustomHeader(),
                                onRefresh: onRefresh,
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                      const SizedBox(height: 16),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              isUniversity == true
                                                  ? "교내 TOP 50"
                                                  : "TOP 50",
                                              style: kmain)),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: PersonRankWidget(
                                                user: isUniversity == true
                                                    ? _controller
                                                            .campusRankerMap[
                                                        currentField
                                                            .key]![index]
                                                    : _controller
                                                            .koreaRankerMap[
                                                        currentField
                                                            .key]![index],
                                                isUniversity: isUniversity,
                                                isFollow: true,
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 24),
                                          itemCount: isUniversity == true
                                              ? _controller
                                                  .campusRankerMap[
                                                      currentField.key]!
                                                  .length
                                              : _controller
                                                  .koreaRankerMap[
                                                      currentField.key]!
                                                  .length)
                                    ])),
                              )));
  }
}
