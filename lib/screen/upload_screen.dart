import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/screen/image_crop_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({Key? key}) : super(key: key);

  // UploadController controller = Get.put(UploadController());
  PostingAddController controller = Get.find();
  ImageController imageController = Get.put(ImageController());

  ScrollController nestedScrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              'assets/icons/appbar_back.svg',
            )),
        title: Obx(
          () => Text(
            controller.isImage.value ? '사진첩 선택' : '이미지 첨부',
            style: kNavigationTitle,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: GestureDetector(
              onTap: () async {
                loading();
                if (controller.isSelect.value == true) {
                  if (controller.images != []) {
                    controller.images.value = (await cropImages());
                    controller.isAddImage(true);
                  } else {
                    controller.isAddImage(false);
                  }
                } else {
                  controller.isAddImage(false);
                }
                print(controller.isAddImage.value);
                print(controller.isSelect.value);
                getbacks(2);
                print(controller.cropAspectRatio.value);
              },
              child: const Center(
                child: Text(
                  '확인',
                  style: kNavigationTitle,
                ),
              ),
            ),
          )
        ],
        elevation: 0,
      ),
      body: NestedScrollView(
          controller: nestedScrollController,
          floatHeaderSlivers: false,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                            width: Get.width,
                            height: Get.width,
                            decoration: const BoxDecoration(color: mainWhite),
                            child: controller.isSelect.value
                                ? Obx(
                                    () => IndexedStack(
                                      index: controller.selectedIndex.value,
                                      children: controller.cropWidgetList.value,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                    '이미지를 선택해주세요 \n 최대 10장까지 가능해요',
                                    style:
                                        kmainheight,
                                  ))),
                        if (controller.isSelect.value)
                          Positioned(
                              child: GestureDetector(
                                  onTap: () async {
                                    // File? image = await controller
                                    //     .selectedImage.value.originFile;
                                    // if (image != null) {
                                    Get.to(() => ImageCropScreen(
                                        assetEntity:
                                            controller.selectedImage.value));
                                    // }
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/photo_edit.svg')),
                              top: 16,
                              right: 16)
                      ]),
                    ),
                  ),
                ),
                // ),
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    sliver: SliverAppBar(
                      primary: false,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 44,
                      pinned: true,
                      stretch: true,
                      title: Row(
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
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: List.generate(
                                                  controller.albums.length,
                                                  (index) => Container(
                                                      height: 110,
                                                      child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        onTap: () {
                                                          controller
                                                              .refreshController
                                                              .loadComplete();
                                                          controller
                                                                  .albumIndex =
                                                              index;
                                                          controller.imageList
                                                              .value = controller
                                                                  .titleImageList1[
                                                              index];
                                                          controller.headerTitle
                                                                  .value =
                                                              controller
                                                                  .albums[index]
                                                                  .name;
                                                          controller
                                                              .selectedImages
                                                              .clear();
                                                          controller
                                                              .cropWidgetList
                                                              .clear();
                                                          controller.cropKeyList
                                                              .clear();
                                                          controller
                                                              .cropAspectRatio(
                                                                  1);
                                                          controller
                                                              .isSelect(false);
                                                          Get.back();
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  color:
                                                                      dividegray,
                                                                  child: controller
                                                                          .titleImageList1[
                                                                              index]
                                                                          .isNotEmpty
                                                                      ? _photoWidget(
                                                                          controller.titleImageList1[index]
                                                                              [
                                                                              0],
                                                                          500,
                                                                          500,
                                                                          builder:
                                                                              (data) {
                                                                          return Image.memory(
                                                                              data,
                                                                              fit: BoxFit.cover);
                                                                        })
                                                                      : const Center(
                                                                          child:
                                                                              Text(
                                                                            "이미지 없음",
                                                                            style:
                                                                                kmain,
                                                                          ),
                                                                        ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 15),
                                                                Text(
                                                                  controller
                                                                      .albums[
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      kmainbold,
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  '${controller.albums[index].assetCount.toString()}개',
                                                                  style:
                                                                      kmain,
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10)
                                                          ],
                                                        ),
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      )).then(
                                  (value) => controller.isImage(false));
                            },
                            child: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    controller.headerTitle.value,
                                    style: kmainbold,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                SvgPicture.asset('assets/icons/drop_icon.svg')
                              ],
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          body: NotificationListener<ScrollNotification>(
            onNotification: (t) {
              if (t is ScrollEndNotification) {
                if (scrollController.position.pixels ==
                    scrollController.position.minScrollExtent) {
                  nestedScrollController.animateTo(
                      nestedScrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                } else if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  nestedScrollController.animateTo(
                      nestedScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
              }
              return true;
            },
            child: SmartRefresher(
              scrollController: scrollController,
              controller: controller.refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: const MyCustomFooter(),
              onLoading: controller.onPageLoad,
              child: Obx(() => GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1),
                  itemCount: controller.imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: Get.width / 4,
                      width: Get.width / 4,
                      child: _photoWidget(controller.imageList[index], 200, 200,
                          builder: (data) {
                        return Obx(
                          (() => GestureDetector(
                                onTap: () {
                                  // controller.isCropped.value = false;
                                  if (controller.isSelect.value == false) {
                                    //처음 이미지 클릭
                                    _addImage(index);
                                    controller.isSelect.value = true;
                                  } else if (!controller.selectedImages
                                      .contains(controller.imageList[index])) {
                                    if (controller.selectedImages.length < 10) {
                                      //이미지 추가 10장 이내
                                      _addImage(index);
                                    } else {
                                      //이미지 추가 10장 넘음
                                      showCustomDialog(
                                          "최대 10개의 이미지만 선택할 수 있습니다", 1000);
                                    }
                                    controller.isSelect.value = true;
                                  } else {
                                    if (controller.selectedImage.value ==
                                        controller.imageList[index]) {
                                      //이미지 제거
                                      _removeImage(index);
                                      if (controller
                                          .selectedImages.isNotEmpty) {
                                        //선택된 이미지가 남아있음
                                        controller.selectedImage.value =
                                            controller.selectedImages.last;
                                      } else {
                                        //선택된 이미지가 비어있음
                                        controller.isSelect.value = false;
                                        controller.cropAspectRatio.value = 1.0;
                                      }
                                    } else {
                                      //선택된 이미지 중 다른 이미지 선택
                                      controller.selectedImage.value =
                                          controller.imageList[index];
                                      controller.selectedIndex(
                                          controller.selectedImageIndex(
                                              controller.imageList[index]));
                                    }
                                  }
                                },
                                child: Stack(children: [
                                  Opacity(
                                      opacity: controller.isSelect.value == true
                                          ? controller.selectedImage.value ==
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
                                      ? controller.selectedImages.contains(
                                              controller.imageList[index])
                                          ? Positioned(
                                              top: 5,
                                              right: 5,
                                              child: 
                                              SvgPicture.asset('assets/icons/num_index${controller.selectedImages.indexOf(controller.imageList[index]) + 1}.svg')
                                              )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink()
                                ]),
                              )),
                        );
                      }),
                    );
                  })),
              // _imageSelectLis1t()
            ),
          )),
    );
  }

  Widget _imagePreview() {
    return Container(
        width: Get.width,
        height: Get.width,
        decoration: BoxDecoration(color: maingray),
        child: controller.selectedImages == null
            ? Container()
            : _photoWidget(controller.selectedImages.first, 500, 500,
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

  void _addImage(int index) async {
    GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();
    // File? image = await assetToFile(controller.imageList[index]);
    // controller.selectedImage ??= controller.imageList[index].obs;
    controller.selectedImages.add(controller.imageList[index]);
    controller.selectedImage.value = controller.imageList[index];
    controller.cropKeyList.add(cropKey);

    AssetEntity asset = controller.selectedImage.value;

    controller.cropWidgetList.add(Obx(
      () => CustomCrop(
        image: AssetEntityImage(
          asset,
          thumbnailSize: const ThumbnailSize(500, 500),
        ).image,
        key: cropKey,
        areaFixed: true,
        aspectRatio: controller.cropAspectRatio.value,
      ),
    ));

    // controller.cropWidgetList.add(Obx(
    //   () => CustomCrop.file(
    //     image!,
    //     key: cropKey,
    //     areaFixed: true,
    //     aspectRatio: controller.cropAspectRatio.value,
    //   ),
    // ));
    controller.selectedIndex(controller.cropKeyList.length - 1);
  }

  void _removeImage(int index) {
    controller.cropWidgetList.removeAt(
        controller.selectedImageIndex(controller.selectedImage.value));
    controller.cropKeyList.removeAt(
        controller.selectedImageIndex(controller.selectedImage.value));
    controller.selectedImages.remove(controller.imageList[index]);
    controller.selectedIndex(controller.cropKeyList.length - 1);
  }

  Future<File?> assetToFile(AssetEntity assetEntity) async {
    File? image = await assetEntity.originFile;

    return image;
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

  Future<List<File>> assetsToFiles(List<AssetEntity> assetEntity) async {
    List<File> images = <File>[];
    for (AssetEntity assetentity in assetEntity) {
      File? image = await assetentity.file;
      images.add(image!);
    }
    return images;
  }

  Future<List<File>> cropImages() async {
    List<File> images = <File>[];
    for (int i = 0; i < controller.cropKeyList.length; i++) {
      GlobalKey<CustomCropState> cropKey = controller.cropKeyList[i];
      AssetEntity assetEntity = controller.selectedImages[i];
      // final scale = cropKey.currentState!.scale;
      final area = cropKey.currentState!.area;
      if (area == null) {
        // cannot crop, widget is not setup
        print(null);
        return [];
      }

      File? teptfile = await assetEntity.originFile;
      final file = await ImageCrop.cropImage(
        file: teptfile!,
        area: area,
      );
      images.add(file);
    }

    return images;
  }
}
