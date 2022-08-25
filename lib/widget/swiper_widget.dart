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

enum SwiperType { image, link, file }

// class SwiperWidget extends StatefulWidget {
//   SwiperWidget(
//       {Key? key,
//       required this.items,
//       required this.swiperType,
//       this.aspectRatio = 1})
//       : super(key: key);
//   List items;
//   SwiperType swiperType;
//   double aspectRatio;

//   @override
//   State<SwiperWidget> createState() => _SwiperWidgetState();
// }

// class _SwiperWidgetState extends State<SwiperWidget>
//     with SingleTickerProviderStateMixin {
//   final PageController _pageController = PageController();
//   late TransformationController transformationController;
//   late AnimationController animationController;
//   Animation<Matrix4>? animation;
//   final double minScale = 1;
//   final double maxScale = 4;
//   double scale = 1;
//   OverlayEntry? entry;

//   @override
//   void initState() {
//     super.initState();

//     transformationController = TransformationController();
//     animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200))
//       ..addListener(() => transformationController.value = animation!.value)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           removeOverlay();
//         }
//       });

//     print("initState");
//   }

//   @override
//   void didChangeDependencies() async {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     print("didChangeDependencies");
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       getSizeAndPosition();
//     });
//   }

//   @override
//   void deactivate() {
//     // TODO: implement deactivate
//     super.deactivate();
//     print("deactive");
//   }

//   @override
//   void dispose() {
//     transformationController.dispose();
//     animationController.dispose();

//     super.dispose();
//   }

//   getSizeAndPosition() async {
//     print("getSizeAndPosition");
//     Image? image;
//     if (widget.items[0].runtimeType == String) {
//       image = Image(image: NetworkImage(widget.items[0]));
//     } else if (widget.items[0].runtimeType == File) {
//       image = Image(image: FileImage(widget.items[0]));
//     }
//     print(image);
//     if (image != null) {
//       Completer<ui.Image> completer = Completer<ui.Image>();
//       image.image
//           .resolve(ImageConfiguration())
//           .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
//         completer.complete(imageInfo.image);
//       }));

//       ui.Image info = await completer.future;
//       int width = info.width;
//       int height = info.height;
//       widget.aspectRatio = width / height;
//       print(widget.aspectRatio);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("build");
//     return Column(
//       children: [
//         AspectRatio(
//           aspectRatio: widget.swiperType == SwiperType.link
//               ? Get.width / 300
//               : widget.aspectRatio,
//           child: Container(
//               decoration: const BoxDecoration(
//                 color: mainblack,
//                 border: Border.symmetric(
//                   horizontal: BorderSide(color: mainWhite),
//                 ),
//               ),
//               // width: Get.width,
//               // height: widget.swiperType == SwiperType.link ? 300 : Get.width,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (widget.swiperType == SwiperType.image) {
//                     return buildImageList(index);
//                   } else if (widget.swiperType == SwiperType.link) {
//                     return KeepAlivePage(
//                       child: LinkWidget(
//                           url: widget.items[index], widgetType: 'post'),
//                     );
//                   } else {
//                     return Image.file(widget.items[index], fit: BoxFit.contain);
//                   }
//                 },
//                 itemCount: widget.items.length,
//               )),
//         ),
//         const SizedBox(
//           height: 14,
//         ),
//         if (widget.items.length > 1)
//           Column(
//             children: [
//               PageIndicator(
//                 size: 7,
//                 activeSize: 7,
//                 space: 7,
//                 color: maingray,
//                 activeColor: mainblue,
//                 count: widget.items.length,
//                 controller: _pageController,
//                 layout: PageIndicatorLayout.SLIDE,
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget buildImageList(int index) {
//     return Builder(
//       builder: (context) => InteractiveViewer(
//         transformationController: transformationController,
//         clipBehavior: Clip.none,
//         panEnabled: false,
//         onInteractionStart: (details) {
//           if (details.pointerCount < 2) return;

//           if (entry == null) {
//             showOverlay(context, index);
//           }
//         },
//         onInteractionUpdate: (details) {
//           if (entry == null) return;

//           scale = details.scale;
//           entry!.markNeedsBuild();
//         },
//         onInteractionEnd: (details) {
//           resetAnimation();
//         },
//         minScale: minScale,
//         maxScale: maxScale,
//         child: CachedNetworkImage(
//           imageUrl: widget.items[index],
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }

//   void resetAnimation() {
//     animation = Matrix4Tween(
//       begin: transformationController.value,
//       end: Matrix4.identity(),
//     ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));

//     animationController.forward(from: 0);
//   }

//   void showOverlay(BuildContext context, int index) {
//     final renderBox = context.findRenderObject()! as RenderBox;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final size = MediaQuery.of(context).size;

//     entry = OverlayEntry(builder: (context) {
//       // final opacity = ((scale - 1) / (maxScale - 1)).clamp(0, 0.3) as double;

//       return Stack(
//         children: [
//           Positioned.fill(
//               child: Opacity(
//             opacity: 0.3,
//             child: Container(color: mainblack),
//           )),
//           Positioned(
//               left: offset.dx,
//               top: offset.dy,
//               width: size.width,
//               child: buildImageList(index)),
//         ],
//       );
//     });

//     final overlay = Overlay.of(context)!;
//     overlay.insert(entry!);
//   }

//   void removeOverlay() {
//     entry?.remove();
//     entry = null;
//   }
// }

class SwiperWidget extends StatelessWidget {
  SwiperWidget(
      {Key? key,
      required this.items,
      required this.swiperType,
      this.aspectRatio, child})
      : super(key: key);
  List items;
  SwiperType swiperType;
  double? aspectRatio;
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
              height: 300,
              decoration: const BoxDecoration(
                color: mainblack,
                border: Border.symmetric(
                  horizontal: BorderSide(color: mainWhite),
                ),
              ),
              // width: Get.width,
              // height: widget.swiperType == SwiperType.link ? 300 : Get.width,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return KeepAlivePage(
                    child: LinkWidget(url: items[index], widgetType: 'post'),
                  );
                },
                itemCount: items.length,
              ))
        else
          AspectRatio(
            aspectRatio: aspectRatio ?? 1,
            child: Container(
                decoration: const BoxDecoration(
                  color: mainblack,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: mainWhite),
                  ),
                ),
                // width: Get.width,
                // height: widget.swiperType == SwiperType.link ? 300 : Get.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    if (swiperType == SwiperType.image) {
                      return CachedNetworkImage(
                        imageUrl: items[index],
                        fit: BoxFit.contain,
                      );
                    } else {
                      return Image.file(items[index], fit: BoxFit.contain);
                    }
                  },
                  itemCount: items.length,
                )),
          ),
        const SizedBox(
          height: 14,
        ),
        if (items.length > 1)
          Column(
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: items.length,
                effect: ScrollingDotsEffect(
                  dotColor: maingray,
                  activeDotColor: mainblue,
                  spacing: 7,
                  dotWidth: 7,
                  dotHeight: 7,
                ),
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
