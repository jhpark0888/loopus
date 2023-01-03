import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/class_detail_controller.dart';
import 'package:loopus/controller/spec_controller.dart';
import 'package:loopus/main.dart';
import 'package:loopus/model/class_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SchoolClassScreen extends StatelessWidget {
  SchoolClassScreen({Key? key, required this.schoolClass}) : super(key: key);

  late final ClassDetailController _controller =
      Get.put(ClassDetailController(schoolClass: schoolClass));
  SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "정보",
        bottomBorder: false,
      ),
      backgroundColor: AppColors.cardGray,
      body: SmartRefresher(
        controller: _controller.loadController,
        footer: const MyCustomFooter(),
        enablePullDown: false,
        enablePullUp: true,
        onLoading: _controller.onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildClassInfoView(context),
              const NewDivider(),
              _buildParticipationProfilesView(context),
              _buildRecentlyPostsView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassInfoView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.mainWhite),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/class_information.svg',
                ),
                const SizedBox(width: 8),
                Text(
                  "수업에서 진행한 과제, 프로젝트 등 결과물은"
                  "\n기업에서 중요하게 확인하는 직무 관련 커리어에요."
                  "\n수업 관련 자료를 잘 정리해두는게 포인트!",
                  textAlign: TextAlign.center,
                  style: MyTextTheme.main(context),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              UserImageWidget(
                imageUrl: SpecController.to.univLogo.value,
                width: 24,
                height: 24,
                userType: UserType.student,
              ),
              const SizedBox(width: 8),
              Text(
                SpecController.to.shortUnivName,
                style: MyTextTheme.main(context),
              ),
              const Spacer(),
              Container(
                height: 44,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.mainWhite,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/career_add.svg',
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "내 커리어에 추가하기",
                      style: MyTextTheme.mainbold(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.mainWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  schoolClass.className,
                  style: MyTextTheme.mainbold(context),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "분류: ",
                    style: MyTextTheme.mainbold(context),
                  ),
                  TextSpan(
                    text: schoolClass.subject,
                    style: MyTextTheme.main(context),
                  )
                ])),
                const SizedBox(height: 8),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "학과: ",
                    style: MyTextTheme.mainbold(context),
                  ),
                  TextSpan(
                    text: schoolClass.dept,
                    style: MyTextTheme.main(context),
                  )
                ])),
                // const SizedBox(height: 8),
                // RichText(
                //     text: TextSpan(children: [
                //   TextSpan(
                //     text: "시간: ",
                //     style: MyTextTheme.mainbold(context),
                //   ),
                //   TextSpan(
                //     text: "3B-5",
                //     style: MyTextTheme.main(context),
                //   )
                // ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationProfilesView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "참여한 프로필",
              style: MyTextTheme.mainbold(context),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => schoolClass.member.isNotEmpty
                ? SizedBox(
                    height: 75,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            UserVerticalWidget(user: schoolClass.member[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemCount: schoolClass.member.length))
                : EmptyContentWidget(text: "참가한 프로필이 없습니다."),
          )
        ],
      ),
    );
  }

  Widget _buildRecentlyPostsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  "최근 포스트",
                  style: MyTextTheme.mainbold(context),
                ),
                const Spacer(),
                Obx(
                  () => _controller.posts.isNotEmpty
                      ? Text(
                          "전체보기",
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.mainblue),
                        )
                      : Container(),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => _controller.posts.isNotEmpty
                ? ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => PostingWidget(
                        item: _controller.posts[index],
                        type: PostingWidgetType.normal),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: _controller.posts.length)
                : EmptyContentWidget(text: "최근 포스트가 없습니다"),
          )
        ],
      ),
    );
  }
}
