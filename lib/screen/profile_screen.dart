// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/widget/activity_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '박지환의 프로필',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: ClipOval(
                    child: CachedNetworkImage(
                  height: 92,
                  width: 92,
                  imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                  placeholder: (context, url) => const CircleAvatar(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  fit: BoxFit.fill,
                )),
              ),
              const Text(
                '박지환',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const Text(
                '산업경영공학과',
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      color: Colors.grey[300],
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
                      color: Colors.grey[300],
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
                      color: Colors.grey[300],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      // color: Colors.grey[400],
                      width: 170,
                      height: 36,
                      child: const Center(
                        child: Text(
                          '루프 요청하기',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      // color: Colors.grey[400],
                      width: 170,
                      height: 36,
                      child: const Center(
                        child: Text(
                          '메시지 보내기',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Divider(
                thickness: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Text(
                          '포스팅',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '36',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Text(
                          '답변',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '26',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Text(
                          '루프',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '112',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '진행중인 활동',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(Icons.add_circle_outline),
                      constraints: BoxConstraints(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Column(
                  children: [
                    ActivityWidget(),
                  ],
                ),
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '활동',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Column(
                  children: [
                    ActivityWidget(),
                    ActivityWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
