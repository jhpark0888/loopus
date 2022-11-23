import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkScreen extends StatelessWidget {
  final BookmarkController _controller = Get.put(BookmarkController());

  void _reLoad() {
    _controller.bookmarkScreenState(ScreenState.loading);
    _controller.bookmarkLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '스크랩',
        bottomBorder: false,
      ),
      body: Obx(
        () => _controller.bookmarkScreenState.value == ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.bookmarkScreenState.value == ScreenState.normal
                ? Container()
                : _controller.bookmarkScreenState.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: _reLoad)
                    : _controller.bookmarkScreenState.value == ScreenState.error
                        ? ErrorReloadWidget(reload: _reLoad)
                        : _controller.posts.isEmpty
                            ? EmptyContentWidget(text: "북마크한 포스팅이 없습니다")
                            : ScrollNoneffectWidget(
                                child: SmartRefresher(
                                  controller: _controller.refreshController,
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  header: MyCustomHeader(),
                                  footer: const MyCustomFooter(),
                                  onRefresh: _controller.onBookmarkRefresh,
                                  onLoading: _controller.onBookmarkLoading,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: ((context, index) {
                                            return PostingWidget(
                                                item: _controller.posts[index],
                                                type: PostingWidgetType.normal);
                                          }),
                                          itemCount: _controller.posts.length)
                                    ],
                                  )),
                                ),
                              ),
      ),
    );
  }
}
