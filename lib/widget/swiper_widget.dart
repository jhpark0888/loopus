import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/Link_widget.dart';

// class SwiperWidget extends StatelessWidget {
//   SwiperWidget({ Key? key, required this.item, required this.height, required this.itembuilder}) : super(key: key);
//   List item;
//   double height;
//   Widget Function(BuildContext, int)? itembuilder;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//                 width: Get.width,
//                 height: height,
//                 child: Swiper(
//                   outer: true,
//                   itemCount: item.length,
//                   itemBuilder: itembuilder,
//                   pagination: SwiperPagination(
//                       margin: EdgeInsets.all(14),
//                       alignment: Alignment.bottomCenter,
//                       builder: DotSwiperPaginationBuilder(
//                           color: Color(0xFF5A5A5A).withOpacity(0.5),
//                           activeColor: mainblue,
//                           size: 7,
//                           activeSize: 7)),
//                 ));
//   }
// }
enum SwiperType { image, link, file }

class SwiperWidget extends StatelessWidget {
  SwiperWidget({Key? key, required this.items, required this.swiperType})
      : super(key: key);
  List items;
  SwiperType swiperType;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: mainWhite,
                border:
                    Border.symmetric(horizontal: BorderSide(color: mainWhite))),
            constraints: BoxConstraints(
                maxWidth: Get.width,
                maxHeight: swiperType != SwiperType.link ? Get.width : 300),
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                if (swiperType == SwiperType.image) {
                  return CachedNetworkImage(
                    imageUrl: items[index],
                    fit: BoxFit.contain,
                  );
                } else if (swiperType == SwiperType.link) {
                  return KeepAlivePage(
                    child: LinkWidget(url: items[index], widgetType: 'post'),
                  );
                } else {
                  return Image.file(items[index], fit: BoxFit.contain);
                }
              },
              itemCount: items.length,
            )),
        const SizedBox(
          height: 14,
        ),
        if (items.length > 1)
          Column(
            children: [
              PageIndicator(
                size: 7,
                activeSize: 7,
                space: 7,
                color: maingray,
                activeColor: mainblue,
                count: items.length,
                controller: _pageController,
                layout: PageIndicatorLayout.SLIDE,
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
      ],
    );
  }
}
