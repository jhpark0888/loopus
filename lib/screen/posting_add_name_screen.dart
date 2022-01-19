// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class PostingAddNameScreen extends StatelessWidget {
  PostingAddNameScreen({Key? key, required this.project_id}) : super(key: key);
  final PostingAddController postingcontroller =
      Get.put(PostingAddController());
  final FocusNode _focusNode = FocusNode();
  int project_id;

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
            TextButton(
              onPressed: () {
                _focusNode.unfocus();
                Get.to(() => PostingAddContentScreen(
                      project_id: project_id,
                    ));
              },
              child: Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                  color: mainblue,
                ),
              ),
            ),
          ],
          title: '포스팅 제목',
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            children: [
              Text(
                '포스팅 제목을 작성해주세요',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '나중에 얼마든지 수정할 수 있어요',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              CustomTextField(
                  counterText: null,
                  maxLength: 40,
                  textController: postingcontroller.titlecontroller,
                  hintText: '포스팅 제목...',
                  validator: null,
                  obscureText: false,
                  maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}
