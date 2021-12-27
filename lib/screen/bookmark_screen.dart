import 'package:flutter/material.dart';
import 'package:loopus/widget/bookmark_question_widget.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: Color(0xffe7e7e7),
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          '북마크',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nanum',
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 16,
            bottom: 80,
          ),
          child: Column(
            children: [
              BookmarkQuestionWidget(),
              BookmarkQuestionWidget(),
              BookmarkQuestionWidget(),
              BookmarkQuestionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
