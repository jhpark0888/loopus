import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/blue_button.dart';
import 'package:loopus/widget/post_add_content_widget.dart';

import '../controller/modal_controller.dart';

class PostingAddImageScreen extends StatelessWidget {
  PostingAddImageScreen({Key? key, this.postid, required this.project_id})
      : super(key: key);
  final PostingAddController postingAddController = Get.find();
  final ImageController _imageController = Get.put(ImageController());

  int project_id;
  int? postid;
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
                postingAddController.route != PostaddRoute.update
                    ? TextButton(
                        onPressed: () async {
                          postingAddController.isPostingUploading.value = true;
                          await addposting(
                                  project_id, postingAddController.route)
                              .then((value) {
                            postingAddController.isPostingUploading.value =
                                false;
                          });
                        },
                        child: Text('올리기',
                            style: kSubTitle2Style.copyWith(color: mainblue)),
                      )
                    : Obx(
                        () => Get.find<PostingDetailController>(
                                    tag: postid.toString())
                                .isPostUpdateLoading
                                .value
                            ? Image.asset(
                                'assets/icons/loading.gif',
                                scale: 9,
                              )
                            : TextButton(
                                onPressed: postingAddController
                                        .isPostingTitleEmpty.value
                                    ? () {}
                                    : () async {
                                        PostingDetailController controller =
                                            Get.find<PostingDetailController>(
                                                tag: postid.toString());
                                        controller.isPostUpdateLoading.value =
                                            true;
                                        await updateposting(postid!,
                                                PostingUpdateType.thumbnail)
                                            .then((value) {
                                          controller.isPostUpdateLoading(false);
                                        });
                                      },
                                child: Text(
                                  '저장',
                                  style: kSubTitle2Style.copyWith(
                                    color: mainblue,
                                  ),
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
          if (postingAddController.isPostingUploading.value == true ||
              _imageController.isThumbnailImagePickerLoading.value == true)
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
                              hoverTag: '포스팅 대표 사진 변경',
                              onTap: () async {
                                imageController
                                    .isThumbnailImagePickerLoading.value = true;
                                imageController
                                    .getcropImage(ImageType.thumbnail)
                                    .then((value) {
                                  postingAddController.thumbnail(value);
                                  imageController.isThumbnailImagePickerLoading
                                      .value = false;
                                });
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
          } else if (controller.postingurlthumbnail.value != "") {
            return Image.network(
              controller.postingurlthumbnail.value,
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
            return Image.asset(
              'assets/illustrations/default_image.png',
              fit: BoxFit.cover,
            );
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
        style: kHeaderH2Style,
      ),
    );
  }
}
