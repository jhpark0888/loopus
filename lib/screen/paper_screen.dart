import 'package:flutter/material.dart';

class PaperScreen extends StatelessWidget {
  // const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      elevation: 0,
      title: const Text(
        'Paper',
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        IconButton(onPressed: () {}, icon: Icon(Icons.near_me)),
      ],
    ));
  }
}
