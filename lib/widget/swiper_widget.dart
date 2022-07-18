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

class SwiperWidget extends StatefulWidget {
  SwiperWidget({Key? key, required this.items, required this.swiperType})
      : super(key: key);
  List items;
  SwiperType swiperType;

  @override
  State<SwiperWidget> createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TransformationController transformationController;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;
  double scale = 1;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();

    transformationController = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() => transformationController.value = animation!.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverlay();
        }
      });
  }

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
              color: mainblack,
              border: Border.symmetric(
                horizontal: BorderSide(color: mainWhite),
              ),
            ),
            constraints: BoxConstraints(
                maxWidth: Get.width,
                maxHeight:
                    widget.swiperType != SwiperType.link ? Get.width : 300),
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                if (widget.swiperType == SwiperType.image) {
                  return buildImageList(index);
                } else if (widget.swiperType == SwiperType.link) {
                  return KeepAlivePage(
                    child: LinkWidget(
                        url: widget.items[index], widgetType: 'post'),
                  );
                } else {
                  return Image.file(widget.items[index], fit: BoxFit.contain);
                }
              },
              itemCount: widget.items.length,
            )),
        const SizedBox(
          height: 14,
        ),
        if (widget.items.length > 1)
          Column(
            children: [
              PageIndicator(
                size: 7,
                activeSize: 7,
                space: 7,
                color: maingray,
                activeColor: mainblue,
                count: widget.items.length,
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

  Widget buildImageList(int index) {
    return Builder(
      builder: (context) => InteractiveViewer(
        transformationController: transformationController,
        clipBehavior: Clip.none,
        panEnabled: false,
        onInteractionStart: (details) {
          if (details.pointerCount < 2) return;

          if (entry == null) {
            showOverlay(context, index);
          }
        },
        onInteractionUpdate: (details) {
          if (entry == null) return;

          scale = details.scale;
          entry!.markNeedsBuild();
        },
        onInteractionEnd: (details) {
          resetAnimation();
        },
        minScale: minScale,
        maxScale: maxScale,
        child: CachedNetworkImage(
          imageUrl: widget.items[index],
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));

    animationController.forward(from: 0);
  }

  void showOverlay(BuildContext context, int index) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;

    entry = OverlayEntry(builder: (context) {
      // final opacity = ((scale - 1) / (maxScale - 1)).clamp(0, 0.3) as double;

      return Stack(
        children: [
          Positioned.fill(
              child: Opacity(
            opacity: 0.3,
            child: Container(color: mainblack),
          )),
          Positioned(
              left: offset.dx,
              top: offset.dy,
              width: size.width,
              child: buildImageList(index)),
        ],
      );
    });

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }
}

// class SwiperWidget extends StatelessWidget {
//   SwiperWidget({Key? key, required this.items, required this.swiperType})
//       : super(key: key);
//   List items;
//   SwiperType swiperType;

//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//             decoration: const BoxDecoration(
//                 color: mainWhite,
//                 border:
//                     Border.symmetric(horizontal: BorderSide(color: mainWhite))),
//             constraints: BoxConstraints(
//                 maxWidth: Get.width,
//                 maxHeight: swiperType != SwiperType.link ? Get.width : 300),
//             child: PageView.builder(
//               controller: _pageController,
//               itemBuilder: (BuildContext context, int index) {
//                 if (swiperType == SwiperType.image) {
//                   return InteractiveViewer(
//                     clipBehavior: Clip.none,
//                     panEnabled: false,
//                     onInteractionEnd: (details) {
//                       resetAnimation();
//                     },
//                     minScale: 1,
//                     maxScale: 4,
//                     child: CachedNetworkImage(
//                       imageUrl: items[index],
//                       fit: BoxFit.contain,
//                     ),
//                   );
//                 } else if (swiperType == SwiperType.link) {
//                   return KeepAlivePage(
//                     child: LinkWidget(url: items[index], widgetType: 'post'),
//                   );
//                 } else {
//                   return Image.file(items[index], fit: BoxFit.contain);
//                 }
//               },
//               itemCount: items.length,
//             )),
//         const SizedBox(
//           height: 14,
//         ),
//         if (items.length > 1)
//           Column(
//             children: [
//               PageIndicator(
//                 size: 7,
//                 activeSize: 7,
//                 space: 7,
//                 color: maingray,
//                 activeColor: mainblue,
//                 count: items.length,
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

  
// }