import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/screen/webview_screen.dart';

class ProfileSnsImageWidget extends StatelessWidget {
  ProfileSnsImageWidget({
    Key? key,
    required this.sns,
  }) : super(key: key);

  SNS sns;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => WebViewScreen(url: sns.url));
      },
      child: Image.asset(
        "assets/illustrations/${sns.snsType.name}_image.png",
        // fit: BoxFit.cover,
        width: 28,
        height: 28,
      ),
    );
  }
}
