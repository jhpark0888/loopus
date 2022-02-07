// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class PostingAddNameScreen extends StatelessWidget {
  PostingAddNameScreen(
      {Key? key, this.postid, required this.project_id, required this.route})
      : super(key: key);
  late PostingAddController postingAddController =
      Get.put(PostingAddController(route: route));
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
            postingAddController.route != PostaddRoute.update
                ? Obx(
                    () => TextButton(
                      onPressed: postingAddController.isPostingTitleEmpty.value
                          ? () {}
                          : () {
                              _focusNode.unfocus();
                              postingAddController.isPostingContentEmpty.value =
                                  false;

                              Get.to(() => PostingAddContentScreen(
                                    project_id: project_id,
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
                                    _focusNode.unfocus();
                                    controller.isPostUpdateLoading.value = true;
                                    await updateposting(
                                        postid!, PostingUpdateType.title);
                                    await getposting(postid!).then((value) {
                                      controller.post(
                                          Post.fromJson(value['posting_info']));

                                      controller.isPostUpdateLoading(false);
                                    });

                                    Get.back();
                                  },
                            child: Text(
                              '저장',
                              style: kSubTitle2Style.copyWith(
                                color: postingAddController
                                        .isPostingTitleEmpty.value
                                    ? mainblack.withOpacity(0.38)
                                    : mainblue,
                              ),
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
                  maxLength: 60,
                  textController: postingAddController.titlecontroller,
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
