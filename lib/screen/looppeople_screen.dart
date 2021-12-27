// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/inquiry_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class LoopPeopleScreen extends StatelessWidget {
  LoopPeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '루프 6명',
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 32,
          ),
          child: ListView(
            children: [
              PersonTileWidget(
                name: '손승태',
                department: '산업경영공학과',
              ),
              PersonTileWidget(
                name: '용길한',
                department: '산업경영공학과',
              ),
              PersonTileWidget(
                name: '조연성',
                department: '산업경영공학과',
              ),
            ],
          ),
        ));
  }
}
