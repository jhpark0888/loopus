import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/search_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/divide_widget.dart';
// import 'package:loopus/trash_bin/overflow_text_widget.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_tile_widget.dart';
import 'package:path_provider/path_provider.dart';

enum PostingWidgetType { normal, search, detail }

class PostingWidget extends StatelessWidget {
  // final int index;
  Post item;
  PostingWidgetType type;
  PostingWidget(
      {required this.item, Key? key, required this.type, this.isDark = false})
      : super(key: key);

  PageController pageController = PageController();

  final Debouncer _debouncer = Debouncer();

  late int lastIsLiked;
  int likenum = 0;
  late int lastIsMaked;
  int marknum = 0;
  final bool isDark;
  RxBool isFileViewExpand = false.obs;
  late DateTime downLoadValidPeriod = item.date.add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: type != PostingWidgetType.detail ? () => tapPosting() : null,
      // behavior: HitTestBehavior.translucent,
      splashColor:
          type != PostingWidgetType.detail ? AppColors.kSplashColor : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () => tapProfile(),
                      child: UserTileWidget(
                        user: item.user,
                        isDark: isDark,
                      )),
                  const SizedBox(height: 10),
                  if (item.user.userType == UserType.student)
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: tapProjectname,
                        child: Text(
                          item.project!.careerName,
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.maingray),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ]),
          if (item.images.isNotEmpty || item.links.isNotEmpty)
            SwiperWidget(
              items: item.images.isNotEmpty ? item.images : item.links,
              swiperType:
                  item.images.isNotEmpty ? SwiperType.image : SwiperType.link,
              aspectRatio: item.images.isNotEmpty
                  ? getAspectRatioinUrl(item.images[0])
                  : null,
            ),
          if (item.fileCount != 0) _fileView(context),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.content.value.isNotEmpty)
                      Obx(
                        () => Column(
                          children: [
                            type == PostingWidgetType.detail
                                ? Linkify(
                                    options:
                                        const LinkifyOptions(humanize: false),
                                    text: item.content.value,
                                    onOpen: (url) {
                                      Get.to(() => WebViewScreen(url: url.url));
                                    },
                                    style: MyTextTheme.mainheight(context),
                                    linkStyle: MyTextTheme.mainheight(context)
                                        .copyWith(color: AppColors.mainblue),
                                  )
                                // Text(item.content.value,
                                //     style: MyTextTheme.mainheight(context))
                                : ExpandableText(
                                    textSpan: TextSpan(
                                        text: item.content.value,
                                        style: MyTextTheme.mainheight(context)
                                            .copyWith(
                                                color: isDark
                                                    ? AppColors.mainWhite
                                                    : null)),
                                    moreSpan: TextSpan(
                                        text: ' ...더보기',
                                        style: MyTextTheme.mainheight(context)
                                            .copyWith(
                                                color: AppColors.maingray)),
                                    maxLines: 3),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    if (item.tags.isNotEmpty)
                      Column(children: [
                        Obx(
                          () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.tags
                                  .map((tag) => Tagwidget(
                                        tag: tag,
                                        isDark: isDark,
                                      ))
                                  .toList()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: tapLike,
                                child: item.isLiked.value == 0
                                    ? SvgPicture.asset(
                                        "assets/icons/postunlike.svg",
                                        color:
                                            isDark ? AppColors.mainWhite : null,
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/postlike.svg"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Obx(
                            //   () => SizedBox(
                            //     width: item.likeCount.value != 0 ? 0 : 8,
                            //   ),
                            // ),
                            InkWell(
                                onTap: type != PostingWidgetType.detail
                                    ? () => tapPosting(autoFocus: true)
                                    : null,
                                child: SvgPicture.asset(
                                    "assets/icons/comment.svg",
                                    color:
                                        isDark ? AppColors.mainWhite : null)),
                            const Spacer(),
                            Obx(
                              () => InkWell(
                                onTap: tapBookmark,
                                child: (item.isMarked.value == 0)
                                    ? SvgPicture.asset(
                                        "assets/icons/post_bookmark_inactive.svg",
                                        color:
                                            isDark ? AppColors.mainWhite : null,
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/post_bookmark_active.svg"),
                              ),
                            ),
                          ],
                        ),
                        // postingTag(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Get.to(
                                  () => LikePeopleScreen(
                                    id: item.id,
                                    likeType: contentType.post,
                                  ),
                                );
                              },
                              child: Obx(
                                () => Text(
                                  '좋아요 ${item.likeCount.value}개',
                                  style: MyTextTheme.main(context).copyWith(
                                      color:
                                          isDark ? AppColors.mainWhite : null),
                                ),
                              )),
                          const Spacer(),
                          Text(calculateDate(item.date),
                              style: MyTextTheme.main(context).copyWith(
                                  color: isDark ? AppColors.mainWhite : null)),
                        ]),
                        SizedBox(
                            height: (type == PostingWidgetType.detail ||
                                    type == PostingWidgetType.search)
                                ? 16
                                : 10),

                        Obx(
                          () => item.comments.isNotEmpty &&
                                  !(type == PostingWidgetType.detail ||
                                      type == PostingWidgetType.search)
                              ? Column(
                                  children: [
                                    Obx(
                                      () => Row(
                                        children: [
                                          Text(
                                            item.comments.first.user.name,
                                            style: MyTextTheme.mainbold(context)
                                                .copyWith(
                                                    color: isDark
                                                        ? AppColors.mainWhite
                                                        : null),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item.comments.first.content,
                                              style: MyTextTheme.main(context)
                                                  .copyWith(
                                                      color: isDark
                                                          ? AppColors.mainWhite
                                                          : null),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // if (view != 'detail') const DivideWidget()
            ],
          ),
        ],
      ),
    );
  }

  Widget _fileView(BuildContext context) {
    return type != PostingWidgetType.detail
        ? Column(
            children: [
              DivideWidget(
                height: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/file_icon.svg'),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      "${item.fileCount}개의 파일 업로드",
                      style: MyTextTheme.main(context),
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              DivideWidget(
                height: 1,
              ),
              const SizedBox(height: 10),
            ],
          )
        : Column(
            children: [
              DivideWidget(
                height: 1,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  isFileViewExpand.toggle();
                },
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/file_icon.svg'),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        "${item.fileCount}개의 파일 업로드",
                        style: MyTextTheme.main(context),
                      )),
                      Obx(() => isFileViewExpand.value == false
                          ? SvgPicture.asset('assets/icons/down_arrow.svg')
                          : RotatedBox(
                              quarterTurns: 2,
                              child: SvgPicture.asset(
                                  'assets/icons/down_arrow.svg'),
                            )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DivideWidget(
                height: 1,
              ),
              Obx(() => isFileViewExpand.value
                  ? Column(
                      children: [
                        ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                _fileWidget(context, item.files[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: item.files.length),
                        DivideWidget(
                          height: 1,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 10),
            ],
          );
  }

  Widget _fileWidget(BuildContext context, String file) {
    return GestureDetector(
      onTap: () async {
        //final status = await Permission.storage.request();
        if (downLoadValidPeriod.isAfter(DateTime.now())) {
          String dir = (await getApplicationDocumentsDirectory())
              .path; //path provider로 저장할 경로 가져오기
          try {
            await FlutterDownloader.enqueue(
                url: file, // file url
                savedDir: '$dir/', // 저장할 dir
                fileName: Uri.decodeFull(file.split("/").last), // 파일명
                saveInPublicStorage: true, // 동일한 파일 있을 경우 덮어쓰기 없으면 오류발생함!
                showNotification: true,
                openFileFromNotification: true);
            showCustomDialog("다운로드가 완료 되었습니다", 1000);
          } catch (e) {
            showCustomDialog("다운로드가 실패 되었습니다", 1000);
          }
        } else {
          showCustomDialog("다운로드 기간이 만료 되었습니다.", 1000);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/file_icon.svg'),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Uri.decodeFull(file.split("/").last),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.main(context),
                  ),
                  Text(
                    "${DateFormat('yyyy년 MM월 dd일').format(downLoadValidPeriod)}까지 다운로드 가능",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.main(context)
                        .copyWith(color: AppColors.dividegray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tapPosting({bool autoFocus = false}) {
    if (type == PostingWidgetType.search) {
      addRecentSearch(SearchType.post.index,
              SearchController.to.searchtextcontroller.text.trim())
          .then((value) {
        if (value.isError == false && value.data != null) {
          RecentSearch tempRecSearch = RecentSearch.fromJson(value.data);
          SearchController.to.recentSearchList.insert(0, tempRecSearch);
        }
      });
    }
    Get.to(
      () => PostingScreen(
        post: item,
        postid: item.id,
        autofocus: autoFocus,
      ),
      preventDuplicates: false,
    );
  }

  void tapProjectname() async {
    await getproject(item.project!.id, item.userid).then(
      (value) {
        if (value.isError == false) {
          Project project = Project.fromJson(value.data);
          goCareerScreen(
            project,
            item.user.name,
          );
        }
      },
    );
  }

  void tapBookmark() {
    if (marknum == 0) {
      lastIsMaked = item.isMarked.value;
    }
    item.otherPageLikeOrBookMark(false);
    // if (item.isMarked.value == 0) {
    //   item.isMarked(1);
    // } else {
    //   item.isMarked(0);
    // }
    marknum += 1;

    _debouncer.run(() {
      if (lastIsMaked != item.isMarked.value) {
        bookmarkpost(item.id).then((value) {
          if (value.isError == false) {
            lastIsMaked = item.isMarked.value;
            marknum = 0;

            if (item.isMarked.value == 1) {
              // HomeController.to.tapBookmark(item.id);
              showCustomDialog("북마크에 추가되었습니다", 1000);
            } else {
              // HomeController.to.tapunBookmark(item.id);
            }
          } else {
            errorSituation(value);
            item.isMarked(lastIsMaked);
          }
        });
      }
    });
  }

  void tapLike() {
    if (likenum == 0) {
      lastIsLiked = item.isLiked.value;
    }
    item.otherPageLikeOrBookMark(true);

    // if (item.isLiked.value == 0) {
    //   item.isLiked(1);
    //   item.likeCount += 1;
    //   print("좋아요");
    //   // HomeController.to.tapLike(item.id, item.likeCount.value);
    //   // ProfileController.to
    //   //     .tapLike(item.project!.id, item.id, item.likeCount.value);
    // } else {
    //   item.isLiked(0);
    //   item.likeCount -= 1;
    //   print("좋아요 취소");
    //   // HomeController.to.tapunLike(item.id, item.likeCount.value);
    //   // ProfileController.to
    //   //     .tapunLike(item.project!.id, item.id, item.likeCount.value);
    // }
    likenum += 1;

    _debouncer.run(() {
      if (lastIsLiked != item.isLiked.value) {
        likepost(item.id, contentType.post);

        lastIsLiked = item.isLiked.value;
        likenum = 0;
      }
    });
  }

  void tapProfile() {
    if (item.user.userType == UserType.student) {
      Get.to(
          () => OtherProfileScreen(
              user: (item.user as Person),
              userid: item.user.userId,
              realname: item.user.name),
          preventDuplicates: false);
    } else {
      Get.to(
          () => OtherCompanyScreen(
                companyId: item.user.userId,
                companyName: item.user.name,
                company: (item.user as Company),
              ),
          preventDuplicates: false);
    }
  }
}
