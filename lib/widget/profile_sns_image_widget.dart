import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileSnsImageWidget extends StatelessWidget {
  ProfileSnsImageWidget({
    Key? key,
    required this.sns,
  }) : super(key: key);

  SNS sns;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(sns.url),
      child: Image.asset(
        "assets/illustrations/${sns.snsType.name}_image.png",
        // fit: BoxFit.cover,
        width: 28,
        height: 28,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    // loading();
    // if (await canLaunchUrlString(url)) {
    //   Get.back();
    try {
      launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        launchUrlString(
          url,
        );
      } catch (e) {
        showCustomDialog("존재하지 않는 URL입니다.", 1000);
      }
    }

    // } else {
    //   Get.back();
    //   print(sns.url);
    //   showCustomDialog("존재하지 않는 URL입니다.", 1000);
    // }
  }
}
