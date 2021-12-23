import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/posting_screen.dart';

class ProjectPostingWidget extends StatelessWidget {
  ProjectPostingWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  Post post;

  @override
  Widget build(BuildContext context) {
    print(post.title);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () {
          Get.to(() => PostingScreen(post: post));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 347,
                height: 190,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpol9gKXdfW9lUlFiWuujRUhCQbw9oHVIkQ&usqp=CAU',
                        ),
                        fit: BoxFit.cover)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Text(
                post.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
            //   child: Text(
            //     post.id,
            //     style: TextStyle(
            //       fontSize: 14,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${post.date.year}.${post.date.month}.${post.date.day}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      FavoriteButton(iconSize: 40, valueChanged: () {}),
                      Text(
                        '999+',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.bookmark_outline))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
