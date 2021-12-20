import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key, @required this.appbar, @required this.title})
      : super(key: key);

  final AppBar? appbar;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        // style: TextStyle(color: mainFontDark),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.near_me,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar!.preferredSize.height);
}
