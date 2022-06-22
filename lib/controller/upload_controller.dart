import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadController extends GetxController {
  var albums = <AssetPathEntity>[].obs;
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  RxList<AssetEntity>? selectedImages;
  Rx<AssetEntity>? selectedImage;
  Rx<File>? croppedImage;
  RxBool isLoad = false.obs;
  RxBool isSelect = false.obs;
  RxBool isImage = false.obs;
  RxBool isCropped = false.obs;
  RxDouble? croppedHeight;
  RxDouble? croppedWidth;
  RxList<List<AssetEntity>> titleImageList1 = <List<AssetEntity>>[].obs;
  RxList<File> titleImageList = <File>[].obs;
  @override
  void onInit() {
    _loadPhotos();
    super.onInit();
  }

  void _loadData() async {
    headerTitle.value = albums.first.name;
    await _pagingPhotos().then((value) => isLoad.value = true);
  }

  Future<void> _pagingPhotos() async {
    var photos = await albums.first.getAssetListPaged(page: 0, size: 30);

    imageList.addAll(photos);
 
    selectedImages = [imageList.first].obs;
    selectedImage = imageList.first.obs;
  }
  Future<void> getPhotos()async {
    print(albums);
    for(int i = 0; i < albums.length; i ++){
     var photos = await albums.first.getAssetListPaged(page: i, size: 30);
     titleImageList1.add(photos);
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
          getPhotos();
      _loadData();
    } else {

    }
  }
}
