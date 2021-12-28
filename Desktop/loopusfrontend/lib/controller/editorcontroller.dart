import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/smarttextfield.dart';

class EditorController extends GetxController {
  RxList<FocusNode> nodes = <FocusNode>[].obs;
  RxList<TextEditingController> textcontrollers = <TextEditingController>[].obs;
  RxList<SmartTextType> types = <SmartTextType>[].obs;
  Rx<SmartTextType> selectedType = SmartTextType.T.obs;
  RxList<Obx> smarttextfieldlist = <Obx>[].obs;

  int get length => textcontrollers.length;
  int get focus => nodes.indexWhere((node) => node.hasFocus);
  FocusNode nodeAt(int index) => nodes.elementAt(index);
  TextEditingController textAt(int index) => textcontrollers.elementAt(index);
  SmartTextType typeAt(int index) => types.elementAt(index);

  @override
  void onInit() {
    insert(index: 0);
    // TODO: implement onInit
    super.onInit();
  }

  void setType(SmartTextType type) {
    if (selectedType.value == type) {
      selectedType(SmartTextType.T);
    } else {
      selectedType(type);
    }
    types.removeAt(focus);
    types.insert(focus, selectedType.value);
  }

  void setFocus(SmartTextType type) {
    selectedType(type);
  }

  void listupdate() {
    smarttextfieldlist(textcontrollers
        .map((element) => Obx(
              () => SmartTextField(
                type: typeAt(textcontrollers.indexOf(element)).obs,
                controller: textAt(textcontrollers.indexOf(element)),
                focusNode: nodeAt(textcontrollers.indexOf(element)),
              ),
            ))
        .toList());
  }

  void insert(
      {required int index,
      String? text,
      SmartTextType type = SmartTextType.T}) {
    final TextEditingController controller =
        TextEditingController(text: '\u200B' + (text ?? ''));
    controller.addListener(() {
      if (!controller.text.startsWith('\u200B')) {
        final int index = textcontrollers.indexOf(controller);
        if (index > 0) {
          textAt(index - 1).text += controller.text;
          textAt(index - 1).selection = TextSelection.fromPosition(TextPosition(
              offset: textAt(index - 1).text.length - controller.text.length));
          nodeAt(index - 1).requestFocus();
          textcontrollers.removeAt(index);
          nodes.removeAt(index);
          types.removeAt(index);
          listupdate();
        }
      }
      if (controller.text.contains('\n')) {
        final int index = textcontrollers.indexOf(controller);
        List<String> _split = controller.text.split('\n');
        controller.text = _split.first;
        insert(
            index: index + 1,
            text: _split.last,
            type: typeAt(index) == SmartTextType.BULLET
                ? SmartTextType.BULLET
                : SmartTextType.T);
        textAt(index + 1).selection =
            TextSelection.fromPosition(TextPosition(offset: 1));
        nodeAt(index + 1).requestFocus();
        selectedType(typeAt(index) == SmartTextType.BULLET
            ? SmartTextType.BULLET
            : SmartTextType.T);
      }
    });
    textcontrollers.insert(index, controller);
    types.insert(index, type);
    nodes.insert(index, FocusNode());
    listupdate();
  }
}
