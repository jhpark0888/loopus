import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';

class CareerTile extends StatelessWidget {
  CareerTile(
      {Key? key,
      required this.title,
      required this.time,
      required this.index,
      required this.currentPage})
      : super(key: key);
  RxString title;
  final DateTime time;
  int index;
  RxDouble currentPage;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
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
                style: kmainbold.copyWith(
                    fontWeight: currentPage.value.toInt() == index
                        ? FontWeight.w600
                        : FontWeight.w400),
              ),
              const Spacer(),
              Text(
                DateFormat('yyyy.MM').format(time),
                style: kmain.copyWith(color: maingray),
              )
            ],
          ),
        ],
      ),
    );
  }
}
