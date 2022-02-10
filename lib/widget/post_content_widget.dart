import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/smarttextfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constant.dart';

class PostContentWidget extends StatelessWidget {
  PostContentWidget({Key? key, required this.content}) : super(key: key);

  PostContent content;

  String validateUrl() {
    var url = content.url;
    if (content.url!.contains('https://') == false &&
        content.url!.contains('http://') == false) {
      url = 'https://' + content.url!;
    }

    return url!;
  }

  @override
  Widget build(BuildContext context) {
    if (content.type == SmartTextType.IMAGE) {
      return Align(
        alignment: content.type.imageAlign,
        child: Padding(
          padding: content.type.padding,
          child: FadeInImage.assetNetwork(
              placeholder: 'assets/icons/loading.gif', image: content.content),
        ),
      );
    } else if (content.type == SmartTextType.LINK) {
      return Padding(
        padding: content.type.padding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
              onTap: () {
                Get.to(() => WebViewScreen(url: validateUrl()));
              },
              child: Text(
                '${content.type.prefix ?? ''}${content.content}',
                textAlign: content.type.align,
                style: content.type.textStyle,
              )),
        ),
      );
    } else {
      return Container(
        padding: content.type.padding,
        width: Get.width,
        child: Text(
          '${content.type.prefix ?? ''}${content.content}',
          textAlign: content.type.align,
          style: content.type.textStyle,
        ),
      );
    }
  }
}
