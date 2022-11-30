import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/screen/image_crop_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShareImageUploadScreen extends StatelessWidget {
  ShareImageUploadScreen({Key? key}) : super(key: key);

  // UploadController controller = Get.put(UploadController());
  PostingAddController controller = Get.find();
  final ShareIntentController _shareImageController = Get.find();

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
                if (controller.images != []) {
                  controller.images(await _shareImageController.cropImages());
                  controller.cropAspectRatio(
                      _shareImageController.cropAspectRatio.value);
                  controller.selectedCropKeyList
                      .assignAll(_shareImageController.cropKeyList);
                  controller.selectedCropWidgetList
                      .assignAll(_shareImageController.cropWidgetList);
                  controller.selectedShareImageList
                      .assignAll(_shareImageController.selectedImages);
                  List<double> scaleList = [];
                  List<Rect> viewList = [];
                  for (GlobalKey<CustomCropState> cropKey
                      in _shareImageController.cropKeyList) {
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
              () => Stack(children: [
                Obx(
                  () => Container(
                      width: Get.width,
                      height: Get.width,
                      decoration:
                          const BoxDecoration(color: AppColors.mainWhite),
                      child: _shareImageController.selectedImages.isNotEmpty
                          ? Obx(
                              () => IndexedStack(
                                index:
                                    _shareImageController.selectedIndex.value,
                                children:
                                    _shareImageController.cropWidgetList.value,
                              ),
                            )
                          : Center(
                              child: Text(
                              '이미지를 선택해주세요 \n 최대 10장까지 가능해요',
                              style: MyTextTheme.mainheight(context),
                              textAlign: TextAlign.center,
                            ))),
                ),
                if (_shareImageController.selectedImages.isNotEmpty)
                  Positioned(
                      child: GestureDetector(
                          onTap: () async {
                            Get.to(() => ShareImageCropScreen(
                                imageFile:
                                    _shareImageController.selectedImage.value));
                          },
                          child:
                              SvgPicture.asset('assets/icons/photo_edit.svg')),
                      top: 16,
                      right: 16)
              ]),
            ),
          ),
          // ),
          // SliverOverlapAbsorber(
          //   handle:
          //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          // SliverAppBar(
          //   primary: false,
          //   automaticallyImplyLeading: false,
          //   toolbarHeight: 44,
          //   titleSpacing: 0,
          //   pinned: true,
          //   stretch: true,
          //   title: Container(
          //     decoration: BoxDecoration(
          //         border: Border(
          //             top:
          //                 BorderSide(width: 0.5, color: AppColors.dividegray))),
          //   ),
          // ),
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
            child: GridView.builder(
                controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: false,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1),
                itemCount: _shareImageController.shareImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: Get.width / 4,
                    width: Get.width / 4,
                    child: Obx(
                      (() => GestureDetector(
                            onTap: () {
                              if (_shareImageController
                                  .selectedImages.isEmpty) {
                                //처음 이미지 클릭
                                _shareImageController.addImage(index);
                              } else if (!_shareImageController.selectedImages
                                  .contains(_shareImageController
                                      .shareImages[index])) {
                                if (_shareImageController
                                        .selectedImages.length <
                                    10) {
                                  //이미지 추가 10장 이내
                                  _shareImageController.addImage(index);
                                } else {
                                  //이미지 추가 10장 넘음
                                  showCustomDialog(
                                      "최대 10개의 이미지만 선택할 수 있습니다", 1000);
                                }
                              } else {
                                if (_shareImageController.selectedImage.value ==
                                    _shareImageController.shareImages[index]) {
                                  //이미지 제거
                                  _shareImageController.removeImage(index);
                                  if (_shareImageController
                                      .selectedImages.isNotEmpty) {
                                    //선택된 이미지가 남아있음
                                    _shareImageController.selectedImage.value =
                                        _shareImageController
                                            .selectedImages.last;
                                  } else {
                                    //선택된 이미지가 비어있음
                                    _shareImageController
                                        .cropAspectRatio.value = 1.0;
                                  }
                                } else {
                                  //선택된 이미지 중 다른 이미지 선택
                                  _shareImageController.selectedImage.value =
                                      _shareImageController.shareImages[index];
                                  _shareImageController.selectedIndex(
                                      _shareImageController.selectedImageIndex(
                                          _shareImageController
                                              .shareImages[index]));
                                }
                              }
                            },
                            child: Stack(children: [
                              Opacity(
                                  opacity: _shareImageController
                                          .selectedImages.isNotEmpty
                                      ? _shareImageController
                                                  .selectedImage.value ==
                                              _shareImageController
                                                  .shareImages[index]
                                          ? 0.3
                                          : 1
                                      : 1,
                                  child: Image.file(
                                    _shareImageController.shareImages[index],
                                    fit: BoxFit.cover,
                                    height: Get.width / 4,
                                    width: Get.width / 4,
                                  )),
                              _shareImageController.selectedImages.isNotEmpty
                                  ? _shareImageController.selectedImages
                                          .contains(_shareImageController
                                              .shareImages[index])
                                      ? Positioned(
                                          top: 5,
                                          right: 5,
                                          child: SvgPicture.asset(
                                              'assets/icons/num_index${_shareImageController.selectedImages.indexOf(_shareImageController.shareImages[index]) + 1}.svg'))
                                      : const SizedBox.shrink()
                                  : const SizedBox.shrink()
                            ]),
                          )),
                    ),
                  );
                })),
      ),
    );
  }
}
