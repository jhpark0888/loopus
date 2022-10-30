// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/banpeople_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:loopus/widget/user_tile_widget.dart';

class BanPeopleScreen extends StatelessWidget {
  BanPeopleScreen({
    Key? key,
  }) : super(key: key);

  final BanPeopleController _controller = Get.put(BanPeopleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "차단 관리",
        bottomBorder: false,
      ),
      body: Obx(
        () => _controller.banpeoplescreenstate.value == ScreenState.loading
            ? Center(child: const LoadingWidget())
            : _controller.banpeoplescreenstate.value == ScreenState.disconnect
                ? DisconnectReloadWidget(reload: () {
                    _controller.loadbanlist();
                  })
                : _controller.banpeoplescreenstate.value == ScreenState.error
                    ? ErrorReloadWidget(reload: () {
                        _controller.loadbanlist();
                      })
                    : Obx(
                        () => _controller.banlist.isEmpty
                            ? EmptyContentWidget(text: "차단한 유저가 없어요")
                            : ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                itemBuilder: (context, index) => UserTileWidget(
                                      user: _controller.banlist[index],
                                      isFollowButton: true,
                                    ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 24,
                                    ),
                                itemCount: _controller.banlist.length),
                      ),
      ),
    );
  }
}
