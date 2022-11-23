import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/screen/image_crop_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({Key? key}) : super(key: key);

  // UploadController controller = Get.put(UploadController());
  PostingAddController controller = Get.find();
  final MultiImageController _imageController = Get.find();

  ScrollController nestedScrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              'assets/icons/appbar_back.svg',
            )),
        title: Text(
          '이미지 첨부하기',
          style: MyTextTheme.navigationTitle(context),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: GestureDetector(
              onTap: () async {
                loading();
                if (_imageController.isSelect.value == true) {
                  if (controller.images != []) {
                    controller.images(await _imageController.cropImages());
                    controller.cropAspectRatio(
                        _imageController.cropAspectRatio.value);
                    controller.selectedCropKeyList
                        .assignAll(_imageController.cropKeyList);
                    controller.selectedCropWidgetList
                        .assignAll(_imageController.cropWidgetList);
                    controller.selectedImageList
                        .assignAll(_imageController.selectedImages);
                    List<double> scaleList = [];
                    List<Rect> viewList = [];
                    for (GlobalKey<CustomCropState> cropKey
                        in _imageController.cropKeyList) {
                      final scale = cropKey.currentState!.scale;
                      final view = cropKey.currentState!.view;

                      scaleList.add(scale);
                      viewList.add(view);
                    }
                    controller.selectedScaleList = scaleList;
                    controller.selectedViewList = viewList;

                    controller.isAddImage(true);
                  } else {
                    controller.isAddImage(false);
                  }
                } else {
                  controller.isAddImage(false);
                }
                getbacks(2);
              },
              child: Center(
                child: Text(
                  '확인',
                  style: MyTextTheme.navigationTitle(context),
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
                            decoration:
                                const BoxDecoration(color: AppColors.mainWhite),
                            child: _imageController.isSelect.value
                                ? Obx(
                                    () => IndexedStack(
                                      index:
                                          _imageController.selectedIndex.value,
                                      children:
                                          _imageController.cropWidgetList.value,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                    '이미지를 선택해주세요 \n 최대 10장까지 가능해요',
                                    style: MyTextTheme.mainheight(context),
                                    textAlign: TextAlign.center,
                                  ))),
                        if (_imageController.isSelect.value)
                          Positioned(
                              child: GestureDetector(
                                  onTap: () async {
                                    Get.to(() => ImageCropScreen(
                                        assetEntity: _imageController
                                            .selectedImage.value));
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
                // SliverOverlapAbsorber(
                //   handle:
                //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                SliverAppBar(
                  primary: false,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 44,
                  titleSpacing: 0,
                  pinned: true,
                  stretch: true,
                  title: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 0.5, color: AppColors.dividegray))),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AlbumSelectScreen());
                            // _imageController.isAlbum(true);
                            // showModalBottomSheet(
                            //         barrierColor: Colors.transparent,
                            //         context: context,
                            //         isScrollControlled: true,
                            //         shape: const RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.only(
                            //                 topLeft: Radius.circular(16),
                            //                 topRight: Radius.circular(16))),
                            //         builder: (_) => Container(
                            //               height: Get.height -
                            //                   Get.statusBarHeight,
                            //               color: Colors.white,
                            //               child: SingleChildScrollView(
                            //                 child: Padding(
                            //                   padding:
                            //                       const EdgeInsets.only(
                            //                           right: 20),
                            //                   child: Column(
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment
                            //                             .stretch,
                            //                     children: List.generate(
                            //                         _imageController
                            //                             .albums.length,
                            //                         (index) => SizedBox(
                            //                             height: 110,
                            //                             child:
                            //                                 GestureDetector(
                            //                               behavior:
                            //                                   HitTestBehavior
                            //                                       .translucent,
                            //                               onTap: () {
                            //                                 _imageController
                            //                                     .refreshController
                            //                                     .loadComplete();
                            //                                 _imageController
                            //                                         .albumIndex =
                            //                                     index;
                            //                                 _imageController
                            //                                         .imageList
                            //                                         .value =
                            //                                     _imageController
                            //                                             .titleImageList[
                            //                                         index];
                            //                                 _imageController
                            //                                         .headerTitle
                            //                                         .value =
                            //                                     _imageController
                            //                                         .albums[
                            //                                             index]
                            //                                         .name;
                            //                                 // controller
                            //                                 //     .selectedImages
                            //                                 //     .clear();
                            //                                 // controller
                            //                                 //     .cropWidgetList
                            //                                 //     .clear();
                            //                                 // controller.cropKeyList
                            //                                 //     .clear();
                            //                                 // controller
                            //                                 //     .cropAspectRatio(
                            //                                 //         1);
                            //                                 // controller
                            //                                 //     .isSelect(false);
                            //                                 Get.back();
                            //                               },
                            //                               child: Column(
                            //                                 children: [
                            //                                   Row(
                            //                                     children: [
                            //                                       Container(
                            //                                         height:
                            //                                             100,
                            //                                         width:
                            //                                             100,
                            //                                         color:
                            //                                             AppColors.dividegray,
                            //                                         child: _imageController.titleImageList[index].isNotEmpty
                            //                                             ? _photoWidget(_imageController.titleImageList[index][0], 500, 500, builder: (data) {
                            //                                                 return Image.memory(data, fit: BoxFit.cover);
                            //                                               })
                            //                                             : const Center(
                            //                                                 child: Text(
                            //                                                   "이미지 없음",
                            //                                                   style: MyTextTheme.main(context),
                            //                                                 ),
                            //                                               ),
                            //                                       ),
                            //                                       const SizedBox(
                            //                                           width:
                            //                                               15),
                            //                                       Text(
                            //                                         _imageController
                            //                                             .albums[index]
                            //                                             .name,
                            //                                         style:
                            //                                             MyTextTheme.mainbold(context),
                            //                                       ),
                            //                                       const Spacer(),
                            //                                       Text(
                            //                                         '${_imageController.albums[index].assetCount.toString()}개',
                            //                                         style:
                            //                                             MyTextTheme.main(context),
                            //                                       ),
                            //                                     ],
                            //                                   ),
                            //                                   const SizedBox(
                            //                                       height:
                            //                                           10)
                            //                                 ],
                            //                               ),
                            //                             ))),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ))
                            //     .then((value) =>
                            //         _imageController.isAlbum(false));
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            padding: const EdgeInsets.only(left: 17),
                            height: Platform.isAndroid ? 44 : 44,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Obx(
                                    () => Text(
                                      _imageController.headerTitle.value,
                                      style: MyTextTheme.main(context),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SvgPicture.asset('assets/icons/drop_icon.svg')
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer()
                        //
                      ],
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
              controller: _imageController.refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: const MyCustomFooter(),
              onLoading: _imageController.onPageLoad,
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
                  itemCount: _imageController.imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: Get.width / 4,
                      width: Get.width / 4,
                      child: _photoWidget(
                          _imageController.imageList[index], 200, 200,
                          builder: (data) {
                        return Obx(
                          (() => GestureDetector(
                                onTap: () {
                                  if (_imageController.isSelect.value ==
                                      false) {
                                    //처음 이미지 클릭
                                    _imageController.addImage(index);
                                    _imageController.isSelect.value = true;
                                  } else if (!_imageController.selectedImages
                                      .contains(
                                          _imageController.imageList[index])) {
                                    if (_imageController.selectedImages.length <
                                        10) {
                                      //이미지 추가 10장 이내
                                      _imageController.addImage(index);
                                    } else {
                                      //이미지 추가 10장 넘음
                                      showCustomDialog(
                                          "최대 10개의 이미지만 선택할 수 있습니다", 1000);
                                    }
                                    _imageController.isSelect.value = true;
                                  } else {
                                    if (_imageController.selectedImage.value ==
                                        _imageController.imageList[index]) {
                                      //이미지 제거
                                      _imageController.removeImage(index);
                                      if (_imageController
                                          .selectedImages.isNotEmpty) {
                                        //선택된 이미지가 남아있음
                                        _imageController.selectedImage.value =
                                            _imageController
                                                .selectedImages.last;
                                      } else {
                                        //선택된 이미지가 비어있음
                                        _imageController.isSelect.value = false;
                                        _imageController.cropAspectRatio.value =
                                            1.0;
                                      }
                                    } else {
                                      //선택된 이미지 중 다른 이미지 선택
                                      _imageController.selectedImage.value =
                                          _imageController.imageList[index];
                                      _imageController.selectedIndex(
                                          _imageController.selectedImageIndex(
                                              _imageController
                                                  .imageList[index]));
                                    }
                                  }
                                },
                                child: Stack(children: [
                                  Opacity(
                                      opacity:
                                          _imageController.isSelect.value ==
                                                  true
                                              ? _imageController.selectedImage
                                                          .value ==
                                                      _imageController
                                                          .imageList[index]
                                                  ? 0.3
                                                  : 1
                                              : 1,
                                      child: Image.memory(
                                        data,
                                        fit: BoxFit.cover,
                                        height: Get.width / 4,
                                        width: Get.width / 4,
                                      )),
                                  _imageController.isSelect.value == true
                                      ? _imageController.selectedImages
                                              .contains(_imageController
                                                  .imageList[index])
                                          ? Positioned(
                                              top: 5,
                                              right: 5,
                                              child: SvgPicture.asset(
                                                  'assets/icons/num_index${_imageController.selectedImages.indexOf(_imageController.imageList[index]) + 1}.svg'))
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
}

class AlbumSelectScreen extends StatelessWidget {
  AlbumSelectScreen({Key? key}) : super(key: key);
  final ImageController _imageController = Get.isRegistered<ImageController>()
      ? Get.find<ImageController>()
      : Get.find<MultiImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '사진첩 선택',
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
              _imageController.albums.length,
              (index) => Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _imageController.refreshController.loadComplete();
                      _imageController.albumIndex = index;
                      _imageController.imageList.value =
                          _imageController.titleImageList[index];
                      _imageController.headerTitle.value =
                          _imageController.albums[index].name;
                      // controller
                      //     .selectedImages
                      //     .clear();
                      // controller
                      //     .cropWidgetList
                      //     .clear();
                      // controller.cropKeyList
                      //     .clear();
                      // controller
                      //     .cropAspectRatio(
                      //         1);
                      // controller
                      //     .isSelect(false);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.dividegray, width: 0.5))),
                      child: Row(
                        children: [
                          Text(
                            _imageController.albums[index].name,
                            style: MyTextTheme.mainbold(context),
                          ),
                          const Spacer(),
                          Text(
                            '${_imageController.albums[index].assetCount.toString()}개',
                            style: MyTextTheme.main(context),
                          ),
                        ],
                      ),
                    ),
                  ))),
        ),
      ),
    );
  }
}
