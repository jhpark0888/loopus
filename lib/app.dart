import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/company_screen.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/search_screen.dart';

import 'screen/example_screen.dart';

// ignore: use_key_in_widget_constructors
class App extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      SearchScreen(),
      Container(
        color: mainblack.withOpacity(0.25),
      ),
      CompanyScreen(),
      MyProfileScreen(),
    ];

    return Scaffold(
      extendBody: false,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: mainblack.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(
                  0.0,
                  -1.0,
                ),
              ),
            ],
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
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
                    icon: SvgPicture.asset("assets/icons/Home_Inactive.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/icons/Home_Active.svg"),
                    label: "홈"),
                BottomNavigationBarItem(
                    tooltip: '',
                    icon: SvgPicture.asset("assets/icons/Search_Inactive.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/icons/Search_Active.svg"),
                    label: "검색"),
                BottomNavigationBarItem(
                    tooltip: '',
                    icon: SvgPicture.asset("assets/icons/Plus_inactive.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/icons/Plus_active.svg"),
                    label: "기업"),
                BottomNavigationBarItem(
                    tooltip: '',
                    icon: SvgPicture.asset("assets/icons/Paper_Inactive.svg"),
                    activeIcon:
                        SvgPicture.asset("assets/icons/Paper_Active.svg"),
                    label: "공고"),
                BottomNavigationBarItem(
                  tooltip: '',
                  icon: SvgPicture.asset("assets/icons/Profile_Inactive.svg"),
                  activeIcon:
                      SvgPicture.asset("assets/icons/Profile_Active.svg"),
                  label: "프로필",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
