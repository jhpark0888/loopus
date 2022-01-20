import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/widget/smarttextfield.dart';

class EditorToolbar extends StatelessWidget {
  EditorToolbar(
      {Key? key, required this.onSelected, required this.selectedType})
      : super(key: key);

  EditorController editorController = Get.find();

  final SmartTextType selectedType;
  final ValueChanged<SmartTextType> onSelected;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
          height: kBottomNavigationBarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 1,
                color: Color(0xffe7e7e7),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(children: [
              GestureDetector(
                child: editorController.setFontSizeIcon(selectedType),
                onTap: () => editorController.setFontSizeType(selectedType),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Icon(Icons.format_quote,
                    color: selectedType == SmartTextType.QUOTE
                        ? mainblue
                        : mainblack),
                onTap: () => onSelected(SmartTextType.QUOTE),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Icon(Icons.format_list_bulleted,
                    color: selectedType == SmartTextType.BULLET
                        ? mainblue
                        : mainblack),
                onTap: () => onSelected(SmartTextType.BULLET),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Icon(Icons.image, color: mainblack),
                onTap: () async {
                  ImageController.to.isPostingImagePickerLoading.value = true;
                  await editorController
                      .insertimage(editorController.focus)
                      .then((value) => ImageController
                          .to.isPostingImagePickerLoading.value = false);
                  editorController.insert(
                      index: editorController.focus + 2,
                      type: SmartTextType.QUOTE);
                  editorController
                      .nodeAt(editorController.focus + 2)
                      .requestFocus();
                },
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Icon(Icons.link,
                    color: selectedType == SmartTextType.LINK
                        ? mainblue
                        : mainblack),
                onTap: () {
                  editorController.linkonbutton(editorController.focus);
                },
              ),
            ]),
          )),
    );
  }
}
