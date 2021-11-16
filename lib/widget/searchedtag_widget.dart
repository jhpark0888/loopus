import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class SearchTagWidget extends StatelessWidget {
  SearchTagWidget({Key? key, required this.id, required this.tag, this.count})
      : super(key: key);
  ProjectMakeController projectMakeController = Get.find();

  int id;
  String tag;
  int? count;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (id == 0) {
          // projectMakeController.postmaketag();
          projectMakeController.selectedtaglist.add(SelectedTagWidget(
              id: id, text: projectMakeController.tagsearch.text));
          projectMakeController.tagsearch.clear();
        } else {
          projectMakeController.selectedtaglist.add(SelectedTagWidget(
            id: id,
            text: tag,
          ));
          projectMakeController.tagsearch.clear();
        }
      },
      leading: Icon(Icons.local_offer),
      title: Text(
        '$tag',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        count != null ? '관심도 $count' : '',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
