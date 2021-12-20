import 'package:flutter/material.dart';

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
    ));
  }
}
