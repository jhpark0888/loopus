// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class PostingAddImagesScreen extends StatelessWidget {
  PostingAddImagesScreen(
      {Key? key, this.postid, required this.project_id, required this.route})
      : super(key: key);

  final ImageController _imageController = Get.put(ImageController());
  late PostingAddController postingAddController =
      Get.put(PostingAddController(route: route));
  TagController tagController = Get.put(TagController(tagtype: Tagtype.Posting),
      tag: Tagtype.Posting.toString());

  final FocusNode _focusNode = FocusNode();
  int project_id;
  int? postid;
  PostaddRoute route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          actions: [
            Obx(
              () => TextButton(
                onPressed: () {
                  Get.to(() => PostingAddNameScreen(
                        project_id: project_id,
                        route: route,
                      ));
                },
                child: Text(
                  '다음',
                  style: kSubTitle2Style.copyWith(
                    color: postingAddController.isPostingTitleEmpty.value
                        ? mainblack.withOpacity(0.38)
                        : mainblue,
                  ),
                ),
              ),
            )
          ],
          title: '포스팅 이미지',
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '게시할 이미지',
                      style: kSubTitle2Style.copyWith(
                        color: mainblue,
                      ),
                    ),
                    TextSpan(
                      text: '들을 선택해주세요',
                      style: kSubTitle2Style,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              IconButton(
                  onPressed: () async {
                    postingAddController.images.value =
                        await _imageController.getMultiImage(ImageType.profile);
                  },
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    size: 50,
                  )),
              SizedBox(
                height: 32,
              ),
              Flexible(
                  child: Obx(
                () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Image.file(
                      postingAddController.images[index],
                      width: 100,
                      height: 100,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 8);
                  },
                  itemCount: postingAddController.images.length,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
