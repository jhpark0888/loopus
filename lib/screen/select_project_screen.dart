import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SelectProjectScreen extends StatelessWidget {
  const SelectProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '포스팅 작성하기',
        bottomBorder: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '어떤 활동에 대한 포스팅인가요?',
              style: kSubTitle2Style,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 28,
            ),
            //TODO: 활동 리스트
          ],
        ),
      ),
    );
  }
}
