import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/posting_screen.dart';

class HomePostingWidget extends StatelessWidget {
  // const HomePostingWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.90,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: InkWell(
        onTap: () {
          Get.to(const PostingScreen());
          print("click posting");
        },
        child: Column(
          children: [
            Container(
              height: 190,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero)),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
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
              height: 228,
              decoration: BoxDecoration(
                  color: mainlightgrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "SK 서포터즈 활동을 하면서 느꼈던 것들이 있는데 그것은 바로...",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 20),
                        child: Text(
                          "SK 서포터즈 활동",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: mainWhite,
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 24,
                        child: const Text("SK 서포터즈"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: mainWhite,
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 24,
                        child: Text("봉사"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                              "  박도영 · ",
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
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                              onTap: () {},
                              child: Icon(Icons.bookmark_border_outlined)),
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
