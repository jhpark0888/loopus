import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ImageController extends GetxController {
  static ImageController get to => Get.find();
  var albums = <AssetPathEntity>[].obs;
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  Rx<AssetEntity> selectedImage =
      const AssetEntity(id: '', height: 0, width: 0, typeInt: 0).obs;
  RxBool isLoad = false.obs;
  RxBool isSelect = false.obs;
  RxBool isAlbum = false.obs;
  RxList<List<AssetEntity>> titleImageList = <List<AssetEntity>>[].obs;
  List<int> albumPageNums = <int>[].obs;
  int albumIndex = 0;
  RefreshController refreshController = RefreshController();
  GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();

  @override
  void onInit() {
    PhotoManager.addChangeCallback(changeNotify);
    PhotoManager.startChangeNotify();
    _loadPhotos();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    PhotoManager.removeChangeCallback(changeNotify);
    PhotoManager.stopChangeNotify();
  }

  void _loadData() async {
    headerTitle.value = albums.first.name;
    await _pagingPhotos().then((value) => isLoad.value = true);
  }

  Future<void> onPageLoad() async {
    var photos = await albums[albumIndex]
        .getAssetListPaged(page: albumPageNums[albumIndex], size: 30);

    if (photos.isEmpty) {
      refreshController.loadNoData();
    } else {
      imageList.addAll(photos);
      albumPageNums[albumIndex] += 1;
      refreshController.loadComplete();
    }
  }

  Future<void> _pagingPhotos() async {
    var photos = await albums.first.getAssetListPaged(page: 0, size: 30);

    imageList.addAll(photos);
  }

  Future<void> getPhotos() async {
    for (int i = 0; i < albums.length; i++) {
      var photos = await albums[i].getAssetListPaged(page: 0, size: 30);
      titleImageList.add(photos);
      albumPageNums[i] += 1;
    }
  }

  void _loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      albums.value = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100),
            ),
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false),
            ],
          ));
      albumPageNums = List.generate(albums.length, (index) => 0);
      getPhotos();
      _loadData();
    } else {}
  }

  Future<File?> cropImage() async {
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return null;
    }

    File? teptfile = await selectedImage.value.originFile;
    final file = await ImageCrop.cropImage(
      file: teptfile!,
      area: area,
    );

    return file;
  }

  void imagesInit() {
    albums.clear();
    albumPageNums.clear();
    imageList.clear();
    titleImageList.clear();
    isLoad(false);
    isSelect(false);
    isAlbum(false);
    albumIndex = 0;
    selectedImage(const AssetEntity(id: '', height: 0, width: 0, typeInt: 0));
  }

  void changeNotify(MethodCall call) {
    /// Register your callback.
    imagesInit();
    _loadPhotos();
  }
}

class MultiImageController extends ImageController {
  static MultiImageController get to => Get.find();

  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs;
  List<GlobalKey<CustomCropState>> cropKeyList = <GlobalKey<CustomCropState>>[];
  RxList<Widget> cropWidgetList = <Widget>[].obs;
  RxInt selectedIndex = 0.obs;
  RxDouble cropAspectRatio = 1.0.obs;

  @override
  void imagesInit() {
    super.imagesInit();
    selectedImages.clear();
    cropKeyList.clear();
    cropWidgetList.clear();
    selectedIndex(0);
    cropAspectRatio(1);
  }

  int selectedImageIndex(AssetEntity selectImage) {
    int index = selectedImages.indexWhere((image) => image == selectImage);
    return index;
  }

  void addImage(int index) async {
    GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();
    selectedImages.add(imageList[index]);
    selectedImage.value = imageList[index];
    cropKeyList.add(cropKey);

    AssetEntity asset = selectedImage.value;

    cropWidgetList.add(Obx(
      () => CustomCrop(
        image: AssetEntityImage(
          asset,
          thumbnailSize: const ThumbnailSize(500, 500),
        ).image,
        key: cropKey,
        areaFixed: true,
        aspectRatio: cropAspectRatio.value,
      ),
    ));

    selectedIndex(cropKeyList.length - 1);
  }

  void removeImage(int index) {
    cropWidgetList.removeAt(selectedImageIndex(selectedImage.value));
    cropKeyList.removeAt(selectedImageIndex(selectedImage.value));
    selectedImages.remove(imageList[index]);
    selectedIndex(cropKeyList.length - 1);
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
              color: mainWhite,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        albums.length,
                        (index) => Container(
                            height: 50, child: Text(albums[index].name))),
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
    for (int i = 0; i < cropKeyList.length; i++) {
      GlobalKey<CustomCropState> cropKey = cropKeyList[i];
      AssetEntity assetEntity = selectedImages[i];
      // final scale = cropKey.currentState!.scale;
      final area = cropKey.currentState!.area;
      if (area == null) {
        // cannot crop, widget is  not setup
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
