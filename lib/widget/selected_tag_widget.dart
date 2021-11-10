import 'package:flutter/material.dart';

class SelectedTagWidget extends StatelessWidget {
  SelectedTagWidget({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                    splashRadius: 10,
                    onPressed: () {},
                    iconSize: 16,
                    icon: Icon(
                      Icons.cancel,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
