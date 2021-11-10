import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/posting_screen.dart';

class RecommendPostingWidget extends StatelessWidget {
  // const HomePostingWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Get.to(const PostingScreen());
          print("click posting");
        },
        child: Column(
          children: [
            Container(
              height: 190,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://thumb.pann.com/tc_480/http://fimg4.pann.com/new/download.jsp?FileID=45110348",
                  placeholder: (context, url) => Container(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 150,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "삼성 청년 SW 아카데미 7기 모집",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Text(
                          "대한민국을 이끌어갈 SW인재를 찾습니다.",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text(
                          "모집 기간 : 10.25 ~ 11.8",
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                                child: CachedNetworkImage(
                              height: 32,
                              width: 32,
                              imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                              placeholder: (context, url) => CircleAvatar(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              fit: BoxFit.fill,
                            )),
                            const Text(
                              "  삼성 청년 SW아카데미",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  color: lightGray,
                                  borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              height: 24,
                              child: Text("광고"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
