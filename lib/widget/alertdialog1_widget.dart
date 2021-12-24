import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class Alertdialog1Widget extends StatelessWidget {
  var color_1;
  String? text_1;
  Function() function_1;
  Alertdialog1Widget({this.color_1, this.text_1, required this.function_1});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        // contentPadding: EdgeInsets.zero,
        elevation: 0.0,
        // title: Center(child: Text("Evaluation our APP")),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: Get.width * 0.95,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        print("click");
                      },
                      child: (Container(
                          width: Get.width * 0.95,
                          height: 30,
                          child: Center(
                              child: Text(
                            text_1!,
                            style: TextStyle(
                                color: color_1 ?? mainblack,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Center(
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: (Container(
                        width: Get.width * 0.95,
                        height: 30,
                        child: Center(
                            child: Text(
                          "닫기",
                          style: TextStyle(fontSize: 14),
                        ))))),
              ),
            )
          ],
        ));
  }
}
