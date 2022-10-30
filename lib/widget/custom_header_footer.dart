import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCustomHeader extends StatelessWidget {
  MyCustomHeader({Key? key, this.color}) : super(key: key);

  Color? color;

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      spacing: 0.0,
      height: 60,
      completeDuration: const Duration(milliseconds: 600),
      textStyle: const TextStyle(color: mainblack),
      refreshingText: '',
      releaseText: "",
      completeText: "",
      idleText: "",
      outerBuilder: (child) {
        return Container(
          height: Get.height,
          decoration: BoxDecoration(color: color),
          child: Align(alignment: Alignment.bottomCenter, child: child),
        );
      },
      refreshingIcon: Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
      releaseIcon: Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
      completeIcon: const Icon(
        Icons.check_rounded,
        color: mainblue,
      ),
      idleIcon: Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
    );
  }
}

class MyCustomFooter extends StatelessWidget {
  const MyCustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      spacing: 0.0,
      completeDuration: const Duration(milliseconds: 200),
      loadStyle: LoadStyle.ShowWhenLoading,
      loadingText: "",
      canLoadingText: "",
      noDataText: "",
      idleText: "",
      idleIcon: Container(),
      noMoreIcon: Container(),
      loadingIcon: Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
      canLoadingIcon: Image.asset(
        'assets/icons/loading.gif',
        scale: 6,
      ),
    );
  }
}
