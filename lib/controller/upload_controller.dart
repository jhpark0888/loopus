import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadController extends GetxController {
  var albums = <AssetPathEntity>[].obs;
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  // RxList<File> imageList1 = <File>[].obs;
  Rx<AssetEntity>? selectedImage;
  // Rx<File>? selectedImage1;
  RxBool isLoad = false.obs;
  RxBool isSelect = false.obs;
  RxBool isImage = false.obs;
  RxList<List<AssetEntity>> titleImageList1 = <List<AssetEntity>>[].obs;
  RxList<File> titleImageList = <File>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    _loadPhotos();
    super.onInit();
  }

  void _loadData() async {
    headerTitle.value = albums.first.name;
    await _pagingPhotos().then((value) => isLoad.value = true);
  }

  Future<void> _pagingPhotos() async {
    print(albums.value);
    var photos = await albums.first.getAssetListPaged(page: 0, size: 30);
    // for (var i in photos) {
    //   File? file = await i.file;
    //   var path = file!.path;
    //   imageList1.add(file);
    // }
    // print('됐어요');
    imageList.addAll(photos);
    // print(imageList1.first);
    // selectedImage1 = imageList1.first.obs;
    selectedImage = imageList.first.obs;
  }
  Future<void> getPhotos()async {
    print(albums);
    for(int i = 0; i < albums.length; i ++){
     var photos = await albums.first.getAssetListPaged(page: i, size: 30);
     print('포토는 : $photos');
     print('album의 길이 : ${albums.length}');
    //  print(photos);
    //  File? file = await photos[0].file;
    //  titleImageList.add(file!);
     titleImageList1.add(photos);
    }
    print(titleImageList1.length);
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
      // message 권한 요청
    }
  }
}
