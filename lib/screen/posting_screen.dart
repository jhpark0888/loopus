import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: lightGray,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: lightGray,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SK 서포터즈 활동을 하면서 느꼈던 것들이 있는데 그것은 바로...",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "기계공학과",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 147,
                          ),
                          Text("21.06.30")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                        color: lightGray,
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
