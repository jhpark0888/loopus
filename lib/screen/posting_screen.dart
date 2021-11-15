import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: Get.width,
                  height: 292,
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          'https://thumb.pann.com/tc_480/http://fimg4.pann.com/new/download.jsp?FileID=45110348'),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.clear)),
                        Row(children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_horiz)),
                        ]),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 100, 15, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOOPUS 앱 개발을 하면서 느꼈던 점 3가지',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Container(
                        height: 200,
                        color: mainlightgrey,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다. 속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다. 속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
