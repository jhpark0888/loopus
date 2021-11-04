import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class HomePostingWidget extends StatelessWidget {
  // const HomePostingWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          print("click posting");
        },
        child: Column(
          children: [
            Container(
              height: 186,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "SK 서포터즈 활동을 하면서 느꼈던 것들이 있는데 그것은 바로...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 12,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 24,
                  color: lightGray,
                  child: const Text("SK 서포터즈"),
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 24,
                  color: lightGray,
                  child: Text("기계공학과"),
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 24,
                  color: lightGray,
                  child: Text("봉사"),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              height: 45,
              child: Row(
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "기계공학과",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Expanded(
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark_border_outlined)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
