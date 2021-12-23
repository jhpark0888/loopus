import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:get/get.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/blue_button.dart';
import 'package:loopus/widget/postingeditor.dart';
import 'package:flutter/rendering.dart';

class PostingAddImageScreen extends StatelessWidget {
  PostingAddImageScreen({Key? key, required this.project_id}) : super(key: key);
  PostingAddController postingAddController = Get.find();
  int project_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '대표 사진 설정',
          actions: [
            TextButton(
              onPressed: () async {
                await postingAddRequest(project_id);
                // Get.back();
                // Get.back();
                // Get.back();
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: getReadEditor(postingAddController
                        .postcontroller.document
                        .toDelta()
                        .toJson()),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class _MyAppSpace extends StatelessWidget {
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: BlueTextButton(
                              width: 104,
                              height: 30,
                              onTap: () async {
                                postingAddController
                                    .thumbnail(await getcropImage("thumbnail"));
                              },
                              text: '대표 사진 변경',
                            )),
                      ),
                      SizedBox(
                        height: 16,
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

  Widget getImage(controller) {
    return Container(
      width: Get.width,
      height: Get.width * 2 / 3,
      child: Opacity(
        opacity: 0.25,
        child: Obx(
          () => controller.thumbnail.value.path == ""
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpol9gKXdfW9lUlFiWuujRUhCQbw9oHVIkQ&usqp=CAU')
              : Image.file(
                  controller.thumbnail.value,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget getExpendTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
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
