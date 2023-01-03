import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/activity_detail_controller.dart';
import 'package:loopus/controller/spec_controller.dart';
import 'package:loopus/model/activity_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/duedate_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CoptNoticeScreen extends StatelessWidget {
  CoptNoticeScreen({Key? key, required this.activity}) : super(key: key);

  late final ActivityDetailController _controller =
      Get.put(ActivityDetailController(activity: activity));
  Activity activity;
  double imageAspectRatio = 420 / 600;
  RxDouble slideBorderRadius = 30.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "정보",
        bottomBorder: false,
      ),
      backgroundColor: AppColors.cardGray,
      body: Stack(
        children: [
          _buildNoticeImageView(),
          _buildNoticeInfoSlide(context),
        ],
      ),
    );
  }

  Widget _buildNoticeImageView() {
    return AspectRatio(
      aspectRatio: 420 / 600,
      child: CachedNetworkImage(
        imageUrl: activity.image,
        width: Get.width,
        fit: BoxFit.fill,
        placeholder: (context, string) {
          return Container(
            color: AppColors.maingray,
          );
        },
        errorWidget: (context, string, widget) {
          return Container(
            color: AppColors.maingray,
          );
        },
      ),
    );
  }

  Widget _buildNoticeInfoSlide(BuildContext context) {
    final imageHeight = Get.width * 1 / imageAspectRatio;
    final maxHeight = Get.height -
        AppBarWidget().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final minHeight = maxHeight - imageHeight + 50;
    return Obx(
      () => SlidingUpPanel(
        minHeight: minHeight,
        maxHeight: maxHeight,
        color: AppColors.cardGray,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(slideBorderRadius.value)),
        onPanelSlide: (position) {
          slideBorderRadius.value = 30 - (30 * position);
        },
        panelBuilder: (controller) => SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              _buildnoticeInfoView(context),
              const NewDivider(),
              _buildParticipationProfilesView(context),
              _buildRecentlyPostsView(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildnoticeInfoView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              activity is SchoolActi
                  ? Row(
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
                      ],
                    )
                  : DueDateWidget(dueDate: (activity as OutActi).endDate),
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
          Text(
            activity.title,
            style: MyTextTheme.navigationTitle(context)
                .copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          activity is SchoolActi
              ? RichText(
                  text: TextSpan(children: [
                  TextSpan(text: "작성일: ", style: MyTextTheme.mainbold(context)),
                  TextSpan(
                      text: DateFormat("yyyy-MM-dd")
                          .format((activity as SchoolActi).uploadDate),
                      style: MyTextTheme.main(context)),
                ]))
              : Column(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "주최: ", style: MyTextTheme.mainbold(context)),
                      TextSpan(
                          text: (activity as OutActi).organizer,
                          style: MyTextTheme.main(context)),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "접수 기간: ",
                          style: MyTextTheme.mainbold(context)),
                      TextSpan(
                          text:
                              "${DateFormat("yyyy-MM-dd").format((activity as OutActi).startDate)} ~ ${DateFormat("yyyy-MM-dd").format((activity as OutActi).endDate)}",
                          style: MyTextTheme.main(context)),
                    ]))
                  ],
                ),
          const SizedBox(height: 8),
          Text(
            "상세 내용",
            style: MyTextTheme.mainbold(context),
          ),
          const SizedBox(height: 8),
          Text(
            activity.content,
            style: MyTextTheme.main(context),
          ),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: "조회수 ", style: MyTextTheme.mainbold(context)),
            TextSpan(
                text: activity.viewCount.toString(),
                style: MyTextTheme.main(context)),
          ])),
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
            () => activity.member.isNotEmpty
                ? SizedBox(
                    height: 75,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            UserVerticalWidget(user: activity.member[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemCount: activity.member.length))
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
            child: Text(
              "최근 포스트",
              style: MyTextTheme.mainbold(context),
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
