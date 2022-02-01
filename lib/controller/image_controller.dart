import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
      } else if (type == ImageType.post) {
        isPostingImagePickerLoading.value = true;

        return await postingcropImage(pickedFile);
      }
    }
  }

  Future<File?> profilecropImage(pickimage) async {
    File? croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pickimage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          minimumAspectRatio: 1 / 1,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      isProfileImagePickerLoading.value = false;
    }
  }

  Future<File?> postingthumbnailcropImage(pickimage) async {
    File? croppedFile = await ImageCropper.cropImage(
        // maxWidth: 1920,
        // maxHeight: 1080,
        // compressQuality: 90,
        sourcePath: pickimage.path,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          aspectRatioLockEnabled: true,
          minimumAspectRatio: 2 / 1,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      isThumbnailImagePickerLoading.value = false;
    }
  }

  Future<File?> postingcropImage(pickimage) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickimage.path,
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
      return croppedFile;
    } else {
      isPostingImagePickerLoading.value = false;
    }
  }
}
