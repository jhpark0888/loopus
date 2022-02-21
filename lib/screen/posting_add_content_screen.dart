// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/posting_add_image_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/editortoolbar.dart';
import 'package:loopus/widget/post_content_widget.dart';
import 'package:loopus/widget/smarttextfield.dart';

class PostingAddContentScreen extends StatelessWidget {
  PostingAddContentScreen({Key? key, this.postid, required this.project_id})
      : super(key: key);
  final PostingAddController postingAddController = Get.find();
  final ImageController _imageController = Get.put(ImageController());
  // EditorController editorController = Get.put(EditorController());
  int? postid;
  int project_id;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              bottomBorder: false,
              actions: [
                postingAddController.route != PostaddRoute.update
                    ? TextButton(
                        onPressed: () {
                          postingAddController.editorController
                              .checkPostingContent();
                          if (postingAddController
                                  .isPostingContentEmpty.value ==
                              false) {
                            postingAddController.editorController
                                .nodeAt(
                                    postingAddController.editorController.focus)
                                .unfocus();
                            Get.to(() => PostingAddImageScreen(
                                  project_id: project_id,
                                ));
                          } else {
                            ModalController.to
                                .showCustomDialog('내용을 입력해주세요', 1000);
                          }
                          // postingAddController.editorController
                          //     .nodeAt(postingAddController.editorController.focus)
                          //     .unfocus();
                        },
                        child: Text('다음',
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
                                onPressed: () async {
                                  postingAddController.editorController
                                      .checkPostingContent();
                                  if (postingAddController
                                          .isPostingContentEmpty.value ==
                                      false) {
                                    PostingDetailController controller =
                                        Get.find<PostingDetailController>(
                                            tag: postid.toString());
                                    controller.isPostUpdateLoading.value = true;
                                    await updateposting(
                                            postid!, PostingUpdateType.contents)
                                        .then((value) {
                                      controller.isPostUpdateLoading(false);
                                    });
                                  } else {
                                    ModalController.to
                                        .showCustomDialog('내용을 입력해주세요', 1000);
                                  }
                                  // postingAddController.editorController
                                  //     .nodeAt(postingAddController.editorController.focus)
                                  //     .unfocus();
                                },
                                child: Text('저장',
                                    style: kSubTitle2Style.copyWith(
                                        color: mainblue)),
                              ),
                      )
              ],
              title: '포스팅 내용',
            ),
            body: Column(
              children: [
                Obx(
                  () => Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if (postingAddController.editorController.types.last ==
                          SmartTextType.IMAGE) {
                        postingAddController.editorController.insert(
                            index: postingAddController
                                .editorController.types.length);
                        postingAddController.editorController
                            .setFocus(SmartTextType.T);
                      } else {
                        postingAddController.editorController.nodes.last
                            .requestFocus();
                      }
                    },
                    child: ListView(
                      children: postingAddController
                          .editorController.smarttextfieldlist,
                    ),
                  )),
                ),
                Obx(
                  () => EditorToolbar(
                      selectedType: postingAddController
                          .editorController.selectedType.value,
                      onSelected:
                          postingAddController.editorController.setType),
                )
              ],
            ),
          ),
          if (_imageController.isPostingImagePickerLoading.value == true)
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
