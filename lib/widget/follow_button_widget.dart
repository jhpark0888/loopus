import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/banpeople_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/error_control.dart';

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
            () => GestureDetector(
              onTap: () {
                followMotion();
              },
              child: Container(
                height: 36,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                    color: user.banned.value == BanState.ban
                        ? rankred
                        : user.followed.value == FollowState.normal ||
                                user.followed.value == FollowState.follower
                            ? mainblue
                            : cardGray,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    user.banned.value == BanState.ban
                        ? '차단 해제'
                        : user.followed.value == FollowState.normal ||
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
            ),
          )
        : Container();
  }

  void followMotion() {
    if (number == 0) {
      lastisFollowed = user.followed.value.index;
    }
    if (user.banned.value == BanState.ban) {
      userbancancel(user.userId).then((value) {
        if (value.isError == false) {
          user.banClick();
          showCustomDialog("해당 유저가 차단해제 되었습니다", 1000);

          if (Get.isRegistered<BanPeopleController>()) {
            BanPeopleController.to.banlist
                .removeWhere((banUser) => banUser.userId == user.userId);
          }
        } else {
          errorSituation(value);
        }
      });
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
