import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {Key? key,
      @required this.title,
      this.leading,
      this.actions,
      this.bottomBorder = true})
      : super(key: key);

  final AppBar appbar = AppBar();
  final String? title;
  Widget? leading;
  List<Widget>? actions;
  bool bottomBorder;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: kNavigationTitle,
      ),
      centerTitle: true,
      bottom: bottomBorder
          ? PreferredSize(
              child: Container(
                color: Color(0xffe7e7e7),
                height: 1,
              ),
              preferredSize: Size.fromHeight(4.0),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size.fromHeight(0),
            ),
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: mainWhite,
      leading: leading ??
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/Arrow.svg'),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
