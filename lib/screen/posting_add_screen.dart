// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';

class PostingAddScreen extends StatelessWidget {
  PostingAddScreen({Key? key}) : super(key: key);
  PostingAddController postingAddController = Get.put(PostingAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mainblack,
        ),
        child: PopupMenuButton<String>(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onSelected: postingAddController.choiceAction,
          itemBuilder: (BuildContext context) {
            return Constants.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ),
      // appBar: AppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Obx(
                        () => Container(
                          width: Get.width,
                          height: 292,
                          child: postingAddController.thumbnail.value.path == ""
                              ? CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpol9gKXdfW9lUlFiWuujRUhCQbw9oHVIkQ&usqp=CAU')
                              : Image.file(
                                  File(postingAddController
                                      .thumbnail.value.path),
                                  fit: BoxFit.fill,
                                ),
                        ),
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
                                  icon: Icon(Icons.arrow_back_ios_new)),
                              Text(
                                '포스팅 내용',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '올리기',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 100, 15, 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    cursorColor: Colors.black,
                                    controller:
                                        postingAddController.titlecontroller,
                                    decoration: InputDecoration(
                                        hintText: '제목을 작성해주세요',
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        border: InputBorder.none),
                                  )
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  postingAddController.getthumbnail();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                  // color: Colors.grey[400],
                                  width: 96,
                                  height: 22,
                                  child: const Center(
                                    child: Text(
                                      '썸네일 설정하기',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ];
        },
        body: Obx(
          () => ReorderableListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: postingAddController.postinglist.length,
            onReorder: postingAddController.onReorder,
            itemBuilder: (BuildContext context, int index) {
              Widget item = postingAddController.postinglist[index];
              return Dismissible(
                background: Container(
                  color: Colors.red,
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Icon(Icons.delete),
                    )
                  ]),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  postingAddController.postinglist.removeAt(index);
                },
                child: item,
                key: item.key!,
              );
            },
          ),
        ),
      ),
    );
  }
}
