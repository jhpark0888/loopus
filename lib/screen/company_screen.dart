import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/post_add_test.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/screen/websocet_screen.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

import '../constant.dart';

class CompanyScreen extends StatelessWidget {
  // final ProfileController _profileController = Get.put(ProfileController());
  CareerBoardController controller = Get.put(CareerBoardController());

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
            child: Text(
              '커리어 보드',
              style: ktitle,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 24, 0),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/Question copy.svg',
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Column(children: [
                Text(
                  controller.currentFieldText.value,
                  style: k13midum.copyWith(color: mainWhite),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 30,
                  // width: 200,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      if (controller.currentField.value != index.toDouble()) {
                        controller.currentField(index.toDouble());
                        controller.pageFieldController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      }
                      controller.currentFieldText.value =
                          controller.fieldlist[controller.currentField.toInt()];
                    },
                    itemBuilder: (context, page) {
                      var _scale =
                          controller.currentField.value == page.toDouble()
                              ? 1.0
                              : 0.8;
                      var _color =
                          controller.currentField.value == page.toDouble()
                              ? mainblack
                              : mainblack.withOpacity(0.2);
                      return TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 350),
                          tween: Tween(begin: _scale, end: _scale),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Center(
                            child: Text(
                              controller.fieldlist[page],
                              style: ktitle.copyWith(color: _color),
                            ),
                          ));
                    },
                    itemCount: controller.fieldlist.length,
                    controller: controller.fieldController,
                  ),
                ),
                Obx(
                  () => ExpandablePageView.builder(
                    controller: controller.pageFieldController,
                    onPageChanged: (index) {
                      if (controller.currentField.value != index.toDouble()) {
                        controller.currentField(index.toDouble());
                        controller.currentField.refresh();
                        controller.fieldController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      }
                      controller.currentFieldText.value =
                          controller.fieldlist[controller.currentField.toInt()];
                    },
                    itemBuilder: (context, index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, top: 24),
                              child: Obx(
                                () => Text(
                                  '${controller.currentFieldText.value} 분야 실시간 순위',
                                  style: k18semiBold,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //       children: controller.careerRank
                            //           .map((element) => Row(
                            //                   mainAxisSize: MainAxisSize.min,
                            //                   children: [
                            //                     const SizedBox(width: 14),
                            //                     element
                            //                   ]))
                            //           .toList()),
                            // ),
                            SizedBox(
                              height: 360,
                              child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return controller.careerRank[index];
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 14);
                                  },
                                  itemCount: controller.careerRank.length),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                '${controller.currentFieldText.value} 분야 최근 인기 기업',
                                style: k18semiBold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return companyWidget(
                                        controller.companyList[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 14);
                                  },
                                  itemCount: controller.companyList.length),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: Text('실시간 인기 포스트', style: k18semiBold),
                            ),
                            const SizedBox(height: 14),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(
                                () => Row(
                                    children: controller.topPostList
                                        .map((element) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(width: 14),
                                                  topPost(element)
                                                ]))
                                        .toList()),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.only(left: 24.0, right: 24),
                              child: Divider(thickness: 1, color: cardGray),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                                padding: EdgeInsets.only(left: 24.0, right: 24),
                                child: Text('해시태그 분석', style: k18semiBold)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 24, top: 6),
                              child: Obx(
                                () => ListView.separated(
                                  padding: const EdgeInsets.only(top: 20),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount:
                                      HomeController.to.topTagList.length,
                                  itemBuilder: (context, index) {
                                    return tagAnalize(
                                        HomeController.to.topTagList[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 14);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.only(left: 24.0, right: 24),
                              child: Divider(thickness: 1, color: cardGray),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.only(left: 24.0, right: 24),
                              child: Text('포스트 분석', style: k18semiBold),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(right: 46),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      width: 20,
                                      height: 1,
                                      decoration:
                                          BoxDecoration(color: myPostColor)),
                                  const SizedBox(width: 4),
                                  Text('내 포스트 수',
                                      style: k13midum.copyWith(
                                          color: myPostColor)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, bottom: 34),
                              child: Container(
                                height: 172,
                                width: 295,
                                decoration: BoxDecoration(color: maingray),
                              ),
                            )
                          ]);
                    },
                    itemCount: controller.fieldlist.length,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }

  Widget companyWidget(Company company) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: lightcardgray, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: dividegray, width: 0.5),
              ),
              height: 60,
              width: 60,
              child: Image.network(company.companyImage, fit: BoxFit.fill)),
          const SizedBox(width: 24),
          Column(
            children: [
              Text(company.companyName),
              const SizedBox(height: 7),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: company.contactField,
                    style: k15normal.copyWith(color: mainblue)),
                const TextSpan(text: '분야 컨택 중', style: k15normal)
              ]))
            ],
          )
        ],
      ),
    );
  }

  Widget topPost(Post post) {
    return GestureDetector(
      onTap: (){Get.to(() => PostingScreen(post: post,postid: post.id),opaque: false);},
      child: Container(
        width: 280,
        decoration: BoxDecoration(
            color: lightcardgray, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Row(
                children: [
                  UserImageWidget(
                    imageUrl: post.user.profileImage ?? '',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '${post.user.realName} · ', style: k15semiBold),
                    TextSpan(text: post.user.department, style: k15normal)
                  ])),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/Bookmark_Inactive.svg')
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Text(post.project!.careerName,
                  style: k15normal.copyWith(color: maingray)),
            ),
            const SizedBox(height: 14),
            if (post.images.isNotEmpty)
              SizedBox(
                  width: 280,
                  height: 195,
                  child: CachedNetworkImage(
                      imageUrl: post.images.first, fit: BoxFit.fill)),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: ExpandableText(
                  textSpan: TextSpan(
                      text: post.content, style: k15normal.copyWith(height: 1.5)),
                  maxLines: 3,
                  moreSpan: TextSpan(
                      text: '...', style: k15normal.copyWith(height: 1.5))),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Text('좋아요 ', style: k15normal.copyWith(color: maingray)),
                  Text('${post.likeCount}개', style: k15normal),
                  const SizedBox(width: 7),
                  Text('댓글 ', style: k15normal.copyWith(color: maingray)),
                  Text(
                    '${(post.comments.length + 1).toString()}개',
                    style: k15normal,
                  ),
                  const Spacer(),
                  Text('교내추천', style: k15normal.copyWith(color: maingray))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tagAnalize(Tag tag) {
    return Row(children: [
      Text(
        tag.tagId.toString(),
        style: k16semiBold,
      ),
      const SizedBox(width: 14),
      Tagwidget(tag: tag),
      const Spacer(),
      Text(
        '${tag.count.toString()}회',
        style: k15normal,
      )
    ]);
  }
}
