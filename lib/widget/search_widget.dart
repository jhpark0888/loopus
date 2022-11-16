import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/search_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class SearchUserWidget extends StatelessWidget {
  SearchUserWidget({Key? key, required this.user}) : super(key: key);

  User user;

  void _addRecSearch(SearchType searchType) {
    addRecentSearch(searchType.index, user.userId.toString()).then((value) {
      if (value.isError == false && value.data != null) {
        RecentSearch tempRecentSearch = RecentSearch.fromJson(value.data);
        SearchController.to.recentSearchList.insert(0, tempRecentSearch);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.userType == UserType.student) {
          _addRecSearch(SearchType.profile);
          Get.to(
              () => OtherProfileScreen(
                  user: user as Person,
                  userid: user.userId,
                  realname: user.name),
              preventDuplicates: false);
        } else {
          _addRecSearch(SearchType.company);
          Get.to(
              () => OtherCompanyScreen(
                    company: user as Company,
                    companyId: user.userId,
                    companyName: user.name,
                  ),
              preventDuplicates: false);
        }
      },
      behavior: HitTestBehavior.translucent,
      // splashColor: AppColors.kSplashColor,
      child: Row(
        children: [
          const SizedBox(width: 16),
          UserImageWidget(
            imageUrl: user.profileImage,
            width: 36,
            height: 36,
            userType: user.userType,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: MyTextTheme.mainbold(context)),
              const SizedBox(height: 4),
              user.userType == UserType.student
                  ? Text(
                      '${(user as Person).univName} · ${(user as Person).department}',
                      style: MyTextTheme.main(context))
                  : Text(
                      "${fieldList[(user as Company).fieldId]} · ${(user as Company).address}",
                      style: MyTextTheme.main(context),
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class SearchTagWidget extends StatelessWidget {
  SearchTagWidget({Key? key, required this.tag}) : super(key: key);

  Tag tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(),
      // splashColor: AppColors.kSplashColor,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Tagwidget(
              tag: tag,
              isonTap: true,
              isAddRecentSearch: true,
            ),
            const Spacer(),
            Text(
              '${tag.count}회',
              style: MyTextTheme.main(context),
            )
          ],
        ),
      ),
    );
  }

  void _onTap() {
    addRecentSearch(SearchType.tag.index, tag.tagId.toString()).then((value) {
      if (value.isError == false && value.data != null) {
        RecentSearch tempRecentSearch = RecentSearch.fromJson(value.data);
        SearchController.to.recentSearchList.insert(0, tempRecentSearch);
      }
    });
    Get.to(() => TagDetailScreen(
          tag: tag,
        ));
  }
}

class RecentSearchWidget extends StatelessWidget {
  RecentSearchWidget({Key? key, required this.recentSearch}) : super(key: key);

  final SearchController _controller = Get.find();
  RecentSearch recentSearch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      behavior: HitTestBehavior.translucent,
      // splashColor: AppColors.kSplashColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 3),
        child: Row(
          children: [
            _imageView(),
            const SizedBox(width: 8),
            _textView(context),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                await deleteResentSearch("one", recentSearch.id).then((value) {
                  if (value.isError == false) {
                    _controller.recentSearchList.remove(recentSearch);
                  }
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                child: SvgPicture.asset(
                  "assets/icons/widget_delete.svg",
                  color: AppColors.iconcolor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageView() {
    return recentSearch.searchType == SearchType.profile
        ? UserImageWidget(
            imageUrl: (recentSearch.data as Person).profileImage,
            width: 36,
            height: 36,
            userType: UserType.student)
        : recentSearch.searchType == SearchType.post
            ? Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(11),
                child: SvgPicture.asset(
                  "assets/icons/search_inactive.svg",
                  width: 13,
                  height: 13,
                  color: AppColors.mainblack,
                ))
            : recentSearch.searchType == SearchType.tag
                ? SvgPicture.asset(
                    "assets/icons/tag_icon.svg",
                    color: AppColors.mainblack,
                  )
                : UserImageWidget(
                    imageUrl: (recentSearch.data as Company).profileImage,
                    width: 36,
                    height: 36,
                    userType: UserType.company);
  }

  Widget _textView(BuildContext context) {
    return recentSearch.searchType == SearchType.profile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (recentSearch.data as Person).name,
                style: MyTextTheme.mainbold(context),
              ),
              const SizedBox(height: 4),
              Text(
                "${(recentSearch.data as Person).univName} · ${(recentSearch.data as Person).department}",
                style: MyTextTheme.main(context),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : recentSearch.searchType == SearchType.post
            ? Text(recentSearch.data as String)
            : recentSearch.searchType == SearchType.tag
                ? Text(
                    (recentSearch.data as Tag).tag,
                    style: MyTextTheme.main(context),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (recentSearch.data as Company).name,
                        style: MyTextTheme.mainbold(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${fieldList[(recentSearch.data as Company).fieldId]} · ${(recentSearch.data as Company).address}",
                        style: MyTextTheme.main(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
  }

  void _onTap(BuildContext context) {
    if (recentSearch.searchType == SearchType.profile) {
      Get.to(
          () => OtherProfileScreen(
              user: (recentSearch.data as Person),
              userid: (recentSearch.data as Person).userId,
              realname: (recentSearch.data as Person).name),
          preventDuplicates: false);
    } else if (recentSearch.searchType == SearchType.post) {
      _controller.searchtextcontroller.text = recentSearch.data as String;
      _controller.tabController.index = 1;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchFocusScreen()));
    } else if (recentSearch.searchType == SearchType.tag) {
      Get.to(() => TagDetailScreen(
            tag: recentSearch.data as Tag,
          ));
    } else if (recentSearch.searchType == SearchType.company) {
      Get.to(
          () => OtherCompanyScreen(
                company: (recentSearch.data as Company),
                companyId: (recentSearch.data as Company).userId,
                companyName: (recentSearch.data as Company).name,
              ),
          preventDuplicates: false);
    }
  }
}
