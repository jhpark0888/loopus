import 'package:flutter/material.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';

class PostingDetailScreen extends StatelessWidget {
  String title;
  PostingDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: title,
      ),
      body: SingleChildScrollView(
          child: Column(children: HomeController.to.posting)),
    );
  }
}
