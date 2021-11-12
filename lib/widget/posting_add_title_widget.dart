import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/posting_add_controller.dart';

class PostingAdd_TitleWidget extends StatelessWidget {
  PostingAdd_TitleWidget({Key? key, required this.title}) : super(key: key);

  String title;
  TextEditingController titlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titlecontroller.text = title;
    return Row(children: [
      Flexible(
        child: TextField(
          cursorColor: Colors.black,
          controller: titlecontroller,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 15),
        child: Icon(
          Icons.view_headline,
          color: Colors.black,
        ),
      ),
    ]);
  }
}
