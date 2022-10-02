import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/profile_image_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/image_crop_screen.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileImageChangeScreen extends StatelessWidget {
  ProfileImageChangeScreen({Key? key}) : super(key: key);

  final ImageController _controller = Get.put(ImageController());
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
            _controller.isAlbum.value ? '사진첩 선택' : '프로필 사진',
            style: kNavigationTitle,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: GestureDetector(
              onTap: () async {
                if (_controller.isSelect.value == true) {
                  loading();
                  File? image = await _controller.cropImage();
                  if (image != null) {
                    await updateProfile(
                            user: ProfileController.to.myUserInfo.value,
                            image: image,
                            updateType: ProfileUpdateType.image)
                        .then((value) {
                      if (value.isError == false) {
                        User user = User.fromJson(value.data);

                        HomeController.to.myProfile(user);
                        if (Get.isRegistered<ProfileController>()) {
                          ProfileController.to.myUserInfo(user);
                        }
                        if (Get.isRegistered<OtherProfileController>(
                            tag: user.userid.toString())) {
                          Get.find<OtherProfileController>(
                                  tag: user.userid.toString())
                              .otherUser(user);
                        }
                        getbacks(3);
                      } else {
                        Get.back();
                        errorSituation(value);
                      }
                    });
                  } else {
                    Get.back();
                    showCustomDialog("프로필 변경에 실패하였습니다", 1200);
                  }
                }
              },
              child: Center(
                child: Obx(
                  () => Text(
                    '확인',
                    style: kNavigationTitle.copyWith(
                        color: _controller.isSelect.value ? null : maingray),
                  ),
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
                      child: Container(
                          width: Get.width,
                          height: Get.width,
                          decoration: const BoxDecoration(color: mainWhite),
                          child: _controller.isSelect.value
                              ? Obx(
                                  () => CustomCrop(
                                    image: AssetEntityImage(
                                      _controller.selectedImage.value,
                                      thumbnailSize:
                                          const ThumbnailSize(500, 500),
                                    ).image,
                                    key: _controller.cropKey,
                                    areaFixed: true,
                                    circleShape: true,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                  '이미지를 선택해주세요',
                                  style: kmainheight,
                                ))),
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
                      titleSpacing: 0,
                      pinned: true,
                      stretch: true,
                      title: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controller.isAlbum(true);
                              showModalBottomSheet(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16))),
                                  builder: (_) => Container(
                                        height:
                                            Get.height - Get.statusBarHeight,
                                        color: Colors.white,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: List.generate(
                                                  _controller.albums.length,
                                                  (index) => SizedBox(
                                                      height: 110,
                                                      child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        onTap: () {
                                                          _controller
                                                              .refreshController
                                                              .loadComplete();
                                                          _controller
                                                                  .albumIndex =
                                                              index;
                                                          _controller.imageList
                                                              .value = _controller
                                                                  .titleImageList[
                                                              index];
                                                          _controller
                                                                  .headerTitle
                                                                  .value =
                                                              _controller
                                                                  .albums[index]
                                                                  .name;

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
                                                                  child: _controller
                                                                          .titleImageList[
                                                                              index]
                                                                          .isNotEmpty
                                                                      ? _photoWidget(
                                                                          _controller.titleImageList[index]
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
                                                                  _controller
                                                                      .albums[
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      kmainbold,
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  '${_controller.albums[index].assetCount.toString()}개',
                                                                  style: kmain,
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
                                  (value) => _controller.isAlbum(false));
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: const EdgeInsets.only(left: 17),
                              height: 44,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Obx(
                                      () => Text(
                                        _controller.headerTitle.value,
                                        style: kmainbold,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    SvgPicture.asset(
                                        'assets/icons/drop_icon.svg')
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
              controller: _controller.refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: const MyCustomFooter(),
              onLoading: _controller.onPageLoad,
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
                  itemCount: _controller.imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: Get.width / 4,
                      width: Get.width / 4,
                      child:
                          _photoWidget(_controller.imageList[index], 200, 200,
                              builder: (data) {
                        return Obx(
                          (() => GestureDetector(
                                onTap: () {
                                  if (_controller.selectedImage.value !=
                                      _controller.imageList[index]) {
                                    _selectImage(index);
                                    _controller.isSelect.value = true;
                                  }
                                },
                                child: Opacity(
                                    opacity: _controller.isSelect.value == true
                                        ? _controller.selectedImage.value ==
                                                _controller.imageList[index]
                                            ? 0.3
                                            : 1
                                        : 1,
                                    child: Image.memory(
                                      data,
                                      fit: BoxFit.cover,
                                      height: Get.width / 4,
                                      width: Get.width / 4,
                                    )),
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
              color: mainWhite,
            );
          }
        });
  }

  void _selectImage(int index) async {
    GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();
    _controller.selectedImage.value = _controller.imageList[index];
    _controller.cropKey = cropKey;
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
                        _controller.albums.length,
                        (index) => Container(
                            height: 50,
                            child: Text(_controller.albums[index].name))),
                  ),
                ),
              ),
            ));
  }

  // Future<List<File>> assetsToFiles(List<AssetEntity> assetEntity) async {
  //   List<File> images = <File>[];
  //   for (AssetEntity assetentity in assetEntity) {
  //     File? image = await assetentity.file;
  //     images.add(image!);
  //   }
  //   return images;
  // }
}
