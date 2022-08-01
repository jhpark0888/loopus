import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});
  ScrollController scrollController = ScrollController();
  TextEditingController textcontroller = TextEditingController();
  TextEditingController tagcontroller = TextEditingController();
  TextEditingController linkcontroller = TextEditingController();
  RxBool isPostingUploading = false.obs;
  RxBool isAddLink = false.obs;
  RxBool isAddImage = false.obs;
  RxList<File> images = <File>[].obs;
  RxList<LinkWidget> scrapList = <LinkWidget>[].obs;
  RxInt lines = 0.obs;
  RxBool isPostingTitleEmpty = true.obs;
  RxBool isPostingContentEmpty = true.obs;
  RxBool isLinkTextEmpty = true.obs;
  RxBool isTagClick = false.obs;
  RxBool keyControllerAtive = false.obs;
  PostaddRoute route;

  void onInit() {
    textcontroller.addListener(() {
      if (textcontroller.text.trim().isEmpty) {
        isPostingTitleEmpty.value = true;
      } else {
        isPostingTitleEmpty.value = false;
      }
    });
    linkcontroller.addListener(() {
      if (linkcontroller.text.trim().isEmpty) {
        isLinkTextEmpty.value = true;
      } else {
        isLinkTextEmpty.value = false;
      }
    });
    _loadPhotos();
    super.onInit();
  }

  var albums = <AssetPathEntity>[].obs;
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs;
  List<GlobalKey<CustomCropState>> cropKeyList = <GlobalKey<CustomCropState>>[];
  RxList<Widget> cropWidgetList = <Widget>[].obs;
  Rx<AssetEntity> selectedImage =
      AssetEntity(id: '', height: 0, width: 0, typeInt: 0).obs;
  RxInt selectedIndex = 0.obs;
  Rx<File>? croppedImage;
  RxBool isLoad = false.obs;
  RxBool isSelect = false.obs;
  RxBool isImage = false.obs;
  RxBool isCropped = false.obs;
  RxDouble cropAspectRatio = 1.0.obs;
  // Rx<Size> selectedImageSize = Size(Get.width, Get.height).obs;
  RxList<List<AssetEntity>> titleImageList1 = <List<AssetEntity>>[].obs;
  List<int> albumPageNums = <int>[].obs;
  int albumIndex = 0;
  RxList<File> titleImageList = <File>[].obs;
  RefreshController refreshController = RefreshController();
  TransformationController transformationController =
      TransformationController();
  // @override
  // void onInit() {
  //   _loadPhotos();
  //   super.onInit();
  // }

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

    // selectedImages = [imageList.first].obs;
    // selectedImage = imageList.first.obs;
    // cropKeyList.add(GlobalKey<CropState>());
  }

  Future<void> getPhotos() async {
    print(albums);
    for (int i = 0; i < albums.length; i++) {
      var photos = await albums[i].getAssetListPaged(page: 0, size: 30);
      titleImageList1.add(photos);
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

  int selectedImageIndex(AssetEntity selectImage) {
    int index = selectedImages.indexWhere((image) => image == selectImage);
    return index;
  }
}
