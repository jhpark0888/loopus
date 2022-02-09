import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/posting_add_image_screen.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_thumbnail_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/smarttextfield.dart';

class PostingModifyScreen extends StatelessWidget {
  PostingModifyScreen({Key? key, required this.postid}) : super(key: key);

  PostingAddController postingaddcontroller =
      Get.put(PostingAddController(route: PostaddRoute.update));

  int postid;
  late PostingDetailController controller = Get.find(tag: postid.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '포스팅 편집',
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/Arrow.svg'),
          ),
        ),
        body: ListView(
          children: [
            Obx(
              () => updatePostingTile(
                isSubtitleExist: true,
                onTap: () async {
                  postingtitleinput();
                  Get.to(() => PostingAddNameScreen(
                      postid: postid,
                      project_id: controller.post.value.project!.id,
                      route: PostaddRoute.update));
                },
                title: '포스팅 제목',
                subtitle: controller.post.value.title,
              ),
            ),
            updatePostingTile(
              isSubtitleExist: false,
              onTap: () async {
                postingcontentsinput();
                Get.to(() => PostingAddContentScreen(
                      postid: postid,
                      project_id: controller.post.value.project!.id,
                    ));
              },
              title: '포스팅 내용',
              subtitle: "",
            ),
            updatePostingTile(
              isSubtitleExist: false,
              onTap: () async {
                postingthumbnailinput();
                Get.to(() => PostingAddImageScreen(
                      postid: postid,
                      project_id: controller.post.value.project!.id,
                    ));
              },
              title: '대표 사진 변경',
              subtitle: '',
            ),
          ],
        ));
  }

  void postingtitleinput() {
    postingaddcontroller.titlecontroller.text = controller.post.value.title;
  }

  void postingcontentsinput() {
    postingaddcontroller.editorController.alllistclear();
    controller.post.value.contents?.forEach((content) {
      if (content.type == SmartTextType.IMAGE) {
        postingaddcontroller.editorController.types.add(content.type);
        postingaddcontroller.editorController.urlimageindex
            .add(content.content);
        postingaddcontroller.editorController.imageindex.add(null);
        postingaddcontroller.editorController.linkindex.add(null);
        postingaddcontroller.editorController.nodes.add(FocusNode());
        postingaddcontroller.editorController.textcontrollers
            .add(TextEditingController());
      } else if (content.type == SmartTextType.LINK) {
        postingaddcontroller.editorController.insert(
            index: controller.post.value.contents!.indexOf(content),
            text: content.content,
            type: content.type);
        postingaddcontroller.editorController
                .linkindex[controller.post.value.contents!.indexOf(content)] =
            content.url;
      } else {
        postingaddcontroller.editorController.insert(
            index: controller.post.value.contents!.indexOf(content),
            text: content.content,
            type: content.type);
      }
    });
  }

  void postingthumbnailinput() {
    postingtitleinput();
    postingcontentsinput();
    postingaddcontroller.postingurlthumbnail.value =
        controller.post.value.thumbnail ?? "";
    postingaddcontroller.thumbnail.value = File("");
  }
}

Widget updatePostingTile({
  required VoidCallback onTap,
  required String title,
  required String subtitle,
  required bool isSubtitleExist,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: (isSubtitleExist) ? 16 : 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kSubTitle2Style,
                ),
                if (isSubtitleExist)
                  SizedBox(
                    height: 12,
                  ),
                if (isSubtitleExist)
                  Text(
                    subtitle,
                    style: kSubTitle3Style,
                    overflow: TextOverflow.ellipsis,
                  )
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: mainblack,
            size: 28,
          ),
        ],
      ),
    ),
  );
}
