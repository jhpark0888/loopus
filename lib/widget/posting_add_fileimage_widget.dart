import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostingAdd_FileImageWidget extends StatelessWidget {
  PostingAdd_FileImageWidget({Key? key, required XFile this.image})
      : super(key: key);

  XFile image;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Center(
            child: Image.file(
          File(image.path),
          width: Get.width * 0.7,
          height: Get.height * 0.25,
        )));
  }
}
