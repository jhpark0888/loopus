import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:underline_indicator/underline_indicator.dart';

class TabBarWidget extends StatelessWidget {
  TabBarWidget({Key? key, required this.tabController, required this.tabs})
      : super(key: key);

  TabController tabController;
  List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: maingray, width: 2.0),
                ),
              ),
            ),
            TabBar(
                controller: tabController,
                labelStyle: kmainbold,
                labelColor: mainblack,
                unselectedLabelStyle: kmainbold.copyWith(color: dividegray),
                unselectedLabelColor: dividegray,
                automaticIndicatorColorAdjustment: false,
                indicator: const UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(width: 2, color: mainblack),
                ),
                isScrollable: false,
                tabs: tabs),
          ],
        ),
      ],
    );
  }
}
