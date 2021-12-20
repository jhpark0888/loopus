// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/screen/posting_add_image_screen.dart';
import 'package:loopus/widget/customlinkstylewidget.dart';
import 'package:loopus/widget/postingeditor.dart';

class PostingAddContentScreen extends StatelessWidget {
  PostingAddContentScreen({Key? key}) : super(key: key);
  PostingAddController postingAddController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/Arrow.svg"),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(() => PostingAddImageScreen());
              },
              child: Text(
                '다음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblue,
                ),
              ),
            ),
          ],
          title: const Text(
            '포스팅 내용',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: PostingEditor(
                    placeholder: '포스팅 내용을 작성해주세요...',
                    controller: postingAddController.postcontroller,
                    readonly: false),
              ),
            ),
            QuillToolbar(
              children: [
                SelectHeaderStyleButton(
                  controller: postingAddController.postcontroller,
                  iconSize: 25,
                ),
                ToggleStyleButton(
                  attribute: Attribute.bold,
                  icon: Icons.format_bold,
                  iconSize: 25,
                  controller: postingAddController.postcontroller,
                ),
                ToggleStyleButton(
                  attribute: Attribute.underline,
                  icon: Icons.format_underline,
                  iconSize: 25,
                  controller: postingAddController.postcontroller,
                ),
                ImageButton(
                  icon: Icons.image,
                  iconSize: 25,
                  controller: postingAddController.postcontroller,
                  onImagePickCallback: (file) async {
                    File? image = await postingcropImage(file);

                    return image != null ? image.path : null;
                  },
                  mediaPickSettingSelector: (context) async {
                    return MediaPickSetting.Gallery;
                  },
                ),
                CustomLinkStyleButton(
                  controller: postingAddController.postcontroller,
                  iconSize: 25,
                ),
              ],
            ),
          ],
        ));
  }
}
