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
import 'package:loopus/widget/person_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constant.dart';

class FollowPeopleScreen extends StatelessWidget {
  FollowPeopleScreen({Key? key, required this.userId, required this.listType})
      : super(key: key);
  late final FollowPeopleController _controller = Get.put(
      FollowPeopleController(userId: userId, listType: listType),
      tag: "${listType.name}$userId");
  int userId;
  followlist listType;
  late String followText = listType == followlist.follower ? "팔로워" : "팔로잉";

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
                        // _reLoad();
                      })
                    : _controller.followPeopleScreenState.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            // _reLoad();
                          })
                        : _controller.userList.isEmpty
                            ? EmptyContentWidget(
                                text: listType == followlist.follower
                                    ? "팔로워가 없습니다"
                                    : "팔로잉이 없습니다")
                            : SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                    const SizedBox(height: 14),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            "$followText ${_controller.userList.length}개",
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: FollowTileWidget(
                                              user: _controller.userList[index],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 24),
                                        itemCount: _controller.userList.length),
                                    const SizedBox(height: 24),
                                  ]))));
  }
}

class FollowTileWidget extends StatelessWidget {
  FollowTileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);
  final Debouncer _debouncer = Debouncer();
  User user;

  late int lastisFollowed;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(
                user: user, userid: user.userid, realname: user.realName),
            preventDuplicates: false);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(children: [
        PersonImageWidget(
          user: user,
          width: 36,
        ),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              user.realName,
              style: kmainbold,
            ),
            const SizedBox(height: 7),
            Text(
              "${user.univName} · ${user.department}",
              style: kmain,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: 14),
        if (user.userid != HomeController.to.myProfile.value.userid)
          Obx(
            () => Row(children: [
              const SizedBox(
                width: 14,
              ),
              GestureDetector(
                onTap: () {
                  user.looped.value = user.looped.value == FollowState.normal
                      ? FollowState.following
                      : user.looped.value == FollowState.follower
                          ? FollowState.wefollow
                          : user.looped.value == FollowState.following
                              ? FollowState.normal
                              : FollowState.follower;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                      color: user.looped.value == FollowState.normal ||
                              user.looped.value == FollowState.follower
                          ? mainblue
                          : cardGray,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      user.looped.value == FollowState.normal ||
                              user.looped.value == FollowState.follower
                          ? "팔로우"
                          : "팔로잉",
                      style: kmain.copyWith(
                          color: user.looped.value == FollowState.normal ||
                                  user.looped.value == FollowState.follower
                              ? mainWhite
                              : mainblack),
                    ),
                  ),
                ),
              )
            ]),
          )
      ]),
    );
  }

  void followMotion() {
    if (num == 0) {
      lastisFollowed = user.looped.value.index;
    }
    if (user.banned.value == BanState.ban) {
      userbancancel(user.userid);
    } else {
      if (user.looped.value == FollowState.normal) {
        // followController.islooped(1);
        user.looped(FollowState.following);
      } else if (user.looped.value == FollowState.follower) {
        // followController.islooped(1);

        user.looped(FollowState.wefollow);
      } else if (user.looped.value == FollowState.following) {
        // followController.islooped(0);

        user.looped(FollowState.normal);
      } else if (user.looped.value == FollowState.wefollow) {
        // followController.islooped(0);

        user.looped(FollowState.follower);
      }
      num += 1;

      _debouncer.run(() {
        if (user.looped.value.index != lastisFollowed) {
          if (<int>[2, 3].contains(user.looped.value.index)) {
            postfollowRequest(user.userid);
            print("팔로우");
          } else {
            deletefollow(user.userid);
            print("팔로우 해제");
          }
          lastisFollowed = user.looped.value.index;
        } else {
          print("아무일도 안 일어남");
        }
      });
    }
  }
}
