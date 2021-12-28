import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class PersonTileWidget extends StatelessWidget {
  PersonTileWidget(
      {Key? key, required this.name, required this.department, this.image})
      : super(key: key);

  String name;
  String department;
  String? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                height: 56,
                width: 56,
                imageUrl: image ?? "https://i.stack.imgur.com/l60Hf.png",
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
                  '$name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '$department',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainblack.withOpacity(0.6),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
