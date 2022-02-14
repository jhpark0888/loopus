import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';

import '../constant.dart';

class CompanyScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Obx(
          () => Text(
            '${_profileController.myUserInfo.value.realName}님께 추천드리는 기업',
            style: kHeaderH1Style,
          ),
        ),
        actions: [],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 28,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '추천 기업 리스트',
                  style: kSubTitle2Style.copyWith(
                    color: mainblue,
                  ),
                ),
                TextSpan(
                  text: '를 생성 중이에요',
                  style: kSubTitle2Style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text('추후 업데이트 예정인 서비스입니다', style: kBody2Style),
          SizedBox(
            height: 44,
          ),
          Image.asset(
            'assets/illustrations/company_image.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
