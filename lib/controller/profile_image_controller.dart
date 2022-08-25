import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum ImageType {
  profile,
  thumbnail,
  post,
}

// class ImageController extends GetxController {
//   static ImageController get to => Get.find();
//   final ImageCropper _imageCropper = ImageCropper();
//   RxBool isProfileImagePickerLoading = false.obs;
//   RxBool isPostingImagePickerLoading = false.obs;
//   RxBool isThumbnailImagePickerLoading = false.obs;

//   Future<File?> getcropImage(ImageType type) async {
//     XFile? pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     print('pickedFile : $pickedFile');
//     isProfileImagePickerLoading.value = false;
//     if (pickedFile != null) {
//       if (type == ImageType.profile) {
//         isProfileImagePickerLoading.value = true;
//         return await profilecropImage(pickedFile);
//       } else if (type == ImageType.thumbnail) {
//         isThumbnailImagePickerLoading.value = true;

//         return await postingthumbnailcropImage(pickedFile);
//       }
//     }
//   }

//   Future<List<File>> getMultiImage(ImageType type) async {
//     List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
//     print('pickedFile : $pickedFiles');
//     isProfileImagePickerLoading.value = false;
//     if (pickedFiles != null) {
//       isPostingImagePickerLoading.value = true;

//       return await postingcropImage(pickedFiles);
//     } else {
//       return [];
//     }
//   }

//   Future<File?> profilecropImage(pickimage) async {
//     File? croppedFile = await _imageCropper.cropImage(
//         maxWidth: Get.width.toInt(),
//         maxHeight: Get.width.toInt(),
//         compressQuality: 90,
//         cropStyle: CropStyle.circle,
//         sourcePath: pickimage.path,
//         aspectRatioPresets: [
//           CropAspectRatioPreset.original,
//         ],
//         androidUiSettings: const AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: mainblue,
//             toolbarWidgetColor: mainWhite,
//             hideBottomControls: true,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         iosUiSettings: const IOSUiSettings(
//           aspectRatioPickerButtonHidden: true,
//           minimumAspectRatio: 1 / 1,
//         ));
//     if (croppedFile != null) {
//       print(croppedFile);
//       return croppedFile;
//     } else {
//       isProfileImagePickerLoading.value = false;
//     }
//   }

//   Future<File?> postingthumbnailcropImage(pickimage) async {
//     File? croppedFile = await _imageCropper.cropImage(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         compressQuality: 90,
//         // compressQuality: 90,
//         aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
//         sourcePath: pickimage.path,
//         androidUiSettings: const AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: mainblue,
//             toolbarWidgetColor: mainWhite,
//             lockAspectRatio: true),
//         iosUiSettings: const IOSUiSettings(
//           aspectRatioPickerButtonHidden: true,
//           minimumAspectRatio: 1 / 2,
//         ));
//     if (croppedFile != null) {
//       return croppedFile;
//     } else {
//       isThumbnailImagePickerLoading.value = false;
//     }
//   }

//   Future<List<File>> postingcropImage(pickimages) async {
//     List<File> images = [];
//     for (XFile image in pickimages) {
//       File? croppedFile = await _imageCropper.cropImage(
//           aspectRatioPresets: [
//             CropAspectRatioPreset.ratio16x9,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio5x4
//           ],
//           maxWidth: 1920,
//           maxHeight: 1080,
//           compressQuality: 50,
//           sourcePath: image.path,
//           androidUiSettings: const AndroidUiSettings(
//               toolbarTitle: 'Cropper',
//               toolbarColor: mainblue,
//               toolbarWidgetColor: mainWhite,
//               lockAspectRatio: false),
//           iosUiSettings: const IOSUiSettings(
//             // resetAspectRatioEnabled: false,
//             aspectRatioLockDimensionSwapEnabled: true,
//             aspectRatioLockEnabled: true,
//             aspectRatioPickerButtonHidden: false,
//             minimumAspectRatio: 1.0,
//           ));
//       if (croppedFile != null) {
//         // isImagePickerLoading.value = false;
//         print(croppedFile);
//         images.add(croppedFile);
//       } else {
//         isPostingImagePickerLoading.value = false;
//       }
//     }
//     isPostingImagePickerLoading.value = false;
//     return images;
//   }
// }

class ProfileImageController extends GetxController {
  static ProfileImageController get to => Get.find();
  var albums = <AssetPathEntity>[].obs;
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  Rx<AssetEntity> selectedImage =
      AssetEntity(id: '', height: 0, width: 0, typeInt: 0).obs;
  Rx<File>? croppedImage;
  RxBool isLoad = false.obs;
  RxBool isSelect = false.obs;
  RxBool isImage = false.obs;
  RxBool isCropped = false.obs;
  RxList<List<AssetEntity>> titleImageList1 = <List<AssetEntity>>[].obs;
  List<int> albumPageNums = <int>[].obs;
  int albumIndex = 0;
  RxList<File> titleImageList = <File>[].obs;
  RefreshController refreshController = RefreshController();
  GlobalKey<CustomCropState> cropKey = GlobalKey<CustomCropState>();

  void onInit() {
    _loadPhotos();
    super.onInit();
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
}
