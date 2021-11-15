import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class BookmarkQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 160,
      width: Get.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          print("click posting");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 75,
              padding: EdgeInsets.all(12.0),
              child: Text(
                "SK 서포터즈 활동을 하면 좋은 점이 무엇인가요?? 헤헤",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Text(
                "SK 서포터즈 활동",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 4,
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
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        fit: BoxFit.fill,
                      )),
                      const Text(
                        "  박도영  ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "기계공학과",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(onTap: () {}, child: Icon(Icons.bookmark)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
