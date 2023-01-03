import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/Link_widget.dart';

import 'dart:ui' as ui;

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

enum SwiperType { image, link, file }

class SwiperWidget extends StatelessWidget {
  SwiperWidget({
    Key? key,
    required this.items,
    required this.swiperType,
    this.aspectRatio,
    this.isAdd = false,
  }) : super(key: key);
  List items;
  SwiperType swiperType;
  double? aspectRatio;
  bool isAdd;
  // late ImageSizeController imageSizeController = ImageSizeController(
  //     item: items[0], aspectRatio: aspectRatio.obs)
  //     ..getSizeAndPosition();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (swiperType == SwiperType.link)
          Container(
              height: 270,
              decoration: const BoxDecoration(
                color: AppColors.mainblack,
                border: Border.symmetric(
                  horizontal: BorderSide(color: AppColors.mainWhite),
                ),
              ),
              // width: Get.width,
              // height: widget.swiperType == SwiperType.link ? 300 : Get.width,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return KeepAliveWidget(
                    child: LinkWidget(
                      url: items[index],
                      widgetType: 'post',
                    ),
                  );
                },
                itemCount: items.length,
              ))
        else
          AspectRatio(
            aspectRatio: aspectRatio ?? 1,
            child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.mainblack,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: AppColors.mainWhite),
                  ),
                ),
                // width: Get.width,
                // height: widget.swiperType == SwiperType.link ? 300 : Get.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    if (swiperType == SwiperType.image) {
                      return ZoomOverlay(
                        minScale: 0.5, // optional
                        maxScale: 3.0, // optional
                        twoTouchOnly: true,
                        animationDuration: Duration(milliseconds: 300),
                        child: CachedNetworkImage(
                          imageUrl: items[index],
                          fit: BoxFit.contain,
                        ),
                      );
                    } else {
                      return Image.file(items[index], fit: BoxFit.contain);
                    }
                  },
                  itemCount: items.length,
                )),
          ),
        if (items.length > 1)
          Column(
            children: [
              SizedBox(
                height: isAdd ? 14.5 : 10,
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: items.length,
                effect: ScrollingDotsEffect(
                  dotColor: AppColors.maingray,
                  activeDotColor: AppColors.mainblue,
                  spacing: 8,
                  dotWidth: 7,
                  dotHeight: 7,
                ),
              ),
            ],
          ),
        SizedBox(
          height: isAdd ? 14.5 : 10,
        ),
      ],
    );
  }
}

// class ImageSizeController {
//   ImageSizeController({
//     required this.item,
//     required this.aspectRatio,
//   });
//   dynamic item;
//   RxDouble aspectRatio;

//   getSizeAndPosition() async {
//     print("getSizeAndPosition");
//     Image? image;
//     if (item.runtimeType == String) {
//       image = Image(image: NetworkImage(item));
//     } else if (item.runtimeType == File) {
//       image = Image(image: FileImage(item));
//     }
//     print(image);

//     if (image != null) {
//       Completer<ui.Image> completer = Completer<ui.Image>();
//       image.image
//           .resolve(ImageConfiguration())
//           .addListener(ImageStreamListener((ImageInfo image, bool _) {
//         completer.complete(image.image);
//       }));

//       ui.Image info = await completer.future;
//       int width = info.width;
//       int height = info.height;
//       aspectRatio.value = width / height;
//     }
//   }
// }
