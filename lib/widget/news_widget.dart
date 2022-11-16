import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/issue_model.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/custom_linkpreview.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

// class NewsWidget extends StatelessWidget {
//   NewsWidget({Key? key, required this.url}) : super(key: key);
//   String url;

//   late final NewsController _newsController = NewsController(url: url)
//     ..geturlinfo();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => _newsController.loading.value
//           ? const SizedBox(width: 270, child: LoadingWidget())
//           : InkWell(
//               onTap: () {
//                 Get.to(() => WebViewScreen(url: url));
//               },
//               splashColor: AppColors.kSplashColor,
//               child: SizedBox(
//                 width: 270,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _newsController.image != ''
//                         ? CachedNetworkImage(
//                             imageUrl: _newsController.image,
//                             height: 170,
//                             width: 270,
//                             fit: BoxFit.cover,
//                           )
//                         : Container(
//                             height: 170,
//                             width: 270,
//                             color: AppColors.cardGray,
//                           ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: Text(
//                         _newsController.title,
//                         style: MyTextTheme.mainheight(context),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     if (_newsController.authorName != "")
//                       Column(
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               ClipOval(
//                                 child: CachedNetworkImage(
//                                   imageUrl: _newsController.authorImage,
//                                   fit: BoxFit.cover,
//                                   width: 18,
//                                   height: 18,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 8,
//                               ),
//                               Text(
//                                 _newsController.authorName,
//                                 style: MyTextTheme.main(context),
//                               )
//                             ],
//                           ),
//                         ],
//                       )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

class NewsListWidget extends StatelessWidget {
  NewsListWidget(
      {Key? key, required this.issueList, this.title, this.isDark = false})
      : super(key: key);

  RxList<Issue> issueList;
  String? title;
  bool isDark;

  String _issueListTitle() {
    if (issueList is RxList<NewsIssue>) {
      return "회원님에게 지금 필요한 최신 NEWS";
    } else if (issueList is RxList<BrunchIssue>) {
      return "전문가들이 작성하는 관심 분야 정보";
    } else {
      return "내 관심 분야 트렌드, 유투브로 확인하기";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title ?? _issueListTitle(),
              style: MyTextTheme.mainbold(context)
                  .copyWith(color: isDark ? AppColors.mainWhite : null),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(() => KeepAliveWidget(
                      child:
                          NewsWidget(issue: issueList[index], isDark: isDark)));
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: issueList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class NewsController {
//   NewsController({required this.url});
//   late String description;
//   late String favicon;
//   late String icon;
//   late String image;
//   late String title;
//   late String authorImage;
//   late String authorName;
//   String url;
//   RxBool loading = true.obs;

//   Future geturlinfo() async {
//     final Map<String, String>? info = await NewsFetchPreview().fetch(url);
//     description = info != null ? info["description"] ?? "" : "";
//     icon = info != null ? info["appleIcon"] ?? "" : "";
//     image = info != null ? info["image"] ?? "" : "";
//     title = info != null ? info["title"] ?? "" : "";
//     favicon = info != null ? info["favIcon"] ?? "" : "";
//     authorImage = info != null ? info["authorImage"] ?? "" : "";
//     authorName = info != null ? info["authorName"] ?? "" : "";
//     loading(false);
//   }
// }

class NewsWidget extends StatelessWidget {
  NewsWidget({Key? key, required this.issue, this.isDark = false})
      : super(key: key);
  Issue issue;

  late final NewsController _newsController = NewsController(issue: issue)
    ..geturlinfo();

  bool isDark;

  Widget _authorImageView() {
    double size = 18;
    if (issue is NewsIssue) {
      issue = issue as NewsIssue;
      return SvgPicture.asset("assets/icons/news_default.svg");
    } else if (issue is BrunchIssue) {
      BrunchIssue brunchIssue = issue as BrunchIssue;
      return brunchIssue.profileImage == ""
          ? SvgPicture.asset("assets/icons/brunch_image.svg")
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: brunchIssue.profileImage,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorWidget: (context, string, widget) {
                  return Container(color: AppColors.maingray);
                },
              ),
            );
    } else {
      YoutubeIssue youtubeIssue = issue as YoutubeIssue;
      return youtubeIssue.chImage == ""
          ? Image.asset(
              "assets/illustrations/youtube_image.png",
              width: size,
              height: size,
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: youtubeIssue.chImage,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorWidget: (context, string, widget) {
                  return Container(color: AppColors.maingray);
                },
              ),
            );
    }
  }

  Widget _authorNameView(BuildContext context) {
    if (issue is NewsIssue) {
      NewsIssue newsIssue = issue as NewsIssue;
      return Text(
        newsIssue.corp,
        style: MyTextTheme.main(context)
            .copyWith(color: isDark ? AppColors.mainWhite : null),
        overflow: TextOverflow.ellipsis,
      );
    } else if (issue is BrunchIssue) {
      BrunchIssue brunchIssue = issue as BrunchIssue;
      return Text(
        brunchIssue.writer,
        style: MyTextTheme.main(context)
            .copyWith(color: isDark ? AppColors.mainWhite : null),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      YoutubeIssue youtubeIssue = issue as YoutubeIssue;
      return Text(
        youtubeIssue.chName,
        style: MyTextTheme.main(context)
            .copyWith(color: isDark ? AppColors.mainWhite : null),
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _newsController.loading.value
          ? const SizedBox(width: 270, child: LoadingWidget())
          : InkWell(
              onTap: () {
                Get.to(() => WebViewScreen(url: issue.url));
              },
              splashColor: AppColors.kSplashColor,
              child: SizedBox(
                width: 270,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    issue.image != ""
                        ? CachedNetworkImage(
                            imageUrl: issue.image,
                            height: 170,
                            width: 270,
                            fit: BoxFit.cover,
                            errorWidget: (context, string, widget) {
                              return Container(color: AppColors.maingray);
                            })
                        : Image.asset(
                            "assets/illustrations/link_noimage.png",
                            height: 170,
                            width: 270,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Text(
                        issue.title,
                        style: MyTextTheme.mainheight(context).copyWith(
                            color: isDark ? AppColors.mainWhite : null),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        _authorImageView(),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: _authorNameView(context))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class NewsController {
  NewsController({required this.issue});

  Issue issue;
  RxBool loading = true.obs;

  Future geturlinfo() async {
    await NewsFetchPreview().fetch(issue);

    loading(false);
  }
}
