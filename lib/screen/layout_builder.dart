import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';

class Testscreen extends StatelessWidget {
  Testscreen({Key? key, required this.onChanged}) : super(key: key);
  late PostingAddController postingAddController =
      Get.put(PostingAddController(route: PostaddRoute.bottom));
  dynamic Function(String)? onChanged;    
  TextDirection? direction = TextDirection.ltr;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return NoUlTextField(
        controller: postingAddController.textcontroller,
        obscureText: false,
        onChanged: (string) {
          TextSpan span = TextSpan(
              text: postingAddController.textcontroller.text, style: kmain);       
          TextPainter tp = TextPainter(text: span, textDirection: direction);
          tp.layout(maxWidth: Get.width - 40);
          int numLines = tp.computeLineMetrics().length;
          postingAddController.lines.value = '\n'.allMatches(string).length + 1;
          print(span.text);
          if (postingAddController.lines.value == 7) {
            postingAddController.keyControllerAtive.value = true;
          }
          print(tp.computeLineMetrics());
        },
        hintText: '내용을 입력해주세요',
      );
    });
  }
}
