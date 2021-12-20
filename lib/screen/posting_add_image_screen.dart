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
import 'package:loopus/widget/blue_button.dart';
import 'package:loopus/widget/customlinkstylewidget.dart';
import 'package:loopus/widget/postingeditor.dart';

class PostingAddImageScreen extends StatelessWidget {
  PostingAddImageScreen({Key? key}) : super(key: key);
  PostingAddController postingAddController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Obx(
                    () => Container(
                      width: Get.width,
                      height: Get.width * 2 / 3,
                      child: postingAddController.thumbnail.value.path == ""
                          ? CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl:
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpol9gKXdfW9lUlFiWuujRUhCQbw9oHVIkQ&usqp=CAU')
                          : Image.file(
                              postingAddController.thumbnail.value,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset("assets/icons/Arrow.svg"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            Center(
                              child: Text(
                                '대표 사진 설정',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              // splashFactory: NoSplash.splashFactory,
                              onTap: () {},
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
                        Text(
                          postingAddController.titlecontroller.text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: BlueTextButton(
                              width: 104,
                              height: 30,
                              onpressed: () async {
                                postingAddController
                                    .thumbnail(await getcropImage("thumbnail"));
                              },
                              text: '대표 사진 변경',
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: PostingEditor(
                    controller: postingAddController.postcontroller,
                    readonly: true),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
