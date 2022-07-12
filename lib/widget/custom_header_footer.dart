import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCustomHeader extends StatelessWidget {
  const MyCustomHeader({Key? key}) : super(key: key);

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
      refreshingIcon: Column(
        children: [
          Image.asset(
            'assets/icons/loading.gif',
            scale: 6,
          ),
        ],
      ),
      releaseIcon: Column(
        children: [
          Image.asset(
            'assets/icons/loading.gif',
            scale: 6,
          ),
        ],
      ),
      completeIcon: Column(
        children: [
          const Icon(
            Icons.check_rounded,
            color: mainblue,
          ),
        ],
      ),
      idleIcon: Column(
        children: [
          Image.asset(
            'assets/icons/loading.png',
            scale: 12,
          ),
        ],
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
