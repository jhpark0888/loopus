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

class PostingAddNameScreen extends StatelessWidget {
  PostingAddNameScreen({Key? key, required this.project_id}) : super(key: key);
  PostingAddController postingcontroller = Get.put(PostingAddController());
  int project_id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          actions: [
            TextButton(
              onPressed: () {
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
              TextField(
                autocorrect: false,
                maxLength: 40,
                minLines: 1,
                maxLines: 2,
                autofocus: true,
                style: kSubTitle1Style,
                cursorColor: mainblack,
                cursorWidth: 1.5,
                cursorRadius: Radius.circular(2),
                controller: postingcontroller.titlecontroller,
                decoration: InputDecoration(
                  hintText: '포스팅 제목...',
                  hintStyle: kSubTitle1Style.copyWith(
                    color: mainblack.withOpacity(0.38),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: BorderSide(
                        color: mainblack.withOpacity(
                          0.6,
                        ),
                        width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainblack, width: 1),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
