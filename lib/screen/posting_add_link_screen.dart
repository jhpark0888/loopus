import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';

class PostingAddLinkScreen extends StatefulWidget {
  PostingAddLinkScreen({Key? key}) : super(key: key);

  @override
  State<PostingAddLinkScreen> createState() => _PostingAddLinkScreenState();
}

class _PostingAddLinkScreenState extends State<PostingAddLinkScreen> {
  PostingAddController postingAddController =
      Get.put(PostingAddController(route: PostaddRoute.bottom));

  void addLink() {
    if (postingAddController.linkcontroller.text.trim().isNotEmpty) {
      if (postingAddController.scrapList
          .where((scrapwidget) =>
              scrapwidget.url ==
              changeUrl(postingAddController.linkcontroller.text))
          .isEmpty) {
        postingAddController.scrapList.add(LinkWidget(
          url: changeUrl(postingAddController.linkcontroller.text),
          widgetType: 'add',
        ));

        postingAddController.linkcontroller.clear();
      } else {
        showCustomDialog('중복된 주소는 하나만 게시됩니다.', 1000);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: '링크 첨부',
          bottomBorder: false,
          actions: [
            GestureDetector(
                onTap: () {
                  if (postingAddController.scrapList.isNotEmpty) {
                    postingAddController.isAddLink(true);
                    Get.back();
                  } else {
                    postingAddController.isAddLink(false);
                    showCustomDialog("링크를 추가해주세요", 1000);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 17.5),
                  child: Obx(
                    () => Text('확인',
                        style: kNavigationTitle.copyWith(
                            color:
                                postingAddController.scrapList.value.isNotEmpty
                                    ? mainblue
                                    : mainblack.withOpacity(0.5))),
                  ),
                ))
          ],

          // ],
          // leading: GestureDetector(
          //     onTap: () {
          //       postingAddController.scrapList.clear();
          //       Get.back();
          //     },
          //     child: Container(
          //         width: 10,
          //         height: 16,
          //         child: SvgPicture.asset(
          //           'assets/icons/Back_icon.svg',
          //         ))),
        ),
        body: ScrollNoneffectWidget(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('링크', style: k16Normal),
                    const SizedBox(height: 14),
                    Obx(
                      () => CustomTextField(
                          textController: postingAddController.linkcontroller,
                          hintText: '링크 주소를 입력해주세요. 최대 10개까지 가능해요',
                          validator: null,
                          obscureText: false,
                          maxLines: 1,
                          counterText: '',
                          maxLength: null,
                          suffix: postingAddController.isLinkTextEmpty.value
                              ? null
                              : GestureDetector(
                                  onTap: addLink,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Text(
                                      "추가하기",
                                      style: kmain.copyWith(color: mainblue),
                                    ),
                                  ),
                                ),
                          onfieldSubmitted: (string) {
                            addLink();
                          }),
                    ),
                    const SizedBox(height: 24),
                    Obx(() => Column(
                        children: postingAddController.scrapList
                            .map((element) => Column(children: [
                                  element,
                                  const SizedBox(height: 14)
                                ]))
                            .toList()
                            .reversed
                            .toList()))
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  String changeUrl(String url) {
    if (url.contains('https')) {
      return url;
    } else if (url.contains('http')) {
      return url.replaceAll('http', 'https');
    } else {
      return 'https://' + url;
    }
  }
}
