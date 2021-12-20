import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        width: 347,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '앱 어떻게 만들어요?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 10),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 83,
                    height: 20,
                    child: const Center(
                      child: Text(
                        '#관심태그1',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 83,
                    height: 20,
                    child: const Center(
                      child: Text(
                        '#관심태그2',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 83,
                    height: 20,
                    child: const Center(
                      child: Text(
                        '#관심태그3',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                        child: CachedNetworkImage(
                      height: 32,
                      width: 32,
                      imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                      placeholder: (context, url) => const CircleAvatar(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      fit: BoxFit.fill,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '박지환 ·',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      ' 산업경영공학과',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.textsms,
                      color: Colors.white,
                    ),
                    label: Text('2'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
