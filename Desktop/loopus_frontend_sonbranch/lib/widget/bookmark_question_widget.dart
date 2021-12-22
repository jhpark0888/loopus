import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';

class BookmarkQuestionWidget extends StatelessWidget {
  BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("click posting");
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: mainWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0.0, 1.0),
              color: Colors.black.withOpacity(0.1),
            ),
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0.0, 1.0),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                "SK 서포터즈 활동을 하면 좋은 점이 무엇인가요?? 헤헤",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "SK 서포터즈 활동",
              style: TextStyle(
                fontSize: 14,
                color: mainblack.withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "박도영 · ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "기계공학과",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        bookmarkController.bookmark.value == false
                            ? bookmarkController.bookmark.value = true
                            : bookmarkController.bookmark.value = false;
                      },
                      child: bookmarkController.bookmark.value == false
                          ? SvgPicture.asset("assets/icons/Mark_Default.svg")
                          : SvgPicture.asset("assets/icons/Mark_Saved.svg"),
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
