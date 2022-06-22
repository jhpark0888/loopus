import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
      idleText: "",
      idleIcon: Container(),
      noMoreIcon: Container(
        child: Text('as'),
      ),
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
