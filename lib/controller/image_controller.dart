import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/constant.dart';

enum ImageType {
  profile,
  thumnail,
  post,
}

class ImageController extends GetxController {
  static ImageController get to => Get.find();
  RxBool isImagePickerLoading = false.obs;

  Future<File?> getcropImage(ImageType type) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    print('pickedFile : $pickedFile');
    isImagePickerLoading.value = false;
    if (pickedFile != null) {
      if (type == ImageType.profile) {
        isImagePickerLoading.value = true;
        return await profilecropImage(pickedFile);
      } else if (type == ImageType.thumnail) {
        isImagePickerLoading.value = true;

        return await postingthumbnailcropImage(pickedFile);
      } else if (type == ImageType.post) {
        isImagePickerLoading.value = true;

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
      isImagePickerLoading.value = false;
    }
  }

  Future<File?> postingthumbnailcropImage(pickimage) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickimage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio3x2,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      isImagePickerLoading.value = false;
    }
  }

  Future<File?> postingcropImage(pickimage) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickimage.path,
        aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: mainblue,
            toolbarWidgetColor: mainWhite,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      isImagePickerLoading.value = false;
    }
  }
}