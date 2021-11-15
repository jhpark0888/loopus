import 'package:flutter/material.dart';
import 'package:loopus/widget/bookmark_question_widget.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '북마크',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.sms_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
