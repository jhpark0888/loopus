import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Transform.translate(
      //TODO: 정확히 어떤 역할을 하는 걸까
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        child: Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              color: mainWhite,
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
                  child: selectedType == SmartTextType.QUOTE
                      ? SvgPicture.asset(
                          'assets/icons/quote_active.svg',
                        )
                      : SvgPicture.asset(
                          'assets/icons/quote_inactive.svg',
                        ),
                  onTap: () => onSelected(SmartTextType.QUOTE),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  child: SvgPicture.asset('assets/icons/bullet_point.svg',
                      color: selectedType == SmartTextType.BULLET
                          ? mainblue
                          : mainblack),
                  onTap: () => onSelected(SmartTextType.BULLET),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/icons/image_icon.svg',
                    color: mainblack,
                  ),
                  onTap: () async {
                    ImageController.to.isPostingImagePickerLoading.value = true;
                    await editorController
                        .insertimage(editorController.focus)
                        .then((value) => ImageController
                            .to.isPostingImagePickerLoading.value = false);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  child: SvgPicture.asset('assets/icons/Link.svg',
                      color: selectedType == SmartTextType.LINK
                          ? mainblue
                          : mainblack),
                  onTap: () {
                    editorController.linkonbutton(editorController.focus);
                  },
                ),
              ]),
            )),
      ),
    );
  }
}
