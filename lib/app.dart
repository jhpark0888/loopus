import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/paper_screen.dart';
import 'package:loopus/screen/profile_screen.dart';
import 'package:loopus/screen/search_screen.dart';

class App extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        switch (RouteName.values[controller.currentIndex.value]) {
          case RouteName.Home:
            return HomeScreen();
          case RouteName.Search:
            return SearchScreen();
          case RouteName.Paper:
            return PaperScreen();
          case RouteName.Bookmark:
            return BookmarkScreen();
          case RouteName.Profile:
            return ProfileScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: mainblack.withOpacity(0.1),
                blurRadius: 1,
                offset: Offset(
                  0.0,
                  -1.0,
                ),
              ),
            ],
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: Container(
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: mainWhite,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.currentIndex.value,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  enableFeedback: false,
                  onTap: controller.changePageIndex,
                  items: [
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon:
                            SvgPicture.asset("assets/icons/Home_Inactive.svg"),
                        activeIcon:
                            SvgPicture.asset("assets/icons/Home_Active.svg"),
                        label: "홈"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon: SvgPicture.asset(
                            "assets/icons/Search_Inactive.svg"),
                        activeIcon:
                            SvgPicture.asset("assets/icons/Search_Active.svg"),
                        label: "검색"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon:
                            SvgPicture.asset("assets/icons/Paper_Inactive.svg"),
                        activeIcon:
                            SvgPicture.asset("assets/icons/Paper_Active.svg"),
                        label: "공고"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon: SvgPicture.asset(
                            "assets/icons/Bookmark_Inactive.svg"),
                        activeIcon: SvgPicture.asset(
                            "assets/icons/Bookmark_Active.svg"),
                        label: "북마크"),
                    BottomNavigationBarItem(
                      tooltip: '',
                      icon:
                          SvgPicture.asset("assets/icons/Profile_Inactive.svg"),
                      activeIcon:
                          SvgPicture.asset("assets/icons/Profile_Active.svg"),
                      label: "프로필",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
