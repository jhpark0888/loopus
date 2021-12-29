import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/search_student_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

class SearchScreen extends StatelessWidget {
  // const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Get.to(SearchTypingScreen());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: mainlightgrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Search_Inactive.svg',
                          width: 16,
                          height: 16,
                          color: mainblack.withOpacity(0.6),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "어떤 정보를 찾으시나요?",
                          style: TextStyle(
                            color: mainblack.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "인기 태그",
                  style: kSubTitle2Style,
                ),
                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Tagwidget(content: '공모전'),
                      Tagwidget(content: '창업'),
                      Tagwidget(content: 'SK하이닉스'),
                      Tagwidget(content: '디자인'),
                      Tagwidget(content: '개발'),
                      Tagwidget(content: '삼성'),
                      Tagwidget(content: '디자인'),
                      Tagwidget(content: '디자인'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "이 주의 학생",
                      style: kSubTitle2Style,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          content: Container(
                            height: 30,
                            child: Center(
                                child: Text(
                              "이 주의 활동 수, 포스팅 수, 답변 수 등을 점수로 환상해 매긴 순위입니다.",
                              textAlign: TextAlign.center,
                              style: kCaptionStyle,
                            )),
                          ),
                        ));
                      },
                      child: Text(
                        "선정 기준이 뭔가요?",
                        style: kButtonStyle.copyWith(color: mainblue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SearchStudentWidget(),
                      SizedBox(
                        height: 55,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
