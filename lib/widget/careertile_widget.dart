import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';

class CareerTile extends StatelessWidget {
  CareerTile(
      {Key? key, required this.title, required this.time, required this.index})
      : super(key: key);
  RxString title;
  final DateTime time;
  int index;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          ProfileController.to.careerCurrentPage.value = index.toDouble();
          ProfileController.to.careertitleController.jumpToPage(
            index,
            // duration: const Duration(milliseconds: 300), curve: Curves.ease
          );
          ProfileController.to.careerPageController.jumpToPage(
            index,
            // duration: const Duration(milliseconds: 300), curve: Curves.ease
          );
        },
        child: Column(
          children: [
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: colorgroup[index])),
                const SizedBox(width: 12),
                Text(
                  title.value,
                  style: k15normal.copyWith(
                      fontWeight: ProfileController.to.careerCurrentPage.value
                                  .toInt() ==
                              index
                          ? FontWeight.w600
                          : FontWeight.w400),
                ),
                const Spacer(),
                Text(
                  DateFormat('yyyy.MM').format(time),
                  style: k15normal.copyWith(color: mainblack.withOpacity(0.5)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}