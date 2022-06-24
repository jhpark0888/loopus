import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loopus/careertest.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:image_crop/image_crop.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key, required this.file1}) : super(key: key);
  File file1;
  final cropkey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: '테스트'),
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    print(file1);
                  },
                  child: Container(
                      color: mainblack,
                      child: Crop(image: Image.file(file1).image,key: cropkey,aspectRatio: 4.0/3.0, )),
                  
                  )),
          TextButton(
              onPressed: () {
                cropImage();
              },
              child: Text('크롭'))
        ],
      ),
    );
  }

  Future<void> cropImage() async {
    final scale = cropkey.currentState!.scale;
    final area = cropkey.currentState!.area;
    if (area == null) {
print(area);      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: file1,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    debugPrint('$file');
  }
}
