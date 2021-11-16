import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/tag_controller.dart';

class SelectedTagWidget extends StatelessWidget {
  SelectedTagWidget({Key? key, required this.text, this.id}) : super(key: key);
  TagController tagController = Get.find();

  String text;
  int? id;

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
                    onPressed: () {
                      tagController.selectedtaglist
                          .removeWhere((element) => element.id == id);
                    },
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
