import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/search_controller.dart';

import 'package:loopus/screen/careerboard_screen.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/scout_screen.dart';
import 'package:loopus/screen/search_screen.dart';

// ignore: use_key_in_widget_constructors
class App extends StatelessWidget {
  final AppController controller = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      // SearchScreen(),
      Navigator(
          key: controller.searcnPageNaviationKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => SearchScreen(),
            );
          }),
      Container(
        color: AppColors.mainblack.withOpacity(0.25),
      ),
      // Container(),
      ScoutScreen(),
      CareerBoardScreen(),
    ];

    return WillPopScope(
      onWillPop: controller.willPopAction,
      child: Scaffold(
        extendBody: false,
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: _screens,
          ),
        ),
        bottomNavigationBar: Obx(
          () => SafeArea(
            child: Container(
              height: Platform.isAndroid ? 56 : 48,
              decoration: BoxDecoration(
                // borderRadius: const BorderRadius.only(
                //   topRight: Radius.circular(20),
                //   topLeft: Radius.circular(20),
                // ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainblack.withOpacity(0.1),
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
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                //   bottomLeft: Radius.circular(0),
                //   bottomRight: Radius.circular(0),
                // ),
                child: BottomNavigationBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.currentIndex.value,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  enableFeedback: false,
                  onTap: controller.changeBottomNav,
                  items: [
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon:
                            SvgPicture.asset("assets/icons/home_inactive.svg"),
                        activeIcon:
                            SvgPicture.asset("assets/icons/home_active.svg"),
                        label: "???"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon: SvgPicture.asset(
                            "assets/icons/search_inactive.svg"),
                        activeIcon:
                            SvgPicture.asset("assets/icons/search_active.svg"),
                        label: "??????"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon: SvgPicture.asset(
                          "assets/icons/bottom_add.svg",
                        ),
                        label: "??????"),
                    BottomNavigationBarItem(
                        tooltip: '',
                        icon: SvgPicture.asset(
                          "assets/icons/scout_inactive.svg",
                        ),
                        activeIcon:
                            SvgPicture.asset("assets/icons/scout_active.svg"),
                        label: "???????????? ?????????"),
                    BottomNavigationBarItem(
                      tooltip: '',
                      icon:
                          SvgPicture.asset("assets/icons/career_inactive.svg"),
                      activeIcon:
                          SvgPicture.asset("assets/icons/career_active.svg"),
                      label: "????????? ??????",
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
