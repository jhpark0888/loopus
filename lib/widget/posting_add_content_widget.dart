import 'package:flutter/material.dart';

class ProstingAdd_ContentWidget extends StatelessWidget {
  ProstingAdd_ContentWidget({Key? key, required String this.content})
      : super(key: key);

  String content;
  TextEditingController contentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    contentcontroller.text = content;
    return Row(children: [
      Flexible(
        child: TextField(
          cursorColor: Colors.black,
          maxLines: 5,
          controller: contentcontroller,
          style: TextStyle(
            height: 1.6,
            fontSize: 12,
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
