import 'package:flutter/material.dart';
import 'package:loopus/widget/appbar_widget.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '메시지',
      ),
      body: Center(
        child: Text('메시지 스크린'),
      ),
    );
  }
}
