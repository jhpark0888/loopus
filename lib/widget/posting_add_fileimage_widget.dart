import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostingAdd_FileImageWidget extends StatelessWidget {
  PostingAdd_FileImageWidget({Key? key, required File this.image})
      : super(key: key);

  File image;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Center(
          child: Image.file(image),
        ));
  }
}
