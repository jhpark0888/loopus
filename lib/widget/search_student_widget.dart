import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class SearchStudentWidget extends StatelessWidget {
  const SearchStudentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 56,
                    width: 56,
                    imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                    placeholder: (context, url) => const CircleAvatar(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '손승태',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '산업경영공학과',
                      style: TextStyle(
                        fontSize: 16,
                        color: mainblack.withOpacity(0.6),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              '1,420점',
              style: kSubTitle3Style,
            ),
          ],
        ),
      ),
    );
  }
}
