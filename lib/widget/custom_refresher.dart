import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefresher extends StatelessWidget {
  CustomRefresher(
      {Key? key,
      required this.controller,
      required this.enablePullDown,
      required this.enablePullUp,
      required this.onRefresh,
      this.onLoading,
      required this.child,
      this.scrollController})
      : super(key: key);

  RefreshController controller;
  bool enablePullDown;
  Rx<bool> enablePullUp;
  Function()? onRefresh;
  Function()? onLoading;
  Widget child;
  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      scrollController: scrollController,
      controller: controller,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp.value,
      header: ClassicHeader(
        spacing: 0.0,
        height: 60,
        completeDuration: Duration(milliseconds: 600),
        textStyle: TextStyle(color: mainblack),
        refreshingText: '',
        releaseText: "",
        completeText: "",
        idleText: "",
        refreshingIcon: Column(
          children: [
            Image.asset(
              'assets/icons/loading.gif',
              scale: 4.5,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              '새로운 포스팅 받는 중...',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: mainblue.withOpacity(0.6),
              ),
            ),
          ],
        ),
        releaseIcon: Column(
          children: [
            Image.asset(
              'assets/icons/loading.gif',
              scale: 4.5,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              '새로운 포스팅 받는 중...',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: mainblue.withOpacity(0.6),
              ),
            ),
          ],
        ),
        completeIcon: Column(
          children: [
            Icon(
              Icons.check_rounded,
              color: mainblue,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              '완료!',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: mainblue.withOpacity(0.6),
              ),
            ),
          ],
        ),
        idleIcon: Column(
          children: [
            Image.asset(
              'assets/icons/loading.png',
              scale: 9,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '당겨주세요',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: mainblue.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
      footer: ClassicFooter(
        completeDuration: Duration.zero,
        loadingText: "",
        canLoadingText: "",
        idleText: "",
        idleIcon: Container(),
        loadingIcon: Image.asset(
          'assets/icons/loading.gif',
          scale: 4.5,
        ),
        canLoadingIcon: Image.asset(
          'assets/icons/loading.gif',
          scale: 4.5,
        ),
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
