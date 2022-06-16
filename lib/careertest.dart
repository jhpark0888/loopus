import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'model/career_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Career(),
    );
  }
}

class ProfileController extends GetxController {
  static ProfileController get to => Get.put(ProfileController());
  late RxList<Widget> careerAnalysis;
  late RxList<CareerModel> career;
  late RxList<CareerTile> careerwidget;
  TextEditingController careerAddController = TextEditingController();
  TextEditingController careerUpdateController = TextEditingController();
  final RxBool isDelete = false.obs;
  final RxBool isUpdate = false.obs;
  @override
  void onInit() async {
    careerAnalysis = [
      careerAnalysisWidget('IT', 14, 2, 12, 12),
      careerAnalysisWidget('인공지능', 14, 2, 14, -12),
      careerAnalysisWidget('디자인', 14, 2, 30, 12),
      careerAnalysisWidget('산업경영공학', 14, 2, 30, 0)
    ].obs;
    career = [
      CareerModel(title: '3학년 인공지능 스터디 기록', time: DateTime.parse('2021-08-11')),
      CareerModel(title: '루프어스 프로젝트', time: DateTime.parse('2021-10-11')),
      CareerModel(title: '4학년 데이터 분석 졸업작품', time: DateTime.parse('2021-12-11')),
      CareerModel(title: '교내 홈페이지 제작', time: DateTime.parse('2022-02-11')),
    ].obs;
    // await Future.delayed(const Duration(seconds: 1));
    careerwidget = career
        .map((element) =>
            CareerTile(title: element.title.obs, time: element.time))
        .toList()
        .obs;
    super.onInit();
  }

  Widget careerAnalysisWidget(String title, int countrywide,
      int countryVariance, int campus, int campusVariance) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Row(
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: title, style: kBody2Style.copyWith(color: mainblue)),
              const TextSpan(text: ' 분야', style: kBody2Style)
            ])),
            const SizedBox(width: 37),
            Text('전국 $countrywide%', style: kBody2Style),
            rate(countryVariance),
            const SizedBox(width: 11),
            Text('교내 $campus%', style: kBody2Style),
            rate(campusVariance)
          ],
        )
      ],
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      const SizedBox(width: 32),
      arrowDirection(variance),
      const SizedBox(width: 2),
      if (variance != 0)
        Text('${variance.abs()}%',
            style:
                k9normal.copyWith(color: variance >= 1 ? mainred : mainblue)),
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/down_arrow.svg');
    }
  }
}

class Career extends StatelessWidget {
  Career({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(thickness: 1, color: cardGray),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('커리어 분석', style: k18Semibold),
                    const SizedBox(width: 7),
                    SvgPicture.asset(
                      'assets/icons/Question.svg',
                      width: 20,
                      height: 20,
                      color: mainblack.withOpacity(0.6),
                    )
                  ],
                ),
                Column(children: controller.careerAnalysis),
                const SizedBox(height: 24),
                const Divider(thickness: 1, color: cardGray),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('커리어', style: k18Semibold),
                    const SizedBox(width: 7),
                    SvgPicture.asset(
                      'assets/icons/Question.svg',
                      width: 20,
                      height: 20,
                      color: mainblack.withOpacity(0.6),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          controller.isDelete(false);
                          controller.isUpdate(false);
                          showDialogs(
                              title: '추가하기',
                              controller: controller.careerAddController,
                              leftFunction: () {
                                Get.back();
                              },
                              rightFunction: () {
                                ProfileController.to.careerwidget.add(
                                    CareerTile(
                                        title: ProfileController
                                            .to.careerAddController.text.obs,
                                        time: DateTime.now()));

                                controller.careerAddController.clear();
                                Get.back();
                              });
                        },
                        icon: const Text('추가')),
                    IconButton(
                        onPressed: () {
                          controller.isUpdate(true);
                          controller.isDelete(false);
                        },
                        icon: const Text('수정')),
                    IconButton(
                        onPressed: () {
                          controller.isDelete(true);
                          controller.isUpdate(false);
                        },
                        icon: const Text('삭제'))
                  ],
                ),
                Column(children: controller.careerwidget.toList()),
                const SizedBox(height: 24),
                const Divider(thickness: 1, color: cardGray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

const mainblack = Color(0xFF263238);
const mainred = Color(0xFFF70D4D);
const cardGray = Color(0xFFF5F5F5);
const maingrey = Color(0xFF5A5A5A);
const mainblue = Color(0xFF2199FC);
const k18Semibold = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: mainblack,
  height: 1.5,
  fontFamily: 'SUIT',
);
const kBody2Style = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: mainblack,
  fontFamily: 'SUIT',
);
const k9normal = TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.w400,
  color: mainblack,
  fontFamily: 'SUIT',
);
const k15normal = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: mainblack,
  fontFamily: 'SUIT',
);

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
