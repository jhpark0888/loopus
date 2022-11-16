import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/follow_people_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/search_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_tile_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constant.dart';

class FollowPeopleScreen extends StatelessWidget {
  FollowPeopleScreen({Key? key, required this.userId, required this.listType})
      : super(key: key);
  late final FollowPeopleController _controller = Get.put(
      FollowPeopleController(userId: userId, listType: listType),
      tag: "${listType.name}$userId");
  int userId;
  FollowListType listType;
  late String followText = listType == FollowListType.follower ? "팔로워" : "팔로잉";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: followText,
          bottomBorder: false,
        ),
        body: Obx(() => _controller.followPeopleScreenState.value ==
                ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.followPeopleScreenState.value == ScreenState.normal
                ? Container()
                : _controller.followPeopleScreenState.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        _controller.getfollowPeople();
                      })
                    : _controller.followPeopleScreenState.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            _controller.getfollowPeople();
                          })
                        : _controller.userList.isEmpty
                            ? EmptyContentWidget(
                                text: listType == FollowListType.follower
                                    ? "팔로워가 없습니다"
                                    : "팔로잉이 없습니다")
                            : SingleChildScrollView(
                                child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                          "$followText ${_controller.userList.length}개의 프로필",
                                          style: MyTextTheme.main(context)
                                              .copyWith(
                                                  color: AppColors.maingray)),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return UserTileWidget(
                                              user: _controller.userList[index],
                                              isFollowButton: true,
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 24),
                                          itemCount:
                                              _controller.userList.length),
                                      const SizedBox(height: 16),
                                    ]),
                              ))));
  }
}
