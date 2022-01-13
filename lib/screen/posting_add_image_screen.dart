import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/blue_button.dart';
import 'package:loopus/widget/post_add_content_widget.dart';
import 'package:flutter/rendering.dart';

class PostingAddImageScreen extends StatelessWidget {
  PostingAddImageScreen({Key? key, required this.project_id}) : super(key: key);
  PostingAddController postingAddController = Get.find();

  int project_id;
  List<PostAddContentWidget> contentlist = [];

  @override
  Widget build(BuildContext context) {
    contentlist.clear();
    for (int i = 0;
        i < postingAddController.editorController.types.length;
        i++) {
      contentlist.add(PostAddContentWidget(index: i));
    }
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              bottomBorder: false,
              title: '대표 사진 설정',
              actions: [
                TextButton(
                  onPressed: () async {
                    postingAddController.isPostingUploading.value = true;
                    await addposting(project_id).then((value) {
                      postingAddController.isPostingUploading.value = false;
                    });
                  },
                  child: Text(
                    '올리기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainblue,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MyAppSpace(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: contentlist)
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (postingAddController.isPostingUploading.value == true)
            Container(
              height: Get.height,
              width: Get.width,
              color: mainblack.withOpacity(0.3),
              child: Image.asset(
                'assets/icons/loading.gif',
                scale: 6,
              ),
            ),
        ],
      ),
    );
  }
}

class _MyAppSpace extends StatelessWidget {
  final ImageController imageController = Get.find();

  @override
  Widget build(BuildContext context) {
    PostingAddController postingAddController = Get.find();
    return LayoutBuilder(
      builder: (context, c) {
        return Stack(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                getImage(postingAddController),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32,
                      ),
                      getExpendTitle(
                        postingAddController.titlecontroller.text,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                          right: 16,
                        ),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: BlueTextButton(
                              onTap: () async {
                                imageController.isImagePickerLoading.value =
                                    true;
                                postingAddController.thumbnail(
                                    await imageController
                                        .getcropImage(ImageType.thumnail)
                                        .then((value) {
                                  imageController.isImagePickerLoading.value =
                                      false;
                                }));
                              },
                              text: '대표 사진 변경',
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getImage(PostingAddController controller) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Opacity(
        opacity: 0.25,
        child: Obx(() {
          if (controller.thumbnail.value.path != "") {
            return Image.file(
              controller.thumbnail.value,
              fit: BoxFit.cover,
            );
          } else if (controller.editorController.imageindex
              .whereType<File>()
              .isNotEmpty) {
            return Image.file(
              controller.editorController.imageindex.whereType<File>().first,
              fit: BoxFit.cover,
            );
          } else {
            return CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    'https://cdn.pixabay.com/photo/2021/12/20/15/01/christmas-tree-6883263_1280.jpg');
          }
        }),
      ),
    );
  }

  Widget getExpendTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          height: 1.5,
          color: mainblack,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
