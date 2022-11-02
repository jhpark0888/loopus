import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/career_detail_controller.dart';
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
import 'package:photo_manager/photo_manager.dart';
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
                    postingAddController.isAddLink.value == false
                        ? postingAddController.isAddImage.value == true
                            ? Obx(
                                () => Stack(children: [
                                  Column(
                                    children: [
                                      SwiperWidget(
                                        items:
                                            postingAddController.images.value,
                                        swiperType: SwiperType.file,
                                        aspectRatio: postingAddController
                                            .cropAspectRatio.value,
                                      ),
                                      if (postingAddController.images.length ==
                                          1)
                                        const SizedBox(height: 20)
                                    ],
                                  ),
                                  Positioned(
                                      child: GestureDetector(
                                          onTap: () => _imageChange(),
                                          child: Text('사진 수정하기',
                                              style: kmain.copyWith(
                                                  color: mainblue))),
                                      right: 16,
                                      bottom: 5)
                                ]),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 32),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: addButton(
                                          title: '이미지',
                                          titleEng: 'image',
                                          ontap: () async {
                                            if (_imageController
                                                .permissionState.isAuth) {
                                              if (_imageController
                                                  .albums.isNotEmpty) {
                                                Get.to(() => UploadScreen());
                                              } else {
                                                showCustomDialog(
                                                    "이미지가 없습니다", 1000);
                                              }
                                            } else {
                                              showCustomDialog(
                                                  "미디어 및 파일의 권한을 허용해주세요", 1000);
                                            }
                                          }),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: addButton(
                                          title: '링크',
                                          titleEng: 'link',
                                          ontap: () {
                                            Get.to(
                                                () => PostingAddLinkScreen());
                                          }),
                                    )
                                  ],
                                ),
                              )
                        : Stack(
                            children: [
                              Column(
                                children: [
                                  SwiperWidget(
                                    items: postingAddController.scrapList
                                        .map((linkwidget) => linkwidget.url)
                                        .toList(),
                                    swiperType: SwiperType.link,
                                  ),
                                  if (postingAddController.scrapList.length ==
                                      1)
                                    const SizedBox(height: 20)
                                ],
                              ),
                              Positioned(
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => PostingAddLinkScreen());
                                      },
                                      child: Text('링크 수정하기',
                                          style:
                                              kmain.copyWith(color: mainblue))),
                                  right: 16,
                                  bottom: 5)
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(),
                            LayoutBuilder(builder: (context, constraints) {
                              return NoUlTextField(
                                controller: postingAddController.textcontroller,
                                obscureText: false,
                                hintText: '내용을 입력해주세요',
                              );
                            }),
                            Divider(key: keyController.viewKey, thickness: 0.5),
                            const SizedBox(height: 32),
                            const Text('태그', style: kmainbold),
                            const SizedBox(height: 8),
                            Obx(() => tagController.selectedtaglist.isEmpty
                                ? Text('입력시 기업에게 노출될 가능성이 높아져요',
                                    style: kmain.copyWith(color: maingray))
                                : SizedBox(
                                    width: Get.width,
                                    child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        direction: Axis.horizontal,
                                        children:
                                            tagController.selectedtaglist))),
                            const SizedBox(height: 16),
                            KeyboardVisibilityTextWidget(
                              boolea: postingAddController.isTagClick,
                              controller: postingAddController
                                  .keyboardVisibilityController,
                              textfield: CustomTextField(
                                style: kmainheight,
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
                            const SizedBox(height: 16),
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
        height: 42,
        decoration: BoxDecoration(
            color: mainblue, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/add_$titleEng.svg'),
            const SizedBox(width: 8),
            Text(
              '$title 첨부하기',
              style: kmainbold.copyWith(color: mainWhite),
            )
          ],
        ),
      ),
    );
  }

  Widget uploadButton() {
    return IconButton(
      onPressed: () async {
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
              getbacks(route == PostaddRoute.bottom ? 3 : 1);
              dialogBack();
              if (route == PostaddRoute.bottom) {
                AppController.to.changeBottomNav(0);
                HomeController.to.scrollToTop();
              } else if (route == PostaddRoute.career) {
                CareerDetailController careerController =
                  Get.find(tag: project_id.toString());
                careerController.postList.add(post);
                careerController.postList.refresh();
              }

              showCustomDialog('포스팅을 업로드했어요', 1000);
            } else {
              errorSituation(value);
            }
          });
        }
      },
      icon: Text('업로드',
          style: kNavigationTitle.copyWith(
              color: checkContent() ? mainblue : maingray, fontSize: 17)),
      padding: EdgeInsets.zero,
    );
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

  void _imageChange() async {
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
