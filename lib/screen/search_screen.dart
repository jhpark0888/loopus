import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/search_student_widget.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "인기 태그",
                  style: kSubTitle2Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                        child: Text(
                          "공모전",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                        child: Text(
                          "창업",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                        child: Text(
                          "sk하이닉스",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                        child: Text(
                          "카카오 라이언배 공모전",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "이 주의 학생",
                      style: kSubTitle2Style,
                    ),
                    TextButton(
                        onPressed: () {
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
                          style: TextStyle(
                              color: mainblue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
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
        ));
  }
}
