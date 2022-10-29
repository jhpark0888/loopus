// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/likepeople_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LikePeopleScreen extends StatelessWidget {
  LikePeopleScreen({Key? key, required this.id, required this.likeType})
      : super(key: key);

  late final LikePeopleController _controller =
      LikePeopleController(id: id, likeType: likeType)..likePeopleLoad();

  int id;
  contentType likeType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "좋아요",
        bottomBorder: false,
      ),
      body: Obx(
        () => _controller.likepeoplescreenstate.value == ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.likepeoplescreenstate.value == ScreenState.normal
                ? Container()
                : _controller.likepeoplescreenstate.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        _controller.likePeopleLoad();
                      })
                    : _controller.likepeoplescreenstate.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            _controller.likePeopleLoad();
                          })
                        : _controller.likeUserList.isEmpty
                            ? EmptyContentWidget(text: "좋아요가 없습니다")
                            : ScrollNoneffectWidget(
                                child: SmartRefresher(
                                physics: const BouncingScrollPhysics(),
                                controller: _controller.refreshController,
                                enablePullUp: true,
                                header: MyCustomHeader(),
                                footer: const MyCustomFooter(),
                                onRefresh: _controller.onRefresh,
                                child: SingleChildScrollView(
                                    child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 14),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment: Alignment.centerRight,
                                      child: Obx(
                                        () => Text(
                                          "좋아요 ${_controller.likeUserList.length}개",
                                          style: kmain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Obx(
                                      () => ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return SearchUserWidget(
                                              user: _controller
                                                  .likeUserList[index],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: 12),
                                          itemCount:
                                              _controller.likeUserList.length),
                                    )
                                  ],
                                )),
                              )),
      ),
    );
  }
}
