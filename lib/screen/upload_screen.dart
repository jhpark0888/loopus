import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/upload_controller.dart';

import 'package:photo_manager/photo_manager.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({Key? key}) : super(key: key);
  UploadController controller = Get.put(UploadController());
  ImageController imageController = Get.put(ImageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset('assets/icons/Arrow_left.svg')),
          title: Obx(
            () => Text(
              controller.isImage.value ? '사진첩 선택' : '이미지 첨부',
              style: kNavigationTitle,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12.5, 12.5, 0),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  '확인',
                  style: kNavigationTitle,
                ),
              ),
            )
          ],
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                print(controller.selectedImage);
              },
              child: Stack(children: [
                Container(
                    width: Get.width,
                    height: Get.width,
                    decoration: const BoxDecoration(color: mainWhite),
                    child: controller.isSelect.value
                        ? controller.isCropped.value
                            ? GestureDetector(
                                onTap: () async {
                                  // print((await controller.croppedImage!.value.readAsBytesSync()));
                                  var a = await decodeImageFromList(controller
                                      .croppedImage!.value
                                      .readAsBytesSync());
                                  print(a.height);
                                  print(a.width);
                                },
                                child: Image.file(
                                    controller.croppedImage!.value,
                                    fit: BoxFit.cover,
                                    width: controller.croppedWidth?.value,
                                    height: controller.croppedHeight?.value))
                            : _photoWidget(
                                controller.selectedImage!.value, 500, 500,
                                builder: (data) {
                                return Image.memory(data,
                                    fit: BoxFit.cover,
                                    width: controller.croppedWidth?.value,
                                    height: controller.croppedHeight?.value);
                              })
                        : Center(
                            child: Text(
                            '이미지를 선택해주세요 \n 최대 10장까지 가능해요',
                            style: kSubTitle3Style.copyWith(height: 1.5),
                          ))),
                if (controller.isSelect.value)
                  Positioned(
                      child: GestureDetector(
                          onTap: () async {
                            var path2 = await controller.selectedImage!.value
                                .loadFile();
                            print(path2);
                            imageController
                                .profilecropImage(path2)
                                .then((value) {
                              controller.croppedImage == null
                                  ? controller.croppedImage = value!.obs
                                  : controller.croppedImage!.value = value!;
                              controller.isCropped.value = true;
                            });
                          },
                          child:
                              SvgPicture.asset('assets/icons/PhotoEdit.svg')),
                      top: 16,
                      right: 16)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 10, bottom: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.isImage(true);
                    showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16))),
                        builder: (_) => Container(
                              height: Get.height -
                                  MediaQuery.of(context).padding.top -
                                  44,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: List.generate(
                                        controller.albums.length,
                                        (index) => Container(
                                            height: 110,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.imageList.value =
                                                    controller
                                                        .titleImageList1[index];
                                                controller.headerTitle.value =
                                                    controller
                                                        .albums[index].name;
                                                controller.selectedImages!
                                                    .clear();
                                                controller.isSelect(false);
                                                Get.back();
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        width: 100,
                                                        child: _photoWidget(
                                                            controller
                                                                    .titleImageList1[
                                                                index][0],
                                                            500,
                                                            500,
                                                            builder: (data) {
                                                          return Image.memory(
                                                              data,
                                                              fit:
                                                                  BoxFit.cover);
                                                        }),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Text(
                                                        controller
                                                            .albums[index].name,
                                                        style: k16semiBold,
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        '${controller.albums[index].assetCount.toString()}개',
                                                        style: kSubTitle3Style,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10)
                                                ],
                                              ),
                                            ))),
                                  ),
                                ),
                              ),
                            )).then((value) => controller.isImage(false));
                  },
                  child: Row(
                    children: [
                      Obx(
                        () => Text(
                          controller.headerTitle.value,
                          style: kmainbold,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1),
              itemCount: controller.imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Obx(() => Container(
                      height: Get.width / 4,
                      width: Get.width / 4,
                      child: _photoWidget(controller.imageList[index], 200, 200,
                          builder: (data) {
                        return Obx(
                          (() => GestureDetector(
                                onTap: () {
                                  controller.isCropped.value = false;
                                  if (controller.isSelect.value == false) {
                                    controller.selectedImage ??=
                                        controller.imageList[index].obs;
                                    controller.selectedImages!.value = [
                                      controller.imageList[index]
                                    ];
                                    controller.selectedImages ??=
                                        [controller.imageList[index]].obs;
                                    controller.selectedImage!.value =
                                        controller.imageList[index];
                                    controller.isSelect.value = true;
                                  } else if (!controller.selectedImages!
                                      .contains(controller.imageList[index])) {
                                    controller.selectedImage ??=
                                        controller.imageList[index].obs;
                                    if (controller.selectedImages!.length <
                                        10) {
                                      controller.selectedImages!
                                          .add(controller.imageList[index]);
                                      // controller.isSelect.value = true;
                                      controller.selectedImage!.value =
                                          controller.imageList[index];
                                    } else {
                                      controller.selectedImage ??=
                                          controller.imageList[index].obs;
                                    }
                                  } else {
                                    if (controller.selectedImage!.value ==
                                        controller.imageList[index]) {
                                      controller.selectedImages!
                                          .remove(controller.imageList[index]);
                                      if (controller
                                          .selectedImages!.isNotEmpty) {
                                        controller.selectedImage!.value =
                                            controller.selectedImages!.last;
                                      } else {
                                        controller.isSelect.value = false;
                                      }
                                    } else {
                                      controller.selectedImage!.value =
                                          controller.imageList[index];
                                    }
                                  }
                                },
                                child: Stack(children: [
                                  Opacity(
                                      opacity: controller.isSelect.value == true
                                          ? controller.selectedImage!.value ==
                                                  controller.imageList[index]
                                              ? 0.3
                                              : 1
                                          : 1,
                                      child: Image.memory(
                                        data,
                                        fit: BoxFit.cover,
                                        height: Get.width / 4,
                                        width: Get.width / 4,
                                      )),
                                  controller.isSelect.value == true
                                      ? controller.selectedImages!.contains(
                                              controller.imageList[index])
                                          ? Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                      color: mainblue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32))))
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink()
                                ]),
                              )),
                        );
                      }),
                    ));
              })),
          // _imageSelectLis1t()
        ])),
      ),
    );
  }

  Widget _imagePreview() {
    return Container(
        width: Get.width,
        height: Get.width,
        decoration: BoxDecoration(color: maingray),
        child: controller.selectedImages == null
            ? Container()
            : _photoWidget(controller.selectedImages!.first, 500, 500,
                builder: (data) {
                return Image.memory(data, fit: BoxFit.cover);
              }));
  }

  Widget _header() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                controller.headerTitle.value,
                style: kmainbold,
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ],
      ),
    );
  }

  // Widget _imageSelectList() {
  //   return GridView.builder(
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 4,
  //           mainAxisSpacing: 1,
  //           crossAxisSpacing: 1,
  //           childAspectRatio: 1),
  //       itemCount: controller.imageList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Obx(() =>
  //             _photoWidget(controller.imageList[index], 200, builder: (data) {
  //               return GestureDetector(
  //                 onTap: () {
  //                   controller.selectedImages!.add(controller.imageList[index]);
  //                 },
  //                 child: Opacity(
  //                     opacity: controller.imageList[index] ==
  //                             controller.selectedImages!.value
  //                         ? 0.3
  //                         : 1,
  //                     child: Image.memory(data, fit: BoxFit.cover)),
  //               );
  //             }));
  //       });
  // }

  Widget _photoWidget(AssetEntity asset, int height, int width,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
        future: asset.thumbnailDataWithSize(ThumbnailSize(width, height)),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data!);
          } else {
            return Container();
          }
        });
  }

  void modalsheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (_) => Container(
              color: Colors.white,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        controller.albums.length,
                        (index) => Container(
                            height: 50,
                            child: Text(controller.albums[index].name))),
                  ),
                ),
              ),
            ));
  }
  // Widget _imageSelectLis1t() {
  //   return GridView.builder(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 4,
  //             mainAxisSpacing: 1,
  //             crossAxisSpacing: 1,
  //             childAspectRatio: 1),
  //         itemCount: controller.imageList1.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Obx(() => controller.isLoad.value == false
  //               ? const SizedBox.shrink()
  //               : GestureDetector(
  //                   onTap: () {
  //                     controller.selectedImage1!.value =
  //                         controller.imageList1[index];
  //                         print(controller.selectedImage1!.value);
  //                         print(controller.imageList1[index] ==
  //                               controller.selectedImage1!.value);
  //                               controller.selectedImage1!.refresh();
  //                   },
  //                   child: Opacity(
  //                       opacity: controller.imageList1[index] ==
  //                               controller.selectedImage1!.value
  //                           ? 0.3
  //                           : 1,
  //                       child: Image.file(controller.imageList1[index],
  //                           fit: BoxFit.cover)),
  //                 ));
  //         });

  // }
}
