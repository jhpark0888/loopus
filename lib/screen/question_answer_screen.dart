import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_screen.dart';

class QuestionAnswerScreen extends StatelessWidget {
  // const QuestionAnswerScreen({ Key? key }) : super(key: key);
  ProjectMakeController projectmakecontroller =
      Get.put(ProjectMakeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 236,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "내가 남긴 질문",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => QuestionAddContentScreen());
                          },
                          child: Text(
                            "질문 남기기",
                            style: TextStyle(
                              color: mainblue,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 160,
                      width: Get.width * 0.9,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      decoration: BoxDecoration(
                          color: mainlightgrey,
                          borderRadius: BorderRadius.circular(5)),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => QuestionScreen());
                          print("click posting");
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "SK 서포터즈 활동을 하면 좋은 점이 무엇인가요?? 헤헤",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: mainWhite,
                                      borderRadius: BorderRadius.circular(4)),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 24,
                                  child: const Text("SK 서포터즈"),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: mainWhite,
                                      borderRadius: BorderRadius.circular(4)),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 24,
                                  child: Text("기계공학과"),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: mainWhite,
                                      borderRadius: BorderRadius.circular(4)),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 24,
                                  child: Text("봉사"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                          child: CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl:
                                            "https://i.stack.imgur.com/l60Hf.png",
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.fill,
                                      )),
                                      const Text(
                                        "  박도영  ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "기계공학과",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: InkWell(
                                        onTap: () {
                                          print("답변하기");
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/Chat.svg"),
                                            Text(
                                              " 답변하기",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 8,
              color: mainlightgrey,
            ),
            Column(
              children: HomeController.to.qustion_posting,
            ),
          ],
        ),
      ),
    );
  }
}
