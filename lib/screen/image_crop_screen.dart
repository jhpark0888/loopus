import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageCropScreen extends StatelessWidget {
  ImageCropScreen({Key? key, required this.assetEntity}) : super(key: key);
  PostingAddController controller = Get.find();

  // File image;
  GlobalKey<CustomCropState> cropKey = GlobalKey();

  AssetEntity assetEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12.5, 12.5, 0, 0),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Text(
                  "취소",
                  style: kNavigationTitle,
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.5),
              child: GestureDetector(
                  onTap: () => _cropImage(context),
                  child: Text(
                    "완료",
                    style: kNavigationTitle.copyWith(color: mainblue),
                  )),
            ),
          ],
        ),
        body: Center(
            child: _photoWidget(assetEntity, 1000, 1000, builder: (data) {
          return CustomCrop(
            image: Image.memory(data).image,
            key: cropKey,
            areaFixed: false,
          );
        })));
  }

  Widget _photoWidget(AssetEntity asset, int height, int width,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
        future: asset.thumbnailDataWithSize(ThumbnailSize(width, height)),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return builder(snapshot.data!);
          } else {
            return Container(
              color: mainWhite,
            );
          }
        });
  }

  Future<void> _cropImage(BuildContext context) async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    File? teptfile = await assetEntity.originFile;

    final file = await ImageCrop.cropImage(
      file: teptfile!,
      area: area,
    );

    ImageOptions imageOptions = await ImageCrop.getImageOptions(file: file);

    double aspectRatio = imageOptions.width / imageOptions.height;
    print("aspectRatio : $aspectRatio");
    controller.cropAspectRatio(aspectRatio);
    Get.back();
  }
}

// class ImageCropScreen extends StatefulWidget {
//   ImageCropScreen({Key? key, required this.image}) : super(key: key);
//   AssetEntity image;
//   @override
//   State<ImageCropScreen> createState() => _ImageCropScreenState();
// }

// class _ImageCropScreenState extends State<ImageCropScreen> {
//   GlobalKey<CustomCropState> cropKey = GlobalKey();
//   PostingAddController controller = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBarWidget(
//           bottomBorder: false,
//           leading: Padding(
//             padding: const EdgeInsets.fromLTRB(12.5, 12.5, 0, 0),
//             child: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: const Text(
//                   "취소",
//                   style: kNavigationTitle,
//                 )),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(12.5),
//               child: GestureDetector(
//                   onTap: () => _cropImage(context),
//                   child: Text(
//                     "완료",
//                     style: kNavigationTitle.copyWith(color: mainblue),
//                   )),
//             ),
//           ],
//         ),
//         body: FutureBuilder(
//             future: widget.image.originFile,
//             builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return Center(
//                   child: CustomCrop.file(
//                     snapshot.data!,
//                     key: cropKey,
//                   ),
//                 );
//               } else {
//                 return Container(
//                   color: dividegray,
//                 );
//               }
//             }));
//   }

//   Future<void> _cropImage(BuildContext context) async {
//     final scale = cropKey.currentState!.scale;
//     final area = cropKey.currentState!.area;
//     if (area == null) {
//       // cannot crop, widget is not setup
//       return;
//     }

//     File? teptfile = await widget.image.originFile;
//     final file = await ImageCrop.cropImage(
//       file: teptfile!,
//       area: area,
//     );

//     ImageOptions imageOptions = await ImageCrop.getImageOptions(file: file);

//     double aspectRatio = imageOptions.width / imageOptions.height;
//     print("aspectRatio : $aspectRatio");
//     controller.cropAspectRatio(aspectRatio);
//     Get.back();
//   }
// }
