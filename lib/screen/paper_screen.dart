import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PaperScreen extends StatelessWidget {
  // const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Color(0xffe7e7e7),
              height: 1,
            ),
            preferredSize: Size.fromHeight(4.0)),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: const Text(
          '추천 공고',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("bye"),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    elevation: 0.0,
                    // title: Center(child: Text("Evaluation our APP")),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: Get.width * 0.95,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    print("click");
                                  },
                                  child: (Container(
                                      width: Get.width * 0.95,
                                      height: 30,
                                      child: Center(
                                          child: Text(
                                        "메세지 보내기",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ))))),
                              Divider(
                                thickness: 2,
                                color: mainlightgrey,
                              ),
                              InkWell(
                                  onTap: () {
                                    print("click");
                                  },
                                  child: (Container(
                                      width: Get.width * 0.95,
                                      height: 30,
                                      child: Center(
                                          child: Text(
                                        "신고하기",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ))))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Center(
                            child: InkWell(
                                // onTap: () => Navigator.pop(context),
                                onTap: () {
                                  Get.back();
                                },
                                child: (Container(
                                    width: Get.width * 0.95,
                                    height: 30,
                                    child: Center(
                                        child: Text(
                                      "닫기",
                                      style: TextStyle(fontSize: 14),
                                    ))))),
                          ),
                        )
                      ],
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
