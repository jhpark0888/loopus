import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/loading_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: mainblack.withOpacity(0.3),
      child: const LoadingWidget(),
    );
  }
}

void loading() {
  Get.to(() => const LoadingScreen(), opaque: false);
}
