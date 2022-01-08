import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/constant.dart';

enum ImageType {
  profile,
  thumnail,
  post,
}

Future<File?> getcropImage(ImageType type) async {
  XFile? pickimage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickimage != null) {
    if (type == ImageType.profile) {
      return await profilecropImage(pickimage);
    } else if (type == ImageType.thumnail) {
      return await postingthumbnailcropImage(pickimage);
    } else if (type == ImageType.post) {
      return await postingcropImage(pickimage);
    }
  }
}

Future<File?> profilecropImage(pickimage) async {
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: pickimage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: mainblue,
          toolbarWidgetColor: mainWhite,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  if (croppedFile != null) {
    return croppedFile;
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
        minimumAspectRatio: 1.0,
      ));
  if (croppedFile != null) {
    return croppedFile;
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
        minimumAspectRatio: 1.0,
      ));
  if (croppedFile != null) {
    return croppedFile;
  }
}
