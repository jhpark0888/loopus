import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class SwiperWidget extends StatelessWidget {
  SwiperWidget({ Key? key, required this.item, required this.height, required this.itembuilder}) : super(key: key);
  List item;
  double height;
  Widget Function(BuildContext, int)? itembuilder;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                width: Get.width,
                height: height,
                child: Swiper(
                  outer: true,
                  itemCount: item.length,
                  itemBuilder: itembuilder,
                  pagination: SwiperPagination(
                      margin: EdgeInsets.all(14),
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                          color: Color(0xFF5A5A5A).withOpacity(0.5),
                          activeColor: mainblue,
                          size: 7,
                          activeSize: 7)),
                ));
  }
}