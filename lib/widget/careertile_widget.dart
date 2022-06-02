import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
class CareerTile extends StatelessWidget {
  CareerTile({Key? key, required this.title, required this.time})
      : super(key: key);
  final RxBool isClick = false.obs;
  RxString title;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (ProfileController.to.isDelete.value == false &&
              ProfileController.to.isUpdate.value == false) {
            for (CareerTile i in ProfileController.to.careerwidget) {
              if (i.title == title) {
                i.isClick.value = true;
              } else {
                i.isClick.value = false;
              }
            }
          } else if (ProfileController.to.isDelete.value == true) {
            showButtonDialog(
                title: '삭제',
                content: '정말 삭제하시겠습니까?',
                leftFunction: () {
                  Get.back();
                },
                rightFunction: () {
                  ProfileController.to.careerwidget.removeAt(ProfileController
                      .to.careerwidget
                      .indexWhere((p0) => p0.title == title));
                  Get.back();
                },
                rightText: '삭제',
                leftText: '취소');
          } else if (ProfileController.to.isUpdate.value == true) {
            showDialogs(
                title: '수정하기',
                controller: ProfileController.to.careerUpdateController,
                leftFunction: () {
                  Get.back();
                },
                rightFunction: () {
                  ProfileController.to.careerwidget
                      .where((p0) => p0.title == title)
                      .first
                      .title
                      .value = ProfileController.to.careerUpdateController.text;
                  ProfileController.to.careerwidget
                      .where((p0) => p0.title == title)
                      .first
                      .title
                      .refresh();
                  ProfileController.to.careerwidget.refresh();
                  print(ProfileController.to.careerwidget
                      .where((p0) => p0.title == title)
                      .first
                      .title);
                  Get.back();
                  ProfileController.to.careerUpdateController.clear();
                });
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: mainblue)),
                const SizedBox(width: 12),
                Text(
                  title.value,
                  style: k15normal.copyWith(
                      fontWeight:
                          isClick.value ? FontWeight.w600 : FontWeight.w400),
                ),
                const Spacer(),
                Text(
                  '${time.year}.${time.month.toString().padLeft(2, '0')}',
                  style: k15normal.copyWith(color: maingrey.withOpacity(0.5)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showDialogs({
  required String title,
  required TextEditingController controller,
  required Function() leftFunction,
  required Function() rightFunction,
}) {
  print('ds');
  Get.dialog(AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [TextFormField(controller: controller)],
    ),
    actions: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: leftFunction,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 1,
                      color: Color(0xffe7e7e7),
                    ),
                    top: BorderSide(
                      width: 1,
                      color: Color(0xffe7e7e7),
                    ),
                  ),
                ),
                height: 48,
                child: const Center(
                  child: Text('취소', style: kBody2Style),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: rightFunction,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Color(0xffe7e7e7),
                    ),
                  ),
                ),
                height: 48,
                child: Center(
                  child: Text(
                    '추가',
                    style: kBody2Style,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ));
}

void showButtonDialog({
  required String title,
  required String content,
  required Function() leftFunction,
  required Function() rightFunction,
  required String rightText,
  required String leftText,
}) {
  Get.dialog(
    AlertDialog(
      buttonPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: leftFunction,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                      top: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                    ),
                  ),
                  height: 48,
                  child: Center(
                    child: Text(
                      leftText,
                      style: kBody2Style,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: rightFunction,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color(0xffe7e7e7),
                      ),
                    ),
                  ),
                  height: 48,
                  child: Center(
                    child: Text(
                      rightText,
                      style: kBody2Style,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: kBody2Style,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: kBody2Style,
        textAlign: TextAlign.center,
      ),
    ),
    barrierDismissible: false,
    barrierColor: mainblack.withOpacity(0.3),
  );
}
