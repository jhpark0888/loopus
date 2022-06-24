import 'dart:io';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:loopus/constant.dart';

enum ImageType {
  profile,
  thumbnail,
  post,
}

class ImageController extends GetxController {
  static ImageController get to => Get.find();
  final ImageCropper _imageCropper = ImageCropper();
  RxBool isProfileImagePickerLoading = false.obs;
  RxBool isPostingImagePickerLoading = false.obs;
  RxBool isThumbnailImagePickerLoading = false.obs;

  Future<File?> getcropImage(ImageType type) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    print('pickedFile : $pickedFile');
    isProfileImagePickerLoading.value = false;
    if (pickedFile != null) {
      if (type == ImageType.profile) {
        isProfileImagePickerLoading.value = true;
        return await profilecropImage(pickedFile);
      } else if (type == ImageType.thumbnail) {
        isThumbnailImagePickerLoading.value = true;

        return await postingthumbnailcropImage(pickedFile);
      }
    }
  }

  Future<List<File>> getMultiImage(ImageType type) async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    print('pickedFile : $pickedFiles');
    isProfileImagePickerLoading.value = false;
    if (pickedFiles != null) {
      isPostingImagePickerLoading.value = true;

      return await postingcropImage(pickedFiles);
    } else {
      return [];
    }
  }

  Future<File?> profilecropImage(pickimage) async {
    File? croppedFile = await _imageCropper.cropImage(
        maxWidth: Get.width.toInt(),
        maxHeight: Get.width.toInt(),
        compressQuality: 90,
        cropStyle: CropStyle.rectangle,
        sourcePath: pickimage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          minimumAspectRatio: 1 / 1,
        ));
    if (croppedFile != null) {
      print(croppedFile);
      return croppedFile;
    } else {
      isProfileImagePickerLoading.value = false;
    }
  }

  Future<File?> postingthumbnailcropImage(pickimage) async {
    File? croppedFile = await _imageCropper.cropImage(
        maxWidth: 1920,
        maxHeight: 1080,
        compressQuality: 90,
        // compressQuality: 90,
        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
        sourcePath: pickimage.path,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          minimumAspectRatio: 1 / 2,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      isThumbnailImagePickerLoading.value = false;
    }
  }

  Future<List<File>> postingcropImage(pickimages) async {
    List<File> images = [];
    for (XFile image in pickimages) {
      File? croppedFile = await _imageCropper.cropImage(
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x4
          ],
          maxWidth: 1920,
          maxHeight: 1080,
          compressQuality: 50,
          sourcePath: image.path,
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: mainblue,
              toolbarWidgetColor: mainWhite,
              lockAspectRatio: false),
          iosUiSettings: const IOSUiSettings(
            // resetAspectRatioEnabled: false,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: false,
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        // isImagePickerLoading.value = false;
        print(croppedFile);
        images.add(croppedFile);
      } else {
        isPostingImagePickerLoading.value = false;
      }
    }
    isPostingImagePickerLoading.value = false;
    return images;
  }
}
