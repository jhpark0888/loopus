import 'package:flutter/material.dart';
import 'package:loopus/widget/appbar_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '알림',
      ),
      body: Center(
        child: Text('알림 스크린'),
      ),
    );
  }
}
