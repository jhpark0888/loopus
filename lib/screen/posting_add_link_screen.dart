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
                  if (postingAddController.scrapList != []) {
                    postingAddController.isAddLink(true);
                  } else {
                    postingAddController.isAddLink(false);
                  }
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 17.5),
                  child: Text('확인',
                      style: kNavigationTitle.copyWith(color: mainblue)),
                ))
          ],
          leading: GestureDetector(
              onTap: () {
                postingAddController.scrapList.clear();
                Get.back();
              },
              child: Container(
                  width: 10,
                  height: 16,
                  child: SvgPicture.asset(
                    'assets/icons/Back_icon.svg',
                  ))),
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
                    CustomTextField(
                        textController: postingAddController.linkcontroller,
                        hintText: '링크 주소를 입력해주세요. 최대 10개까지 가능해요',
                        validator: null,
                        obscureText: false,
                        maxLines: 1,
                        counterText: '',
                        maxLength: null,
                        onfieldSubmitted: (string) {
                          print(postingAddController.linkcontroller.text);
                          print(string);
                          if (postingAddController.scrapList
                              .where((scrapwidget) =>
                                  scrapwidget.url == changeUrl(string))
                              .isEmpty) {
                            postingAddController.scrapList.add(LinkWidget(
                              // key: Get.put(
                              //     KeyController(isTextField: false.obs).linkKey,
                              //     tag:
                              //         postingAddController.scrapList.length.toString()),
                              url: changeUrl(string),
                              widgetType: 'add',
                              // length: postingAddController.scrapList.length,
                            ));

                            postingAddController.linkcontroller.clear();
                          } else {
                            showCustomDialog('중복된 주소는 하나만 게시됩니다.', 1000);
                          }

                          print(postingAddController.scrapList);
                        }),
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
