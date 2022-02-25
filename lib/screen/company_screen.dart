import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';

import '../constant.dart';

class CompanyScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainblue,
        elevation: 0,
        centerTitle: false,
        title: Obx(
          () => Text(
            '${_profileController.myUserInfo.value.realName}님에게 추천드리는 기업',
            style: kHeaderH1Style.copyWith(color: mainWhite),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ModalController.to
                  .showCustomDialog('본인의 활동과 관심 태그를 기반으로\n맞춤 기업을 추천해드려요', 1500);
            },
            icon: SvgPicture.asset(
              'assets/icons/Question.svg',
              color: mainWhite,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
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
                  text: '를 받아오는 중이에요',
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
