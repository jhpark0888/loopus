import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/utils/custom_crop.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/keyboard_visibility_text_widget.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import '../controller/modal_controller.dart';

class PostingAddScreen extends StatelessWidget {
  PostingAddScreen(
      {Key? key, this.postid, required this.project_id, required this.route})
      : super(key: key);
  late PostingAddController postingAddController =
      Get.put(PostingAddController(route: route));
  final MultiImageController _imageController =
      Get.put((MultiImageController()));
  TagController tagController = Get.put(TagController(tagtype: Tagtype.Posting),
      tag: Tagtype.Posting.toString());
  KeyController keyController =
      Get.put(KeyController(isTextField: false.obs, tag: Tagtype.Posting));
  int project_id;
  int? postid;
  PostaddRoute route;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        postingAddController.isTagClick.value = false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '포스트 작성',
          actions: [
            Obx(() => Center(child: uploadButton())),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: Obx(
          () => ScrollNoneffectWidget(
            child: SingleChildScrollView(
              controller: postingAddController.scrollController,
              child: Padding(
                padding: EdgeInsets.only(bottom: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Column(children: [
                        postingAddController.isAddLink.value == false
                            ? postingAddController.isAddImage.value == true
                                ? Obx(
                                    () => Stack(children: [
                                      SwiperWidget(
                                        items:
                                            postingAddController.images.value,
                                        swiperType: SwiperType.file,
                                        aspectRatio: postingAddController
                                            .cropAspectRatio.value,
                                      ),
                                      Positioned(
                                          child: GestureDetector(
                                              onTap: () => imageChange(),
                                              child: Text('사진 수정하기',
                                                  style: kmain.copyWith(
                                                      color: mainblue))),
                                          right: 20,
                                          bottom: 5)
                                    ]),
                                  )
                                : Column(children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: addButton(
                                                title: '이미지',
                                                titleEng: 'image',
                                                ontap: () {
                                                  Get.to(() => UploadScreen());
                                                }),
                                          ),
                                          const SizedBox(
                                            width: 14,
                                          ),
                                          Expanded(
                                            child: addButton(
                                                title: '링크',
                                                titleEng: 'link',
                                                ontap: () {
                                                  Get.to(() =>
                                                      PostingAddLinkScreen());
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                  ])
                            : SwiperWidget(
                                items: postingAddController.scrapList
                                    .map((linkwidget) => linkwidget.url)
                                    .toList(),
                                swiperType: SwiperType.link,
                              )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(thickness: 0.5),
                            LayoutBuilder(builder: (context, constraints) {
                              return NoUlTextField(
                                controller: postingAddController.textcontroller,
                                obscureText: false,
                                hintText: '내용을 입력해주세요',
                              );
                            }),
                            Divider(key: keyController.viewKey, thickness: 0.5),
                            const SizedBox(height: 14),
                            const Text('태그', style: kmain),
                            const SizedBox(height: 14),
                            Obx(() => tagController.selectedtaglist.isEmpty
                                ? Text('입력시 기업이 컨택할 가능성이 높아져요',
                                    style: kmain.copyWith(
                                        color: maingray.withOpacity(0.5)))
                                : Container(
                                    width: Get.width,
                                    child: Wrap(
                                        spacing: 7,
                                        runSpacing: 7,
                                        direction: Axis.horizontal,
                                        children:
                                            tagController.selectedtaglist))),
                            SizedBox(height: 28),
                            KeyboardVisibilityTextWidget(
                              boolea: postingAddController.isTagClick,
                              controller: postingAddController
                                  .keyboardVisibilityController,
                              textfield: CustomTextField(
                                textController:
                                    tagController.tagsearchContoller,
                                autofocus: false,
                                hintText: '태그를 입력해주세요',
                                validator: (_) {},
                                obscureText: false,
                                maxLines: 2,
                                counterText: '',
                                maxLength: null,
                                textInputAction: TextInputAction.done,
                                ontap: () async {
                                  // await Future.delayed(
                                  //     Duration(milliseconds: 400));
                                  // Scrollable.ensureVisible(
                                  //     keyController.viewKey.currentContext!,
                                  //     curve: Curves.easeOut,
                                  //     duration:
                                  //         const Duration(milliseconds: 300));

                                  postingAddController.isTagClick(true);
                                  if (postingAddController.getTagList.value ==
                                      true) {
                                    postingAddController.getTagList.value =
                                        true;
                                  }
                                  // }
                                  // );
                                },
                                onfieldSubmitted: (string) {
                                  if (string.trim() != '') {
                                    TagController controller =
                                        Get.find<TagController>(
                                            tag: Tagtype.Posting.toString());
                                    print(controller.searchtaglist.where(
                                        (element) => element.tag == string));
                                    // if (controller.selectedtaglist.length < 3) {
                                    if (controller.searchtaglist
                                        .where(
                                            (element) => element.tag == string)
                                        .isNotEmpty) {
                                      controller.selectedtaglist.add(
                                          SelectedTagWidget(
                                              id: controller.searchtaglist
                                                  .where((element) =>
                                                      element.tag == string)
                                                  .first
                                                  .id,
                                              text: string,
                                              selecttagtype:
                                                  SelectTagtype.interesting,
                                              tagtype: Tagtype.Posting));
                                      controller.tagsearchContoller.clear();
                                      controller.searchtaglist.removeWhere(
                                          (element) =>
                                              element.id ==
                                              controller.searchtaglist
                                                  .where((element) =>
                                                      element.tag == string)
                                                  .first
                                                  .id);
                                    } else {
                                      controller.selectedtaglist.add(
                                          SelectedTagWidget(
                                              id: 0,
                                              text: string,
                                              selecttagtype:
                                                  SelectTagtype.interesting,
                                              tagtype: Tagtype.Posting));
                                      controller.tagsearchContoller.clear();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Obx(() => ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: Get.height - 44 - 129 - 400),
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    tagController.searchtaglist[index],
                                itemCount: tagController.searchtaglist.length)),
                            if (postingAddController.getTagList.value &&
                                tagController.searchtaglist.length != 10)
                              SizedBox(
                                  height: 400 -
                                      (tagController.searchtaglist.length * 40))
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addButton(
      {required String title,
      required String titleEng,
      required Function()? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: mainblue, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/add_$titleEng.svg'),
            SizedBox(width: 7),
            Text(
              '$title 첨부하기',
              style: kmain.copyWith(color: mainWhite),
            )
          ],
        ),
      ),
    );
  }

  Widget uploadButton() {
    return GestureDetector(
        onTap: () async {
          if (checkContent()) {
            loading();
            await addposting(project_id, _imageController.cropAspectRatio.value)
                .then((value) {
              Get.back();
              if (value.isError == false) {
                Post post = Post.fromJson(value.data);

                if (Get.isRegistered<ProfileController>()) {
                  Project? career =
                      ProfileController.to.myProjectList.firstWhereOrNull(
                    (career) => career.id == project_id,
                  );

                  if (career != null) {
                    career.posts.insert(0, post);
                  }
                }
                HomeController.to.onPostingRefresh();
                getbacks(3);
                dialogBack();
                AppController.to.changeBottomNav(0);
                HomeController.to.scrollToTop();

                showCustomDialog('포스팅을 업로드했어요', 1000);
              } else {
                errorSituation(value);
              }
            });
          }
        },
        child: Text('게시',
            style: kNavigationTitle.copyWith(
                color: checkContent() ? mainblue : maingray, fontSize: 17)));
  }

  bool checkContent() {
    if (postingAddController.isAddImage.value ||
        postingAddController.isAddLink.value ||
        !postingAddController.isPostingTitleEmpty.value) {
      return true;
    } else {
      return false;
    }
  }

  void imageChange() async {
    // print(postingAddController.selectedImageList);
    // print(postingAddController.selectedCropWidgetList);
    // print(postingAddController.selectedCropKeyList);
    // print("-----------");
    // print(_imageController.selectedImages);
    // print(_imageController.cropWidgetList);
    // print(_imageController.cropKeyList);
    _imageController
        .cropAspectRatio(postingAddController.cropAspectRatio.value);
    _imageController.cropKeyList
        .assignAll(postingAddController.selectedCropKeyList);
    _imageController.cropWidgetList
        .assignAll(postingAddController.selectedCropWidgetList);
    _imageController.selectedImages
        .assignAll(postingAddController.selectedImageList);

    _imageController.selectedImage(postingAddController.selectedImageList[0]);
    _imageController.selectedIndex(0);
    _imageController.isSelect(true);

    Get.to(() => UploadScreen(),
        duration: const Duration(milliseconds: 300), curve: Curves.ease);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 600)).then((value) {
        _imageController.cropKeyList.asMap().forEach((key, value) {
          int index = key;
          GlobalKey<CustomCropState> cropKey = value;

          cropKey.currentState!.scale =
              postingAddController.selectedScaleList[index];
          cropKey.currentState!.view =
              postingAddController.selectedViewList[index];
        });
      });
    });
  }
}
