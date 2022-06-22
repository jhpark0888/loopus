import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/post_add_test.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/widget/career_rank_widget.dart';

import '../constant.dart';

class CompanyScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: AppBar(
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 24, 20),
              child: Text('커리어 보드', style: k26Semibold,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 24, 0),
                child: IconButton(
                  onPressed: () {
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/Question copy.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text('IT', style: k26Semibold,),
          ),
          Padding(
            padding: EdgeInsets.only(left : 24.0, top: 24),
            child: Text('IT 분야 실시간 순위', style: k18Semibold,),
          ),
          const SizedBox(height: 14),
          CareerRankWidget(isUniversity: true,),
          IconButton(onPressed: (){Get.to(()=> UploadScreen());}, icon: Text('바로가기')),
          IconButton(onPressed: (){Get.to(()=> PostingAddNameScreen1(project_id : 6, route: PostaddRoute.bottom,));}, icon: Text('포스트 작성 가기'))
        ],)
        // body: Column(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       height: 44,
        //     ),
        //     RichText(
        //       textAlign: TextAlign.center,
        //       text: TextSpan(
        //         children: [
        //           TextSpan(
        //             text: '추천 기업 리스트',
        //             style: kSubTitle2Style.copyWith(
        //               color: mainblue,
        //             ),
        //           ),
        //           TextSpan(
        //             text: '를 받아오는 중이에요',
        //             style: kSubTitle2Style,
        //           ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(
        //       height: 16,
        //     ),
        //     Text('추후 업데이트 예정인 서비스입니다', style: kBody2Style),
        //     SizedBox(
        //       height: 44,
        //     ),
        //     Image.asset(
        //       'assets/illustrations/company_image.png',
        //       fit: BoxFit.cover,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
