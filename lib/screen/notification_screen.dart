import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/appbar_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '알림',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                "루프 요청",
                style: kSubTitle2Style,
              ),
            ),
            Column(
              children: [],
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                "알림",
                style: kSubTitle2Style,
              ),
            ),
            Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
