import 'package:flutter/material.dart';

class ScrollNoneffectWidget extends StatelessWidget {
  ScrollNoneffectWidget({Key? key, required this.child}) : super(key: key);
  Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((notification) {
          notification.disallowIndicator();
          return false;
        }),
        child: child);
  }
}
