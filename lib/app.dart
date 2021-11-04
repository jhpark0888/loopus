import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/profile_screen.dart';
import 'package:loopus/screen/search_screen.dart';

class App extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (RouteName.values[controller.currentIndex.value]) {
          case RouteName.Home:
            return HomeScreen();
          case RouteName.Search:
            return SearchScreen();
          case RouteName.Bookmark:
            return BookmarkScreen();
          case RouteName.Profile:
            return ProfileScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: mainWhite,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          showSelectedLabels: true,
          selectedItemColor: mainFontDark,
          onTap: controller.changePageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 23,
                  color: lightGray,
                ),
                activeIcon: Icon(
                  Icons.home,
                  size: 23,
                  color: mainFontDark,
                ),
                label: "홈"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 23,
                  color: lightGray,
                ),
                activeIcon: Icon(
                  Icons.search,
                  size: 23,
                  color: mainFontDark,
                ),
                label: "검색"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_border_outlined,
                  size: 23,
                  color: lightGray,
                ),
                activeIcon: Icon(
                  Icons.bookmark,
                  size: 23,
                  color: mainFontDark,
                ),
                label: "북마크"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                  size: 23,
                  color: lightGray,
                ),
                activeIcon: Icon(
                  Icons.account_circle_rounded,
                  size: 23,
                  color: mainFontDark,
                ),
                label: "프로필"),
          ],
        ),
      ),
    );
  }
}
