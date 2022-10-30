import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/debouncer.dart';

class FollowButtonWidget extends StatelessWidget {
  FollowButtonWidget({Key? key, required this.user}) : super(key: key);

  User user;
  final Debouncer _debouncer = Debouncer();
  late int lastisFollowed;
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return user.userId != HomeController.to.myProfile.value.userId
        ? Obx(
            () => Row(children: [
              const SizedBox(
                width: 14,
              ),
              GestureDetector(
                onTap: () {
                  followMotion();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                      color: user.followed.value == FollowState.normal ||
                              user.followed.value == FollowState.follower
                          ? mainblue
                          : cardGray,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      user.followed.value == FollowState.normal ||
                              user.followed.value == FollowState.follower
                          ? "팔로우"
                          : "팔로잉",
                      style: kmain.copyWith(
                          color: user.followed.value == FollowState.normal ||
                                  user.followed.value == FollowState.follower
                              ? mainWhite
                              : mainblack),
                    ),
                  ),
                ),
              )
            ]),
          )
        : Container();
  }

  void followMotion() {
    if (number == 0) {
      lastisFollowed = user.followed.value.index;
    }
    if (user.banned.value == BanState.ban) {
      userbancancel(user.userId);
    } else {
      user.followClick();
      number += 1;

      _debouncer.run(() {
        if (user.followed.value.index != lastisFollowed) {
          if (<int>[2, 3].contains(user.followed.value.index)) {
            postfollowRequest(user.userId);
            print("팔로우");
          } else {
            deletefollow(user.userId);
            print("팔로우 해제");
          }
          lastisFollowed = user.followed.value.index;
        } else {
          print("아무일도 안 일어남");
        }
      });
    }
  }
}
