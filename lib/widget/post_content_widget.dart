import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/smarttextfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostContentWidget extends StatelessWidget {
  PostContentWidget({Key? key, required this.content}) : super(key: key);

  PostContent content;

  @override
  Widget build(BuildContext context) {
    if (SmartTextType.values[content.type] == SmartTextType.IMAGE) {
      return Container(child: Image.network(content.content));
    } else if (SmartTextType.values[content.type] == SmartTextType.LINK) {
      return Padding(
        padding: SmartTextType.values[content.type].padding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
              onTap: () {
                Get.to(() => WebViewScreen(url: content.url));
              },
              child: Text(
                '${SmartTextType.values[content.type].prefix ?? ''}${content.content}',
                textAlign: SmartTextType.values[content.type].align,
                style: SmartTextType.values[content.type].textStyle,
              )),
        ),
      );
    } else {
      return Container(
        padding: SmartTextType.values[content.type].padding,
        width: Get.width,
        child: Text(
          '${SmartTextType.values[content.type].prefix ?? ''}${content.content}',
          textAlign: SmartTextType.values[content.type].align,
          style: SmartTextType.values[content.type].textStyle,
        ),
      );
    }
  }
}
