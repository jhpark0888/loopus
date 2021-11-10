import 'package:flutter/material.dart';
import 'package:loopus/controller/home_controller.dart';

class PostingDetailScreen extends StatelessWidget {
  String title;
  PostingDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: HomeController.to.posting)),
    );
  }
}
