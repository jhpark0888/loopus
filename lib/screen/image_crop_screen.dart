import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageCropScreen extends StatelessWidget {
  ImageCropScreen({Key? key, required this.assetEntity}) : super(key: key);
  MultiImageController controller = Get.find();

  // File image;
  GlobalKey<CustomCropState> cropKey = GlobalKey();

  AssetEntity assetEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(9.5, 9.5, 0, 0),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "취소",
                  style: MyTextTheme.navigationTitle(context),
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.5),
              child: GestureDetector(
                  onTap: () => _cropImage(context),
                  child: Text(
                    "완료",
                    style: MyTextTheme.navigationTitle(context)
                        .copyWith(color: AppColors.mainblue),
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
              color: AppColors.mainWhite,
            );
          }
        });
  }

  Future<void> _cropImage(BuildContext context) async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    final view = cropKey.currentState!.view;
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
    controller.cropKeyList[controller.selectedIndex.value].currentState!.scale =
        scale;
    controller.cropKeyList[controller.selectedIndex.value].currentState!.view =
        view;

    Get.back();
  }
}

class ShareImageCropScreen extends StatelessWidget {
  ShareImageCropScreen({Key? key, required this.imageFile}) : super(key: key);
  ShareIntentController controller = Get.find();

  // File image;
  GlobalKey<CustomCropState> cropKey = GlobalKey();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(9.5, 9.5, 0, 0),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "취소",
                  style: MyTextTheme.navigationTitle(context),
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.5),
              child: GestureDetector(
                  onTap: () => _cropImage(context),
                  child: Text(
                    "완료",
                    style: MyTextTheme.navigationTitle(context)
                        .copyWith(color: AppColors.mainblue),
                  )),
            ),
          ],
        ),
        body: Center(
          child: CustomCrop(
            image: FileImage(imageFile),
            key: cropKey,
            areaFixed: false,
          ),
        ));
  }

  Future<void> _cropImage(BuildContext context) async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    final view = cropKey.currentState!.view;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    final file = await ImageCrop.cropImage(
      file: imageFile,
      area: area,
    );

    ImageOptions imageOptions = await ImageCrop.getImageOptions(file: file);

    double aspectRatio = imageOptions.width / imageOptions.height;
    print("aspectRatio : $aspectRatio");
    controller.cropAspectRatio(aspectRatio);
    controller.cropKeyList[controller.selectedIndex.value].currentState!.scale =
        scale;
    controller.cropKeyList[controller.selectedIndex.value].currentState!.view =
        view;

    Get.back();
  }
}
